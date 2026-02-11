local M = {}

function M.setup()
  vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { noremap = true, silent = true })
  vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { noremap = true, silent = true })
  vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { noremap = true, silent = true })
  vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { noremap = true, silent = true })
  vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>dr", function() require("dap").repl.open() end, { noremap = true, silent = true })
  vim.keymap.set("n", "<Leader>dl", function() require("dap").run_last() end, { noremap = true, silent = true })
end

return M
