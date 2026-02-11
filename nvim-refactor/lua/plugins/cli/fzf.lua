local M = {}

function M.setup()
  vim.keymap.set("n", "<c-p>", "<cmd>lua require('fzf-lua').files()<cr>", { desc = "fzf files" })
end

return M
