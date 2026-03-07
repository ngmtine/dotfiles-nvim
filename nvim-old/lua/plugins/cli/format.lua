local U = require("utils")

-- フォーマット実行コマンド
vim.api.nvim_create_user_command("Format", function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Get formatter for the current buffer
    local tools = {}
    -- 1. VSCode設定を最優先で確認
    local vscode_formatter = U.get_vscode_formatter()
    if vscode_formatter == "biome" then
        U.find_formatter_config({ "biome.json" }) -- biome.jsonの存在を明示的にチェック
        tools.formatter = "biome"
    elseif vscode_formatter == "prettier" then
        tools.formatter = "prettier"
    end

    -- 2. VSCode設定がない場合、ツール設定ファイルを確認
    if vim.tbl_isempty(tools) then
        local biome_config = U.find_formatter_config({ "biome.json" })
        local prettier_config = U.find_formatter_config({
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.cjs",
            "prettier.config.js",
            "prettier.config.cjs",
        })

        if biome_config then
            tools.formatter = "biome"
        elseif prettier_config then
            tools.formatter = "prettier"
        end
    end

    -- 3. どの設定も見つからない場合はPrettierをデフォルトにする
    if vim.tbl_isempty(tools) then
        tools.formatter = "prettier"
    end

    -- Check if formatter is installed
    if tools.formatter and vim.fn.executable(tools.formatter) ~= 1 then
        vim.notify(tools.formatter .. " is not installed. Please install it.", vim.log.levels.ERROR)
        return
    end

    vim.lsp.buf.format({
        bufnr = bufnr,
        async = false,
        timeout_ms = 2000,
    })
    local msg = "[format] Formatting buffer " .. bufnr .. "..."
    vim.notify(msg)
end, {
    desc = "Format current buffer using LSP",
    nargs = 0,
})

-- フォーマットせずに保存するコマンド
vim.api.nvim_create_user_command("SaveWithoutFormat", function()
    vim.cmd("noautocmd write") -- ちなみに :noautocmd wall だと全バッファが対象
    local msg = "[format] Saved buffer without triggering autocommands."
    vim.notify(msg)
end, {
    desc = "Save current buffer without triggering autocommands",
    nargs = 0,
})
