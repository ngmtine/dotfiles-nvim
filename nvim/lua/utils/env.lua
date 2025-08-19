local M = {}

M.is_vscode = (vim.g.vscode == 1)
M.is_windows = (vim.fn.has("win32") == 1)
M.is_mac = (vim.fn.has("macunix") == 1)
M.is_linux = (vim.fn.has("unix") == 1 and not M.is_mac)
M.is_wsl = (vim.fn.has("wsl") == 1)

return M
