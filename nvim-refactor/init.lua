local env = require("core.env")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("core.autocmds")

require("config.lazy")
require("config.plugins").setup(env)
