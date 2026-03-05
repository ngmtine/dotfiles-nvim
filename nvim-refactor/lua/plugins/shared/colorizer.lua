local M = {}

function M.setup()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end

  colorizer.setup()
end

return M
