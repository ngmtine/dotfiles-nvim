-- フォーマット実行コマンド
vim.api.nvim_create_user_command(
    "Format",
    function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            timeout_ms = 2000
        })
        local msg = "[format] Formatting buffer " .. bufnr .. "..."
        vim.notify(msg)
    end,
    {
        desc = "Format current buffer using LSP",
        nargs = 0
    }
)

-- フォーマットせずに保存するコマンド
vim.api.nvim_create_user_command(
    "SaveWithoutFormat",
    function()
        vim.cmd("noautocmd write") -- ちなみに :noautocmd wall だと全バッファが対象
        local msg = "[format] Saved buffer without triggering autocommands."
        vim.notify(msg)
    end,
    {
        desc = "Save current buffer without triggering autocommands",
        nargs = 0
    }
)
