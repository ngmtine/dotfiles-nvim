local M = {}

function M.setup()
  local ok_map, dial_map = pcall(require, "dial.map")
  if not ok_map then
    return
  end

  vim.keymap.set("n", "<C-a>", dial_map.inc_normal(), { noremap = true })
  vim.keymap.set("v", "<C-a>", dial_map.inc_normal(), { noremap = true })
  vim.keymap.set("n", "<C-x>", dial_map.dec_normal(), { noremap = true })
  vim.keymap.set("v", "<C-x>", dial_map.dec_normal(), { noremap = true })

  local augend = require("dial.augend")

  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%m/%d"],
      augend.date.alias["%-m/%-d"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%Y年%-m月%-d日"],
      augend.date.alias["%Y年%-m月%-d日(%ja)"],
      augend.date.alias["%H:%M:%S"],
      augend.date.alias["%H:%M"],
      augend.constant.alias.ja_weekday,
      augend.constant.alias.ja_weekday_full,
      augend.constant.alias.bool,
    },
  })
end

return M
