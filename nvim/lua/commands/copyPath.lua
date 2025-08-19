-- 開いているファイルのフルパスをコピー
vim.api.nvim_create_user_command("CopyPath", function()
    local filepath = vim.fn.expand('%:p')

    if filepath == "" then
        print("No file path to copy.")
        return
    end

    vim.fn.setreg("+", filepath)
    vim.fn.setreg("*", filepath)

    local msg = "[copyPath] Copied file path: " .. filepath
    vim.notify(msg)
end, {})
