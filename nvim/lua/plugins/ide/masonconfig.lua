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
    automatic_installation = true,
    handlers = {
        -- 各サーバーの設定を静的に記述する
        ["lua_ls"] = function()
            local opts = vim.deepcopy(common_opts)
            opts.settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    max_line_length = 200,
                },
            }
            lspconfig.lua_ls.setup(opts)
        end,

        ["ts_ls"] = function()
            lspconfig.ts_ls.setup(common_opts)
        end,

        ["bashls"] = function()
            lspconfig.bashls.setup(common_opts)
        end,

        ["efm"] = function()
            local efm_config = require("plugins.ide.efm_config")
            local opts = vim.deepcopy(common_opts)
            opts.settings = efm_config.settings
            opts.init_options = efm_config.init_options
            opts.filetypes = efm_config.filetypes
            lspconfig.efm.setup(opts)
        end,
    },
})
