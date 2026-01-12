local keymap_lsp = require("core.keymap")

-- masonのセットアップ
require("mason").setup({
    ensure_installed = {
        "beautysh", -- shell script formatter
    },
    ui = { border = "rounded" },
})

-- サーバーのリスト
local servers = {
    "lua_ls",
    "ts_ls",
    "bashls",
    "efm",
}

-- 共通の on_attach 関数
local on_attach = function(client, bufnr)
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
                local format_client_name

                local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
                if filetype == 'lua' then
                    format_client_name = "lua_ls"
                elseif filetype == 'sh' then
                    -- beautysh を使うのでLSPフォーマットは不要
                    return
                else
                    -- javascript, typescript など
                    format_client_name = "efm"
                end

                vim.lsp.buf.format({
                    filter = function(c) return c.name == format_client_name end,
                    bufnr = bufnr,
                    async = false,
                })
            end,
        })
    end

    local msg = string.format("[LSP] '%s' attached to buffer %d", client.name, bufnr)
    vim.notify(msg, vim.log.levels.INFO, { title = "LSP Attach" })
end

-- lspconfig と capabilities を先に require
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 共通のオプション
local common_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- mason-lspconfigのセットアップ
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = false, -- handlerを確実に実行するために無効化
})

-- 各LSPサーバーを手動でセットアップ
vim.notify("[masonconfig] Setting up LSP servers manually", vim.log.levels.WARN)

-- lua_ls
local opts = vim.deepcopy(common_opts)
opts.settings = {
    Lua = {
        diagnostics = { globals = { "vim" } },
        max_line_length = 200,
    },
}
lspconfig.lua_ls.setup(opts)
vim.notify("[masonconfig] lua_ls setup complete", vim.log.levels.WARN)

-- ts_ls
lspconfig.ts_ls.setup(common_opts)
vim.notify("[masonconfig] ts_ls setup complete", vim.log.levels.WARN)

-- bashls
lspconfig.bashls.setup(common_opts)
vim.notify("[masonconfig] bashls setup complete", vim.log.levels.WARN)

-- efm
vim.notify("[masonconfig] Setting up EFM...", vim.log.levels.WARN)
local efm_config = require("plugins.ide.efm_config")
local efm_opts = vim.deepcopy(common_opts)
efm_opts.init_options = efm_config.init_options
efm_opts.filetypes = efm_config.filetypes

-- root_dirをプロジェクトルートごとに設定（package.jsonのみを探す）
efm_opts.root_dir = function(fname)
    local root = lspconfig.util.root_pattern('package.json')(fname)
    vim.notify(string.format("[EFM] root_dir for '%s' = '%s'", fname, root or "nil"), vim.log.levels.WARN)
    return root
end

-- on_new_config: 新しいバッファでLSPクライアント起動時に設定を構築
efm_opts.on_new_config = function(new_config, new_root_dir)
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
end

lspconfig.efm.setup(efm_opts)
vim.notify("[masonconfig] EFM setup complete", vim.log.levels.WARN)
