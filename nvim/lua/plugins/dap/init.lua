local M = {}

function M.setup()
  local ok_dap, dap = pcall(require, "dap")
  local ok_dapui, dapui = pcall(require, "dapui")
  if not ok_dap or not ok_dapui then
    return
  end

  dapui.setup()

  vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = ">", texthl = "", linehl = "", numhl = "" })

  require("plugins.dap.adapters").setup()
  require("plugins.dap.keymaps").setup()

  dap.listeners.before.event_initialized["refactor_dapui"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["refactor_dapui"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["refactor_dapui"] = function()
    dapui.close()
  end
end

return M
