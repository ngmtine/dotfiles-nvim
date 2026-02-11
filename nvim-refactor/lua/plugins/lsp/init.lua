local M = {}
local BIOME_VERSION = "2.3.14"

function M.setup_mason()
  local ok, mason = pcall(require, "mason")
  if not ok then
    return
  end

  mason.setup({
    ui = { border = "rounded" },
  })
end

function M.setup_tools()
  local ok, tool_installer = pcall(require, "mason-tool-installer")
  if not ok then
    return
  end

  tool_installer.setup({
    ensure_installed = {
      "lua-language-server",
      "typescript-language-server",
      "pyright",
      "bash-language-server",
      "ruff",
      { "biome", version = BIOME_VERSION },
      "debugpy",
      "js-debug-adapter",
      "local-lua-debugger-vscode",
      "bash-debug-adapter",
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 24,
  })
end

function M.setup_lsp()
  require("plugins.lsp.servers").setup()
  require("plugins.lsp.attach").setup_autocmd()
end

return M
