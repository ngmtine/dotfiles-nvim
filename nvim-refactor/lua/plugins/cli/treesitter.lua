local M = {}

function M.setup()
  local ok, configs = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return
  end

  configs.setup({
    ensure_installed = { "vim", "vimdoc", "query", "lua", "javascript", "typescript", "tsx", "python", "bash" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  })
end

return M
