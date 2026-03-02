vim.keymap.set("n", "<tab>", ":bn<cr>")
vim.keymap.set("n", "<s-tab>", ":bp<cr>")
vim.keymap.set("n", "<s-y>", "y$")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "<c-a>", "<c-o>^")
vim.keymap.set("i", "<c-e>", "<esc>$i<right>")
vim.keymap.set("i", "<c-k>", "<esc><right>d$a")
vim.keymap.set("n", "U", "<c-r>", { desc = "Redo" })
vim.keymap.set("n", "<", "<<")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "<c-l>", ":<c-u>nohlsearch<cr><c-l>")
vim.keymap.set("c", "<c-a>", "<home>")
vim.keymap.set("c", "<c-e>", "<end>")
vim.keymap.set("n", "*", "*N")
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })

vim.keymap.set("n", "<Leader>rep", '"_dw"+P')
vim.keymap.set("v", "<Leader>rep", '"_d"+P')
vim.keymap.set("n", "<Leader>a", "ggVG")
vim.keymap.set("n", "<c-w>n", ":vnew<cr>", { desc = "open buffer in right split" })

vim.keymap.set("n", "<Leader>x", function()
  local buf = vim.api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  if #bufs > 1 then
    vim.cmd("bp")
    vim.api.nvim_buf_delete(buf, {})
  else
    vim.cmd("enew")
    vim.api.nvim_buf_delete(buf, {})
  end
end, { desc = "Close buffer" })
