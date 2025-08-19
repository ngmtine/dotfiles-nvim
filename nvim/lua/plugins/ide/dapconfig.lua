local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- アイコン
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "👉️", texthl = "", linehl = "", numhl = "" })

-- キーバインド
vim.api.nvim_set_keymap("n", "<F5>", [[<Cmd>lua require"dap".continue()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F9>", [[<Cmd>lua require"dap".toggle_breakpoint()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F10>", [[<Cmd>lua require"dap".step_over()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F11>", [[<Cmd>lua require"dap".step_into()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F12>", [[<Cmd>lua require"dap".step_out()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>B",
    [[<Cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>]],
    { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>lp",
    [[<Cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>]],
    { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dr", [[<Cmd>lua require"dap".repl.open()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dl", [[<Cmd>lua require"dap".run_last()<CR>]], { noremap = true, silent = true })

-- デバッグ開始時にui自動起動
dap.listeners.before["event_initialized"]["custom"] = function(session, body)
    dapui.open()
end

-- デバッグ終了時にui自動終了
dap.listeners.before["event_terminated"]["custom"] = function(session, body)
    dapui.close()
end
