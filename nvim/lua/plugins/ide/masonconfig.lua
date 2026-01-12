local keymap_lsp = require("core.keymap")

-- masonのセットアップ
require("mason").setup({
    ui = { border = "rounded" },
})

-- サーバーのリスト
local servers = {
    "lua_ls",
    "ts_ls",
    "bashls",
    "efm",
    "stylua",
}

-- capabilities を設定
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- mason-lspconfigのセットアップ
require("mason-lspconfig").setup({
    ensure_installed = servers,
})

-- vim.lsp.configの設定
vim.notify("[masonconfig] Setting up LSP servers with vim.lsp.config", vim.log.levels.WARN)

-- lua_ls
vim.lsp.config.lua_ls = {
    capabilities = capabilities,
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            max_line_length = 200,
        },
    },
}
vim.notify("[masonconfig] lua_ls config complete", vim.log.levels.WARN)

-- ts_ls
vim.lsp.config.ts_ls = {
    capabilities = capabilities,
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
}
vim.notify("[masonconfig] ts_ls config complete", vim.log.levels.WARN)

-- bashls
vim.lsp.config.bashls = {
    capabilities = capabilities,
    filetypes = { "sh" },
    root_markers = { ".git" },
}
vim.notify("[masonconfig] bashls config complete", vim.log.levels.WARN)

-- efm
vim.notify("[masonconfig] Setting up EFM...", vim.log.levels.WARN)
local efm_config = require("plugins.ide.efm_config")
vim.lsp.config.efm = {
    capabilities = capabilities,
    init_options = efm_config.init_options,
    filetypes = efm_config.filetypes,
    -- root_dirをプロジェクトルートごとに設定（package.jsonのみを探す）
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.root(fname, { "package.json" })
        vim.notify(string.format("[EFM] root_dir for '%s' = '%s'", fname, root or "nil"), vim.log.levels.WARN)
        on_dir(root)
    end,
    -- on_new_config: 新しいバッファでLSPクライアント起動時に設定を構築
    on_new_config = function(new_config, new_root_dir)
        vim.notify("[EFM] on_new_config called for root_dir: " .. new_root_dir, vim.log.levels.WARN)

        -- 新しいバッファのプロジェクトルートに基づいて設定を構築
        new_config.settings = efm_config.build_settings(nil, new_root_dir)

        -- デバッグ: 構築された設定を確認
        if new_config.settings and new_config.settings.languages then
            local lang_count = 0
            for _ in pairs(new_config.settings.languages) do
                lang_count = lang_count + 1
            end
            vim.notify(string.format("[EFM] Settings built with %d languages", lang_count), vim.log.levels.WARN)
        else
            vim.notify("[EFM] WARNING: Settings not built correctly!", vim.log.levels.WARN)
        end
    end,
}
vim.notify("[masonconfig] EFM config complete", vim.log.levels.WARN)

-- LSPを有効化
vim.lsp.enable(servers)

-- LspAttach autocmdでon_attachロジック
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspAttachGroup", {}),
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- 共通のキーマップを設定
        keymap_lsp(bufnr)

        -- ts_ls の場合、フォーマット機能を無効化
        if client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end

        -- efm の場合、バッファごとに設定を再構築して送信
        if client.name == "efm" then
            local efm_config = require("plugins.ide.efm_config")
            local root_dir = client.config.root_dir

            vim.notify(string.format("[EFM] on_attach: Sending settings for root_dir: %s", root_dir), vim.log.levels.WARN)

            local settings = efm_config.build_settings(bufnr, root_dir)
            client.notify("workspace/didChangeConfiguration", { settings = settings })

            vim.notify("[EFM] Settings sent successfully", vim.log.levels.WARN)
        end

        -- 保存時フォーマットのautocmd
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                buffer = bufnr,
                callback = function()
                    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                    if filetype == "lua" then
                        -- luaファイルの場合、styluaを使ってフォーマット
                        local stylua_path = vim.fn.stdpath("data") .. "/mason/bin/stylua"
                        local file_path = vim.api.nvim_buf_get_name(bufnr)
                        vim.fn.system(stylua_path .. " " .. vim.fn.shellescape(file_path))
                    elseif filetype == "sh" then
                        -- beautysh を使うのでLSPフォーマットは不要
                        return
                    else
                        -- javascript, typescript など、efmでフォーマット
                        vim.lsp.buf.format({
                            filter = function(c)
                                return c.name == "efm"
                            end,
                            bufnr = bufnr,
                            async = false,
                        })
                    end
                end,
            })
        end

        local msg = string.format("[LSP] '%s' attached to buffer %d", client.name, bufnr)
        vim.notify(msg, vim.log.levels.INFO, { title = "LSP Attach" })
    end,
})
