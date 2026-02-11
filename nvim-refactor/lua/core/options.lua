local env = require("core.env")

vim.opt.exrc = true
vim.opt.fileencodings = "utf-8,sjis"

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.showtabline = 2
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 100

vim.opt.list = true
vim.opt.listchars = { tab = "-> ", lead = ".", trail = ".", eol = "$" }

vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

if env.is_wsl then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
end

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
