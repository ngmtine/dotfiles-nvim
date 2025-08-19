vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDSpaceDelims = 1
vim.g.NERDDefaultAlign = "left" -- インデント維持

-- windows環境では/の指定に_を使用するっぽい
vim.keymap.set("n", "<c-_>", "<plug>NERDCommenterToggle")
vim.keymap.set("v", "<c-_>", "<plug>NERDCommenterToggle")

