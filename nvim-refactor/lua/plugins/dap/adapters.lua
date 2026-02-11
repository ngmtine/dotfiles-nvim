local M = {}

local function mason_path(...)
  return table.concat({ vim.fn.stdpath("data"), "mason", ... }, "/")
end

function M.setup()
  local dap = require("dap")

  dap.adapters["pwa-node"] = {
    type = "executable",
    command = "js-debug-adapter",
  }

  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = dap.configurations.javascript

  dap.adapters.python = {
    type = "executable",
    command = "debugpy-adapter",
  }

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      console = "integratedTerminal",
    },
  }

  dap.adapters["local-lua"] = {
    type = "executable",
    command = "node",
    args = { mason_path("packages", "local-lua-debugger-vscode", "extension", "debugAdapter.js") },
    enrich_config = function(config, on_config)
      if not config.extensionPath then
        config.extensionPath = mason_path("packages", "local-lua-debugger-vscode", "extension")
      end
      on_config(config)
    end,
  }

  dap.configurations.lua = {
    {
      type = "local-lua",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }

  dap.adapters.bashdb = {
    type = "executable",
    command = "bash-debug-adapter",
    name = "bashdb",
  }

  dap.configurations.sh = {
    {
      type = "bashdb",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      pathBashdb = "bashdb",
      pathBashdbLib = mason_path("packages", "bash-debug-adapter", "extension", "bashdb_dir"),
      pathBash = "bash",
      pathCat = "cat",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      env = {},
      args = {},
      terminalKind = "integrated",
    },
  }

  dap.configurations.bash = dap.configurations.sh
  dap.configurations.zsh = dap.configurations.sh
end

return M
