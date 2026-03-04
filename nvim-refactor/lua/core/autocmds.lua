vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.fish",
  callback = function()
    vim.opt.filetype = "sh"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt.formatoptions = "jql"
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("RefactorAutoMkdir", { clear = true }),
  pattern = "*",
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    if dir == "" or vim.fn.isdirectory(dir) == 1 then
      return
    end

    if vim.v.cmdbang > 0 or vim.fn.confirm(('Directory "%s" does not exist. Create it?'):format(dir), "&Yes\n&No", 2) == 1 then
      vim.fn.mkdir(dir, "p")
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.cmd('silent! normal! g`"zv')
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- :s<Space> で :%s///g に展開
-- https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
vim.cmd([[
  cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])
