pcall(vim.api.nvim_command, "colorscheme iceberg")

-- 背景色無効（windows terminal, weztermで背景色透過）
vim.api.nvim_command("hi normal guibg=none")

-- コメントアウトの文字色と（たぶん）同じ色
local comment_color = "#5c6370"

-- NonText 終端記号とか でも表示すると微妙に邪魔
-- vim.cmd("highlight NonText NONE")
-- vim.cmd("highlight NonText guifg=" .. comment_color)

-- Whitespace タブ可視化のやつ
vim.cmd("highlight Whitespace NONE")
vim.cmd("highlight Whitespace guifg=" .. comment_color)

-- SpecialKey よくわからん
-- vim.cmd("highlight SpecialKey NONE")
-- vim.cmd("highlight SpecialKey guifg=" .. comment_color)

-- NOTE: タブ文字は c-v tab で入力できる
