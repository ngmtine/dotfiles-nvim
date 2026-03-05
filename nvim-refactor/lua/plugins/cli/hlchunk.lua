local M = {}

function M.setup()
  local ok, hlchunk = pcall(require, "hlchunk")
  if not ok then
    return
  end

  hlchunk.setup({
    chunk = {
      enable = true,
      use_treesitter = true,
      chars = {
        horizontal_line = "═",
        vertical_line = "║",
        left_top = "╔",
        left_bottom = "╚",
        right_arrow = "▶",
      },
      duration = 100,
      delay = 100,
      textobject = "ac",
    },
    indent = {
      enable = false,
      use_treesitter = false,
    },
    line_num = {
      enable = true,
      use_treesitter = true,
    },
  })
end

return M
