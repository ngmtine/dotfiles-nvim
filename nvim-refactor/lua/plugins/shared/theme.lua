local M = {}

function M.setup()
  vim.cmd.colorscheme("iceberg")

  local transparent_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "EndOfBuffer",
    "TabLineFill",
  }
  for _, group in ipairs(transparent_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    hl.bg = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return M
