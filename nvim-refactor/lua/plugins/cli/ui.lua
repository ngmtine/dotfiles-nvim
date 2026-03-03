local M = {}

function M.setup_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  lualine.setup({
    options = {
      theme = "iceberg",
      section_separators = "",
      component_separators = "|",
    },
  })
end

function M.setup_bufferline()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then
    return
  end

  bufferline.setup({
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "slant",
    },
    highlights = {
      fill = { fg = "NONE" },
    },
  })
end

return M
