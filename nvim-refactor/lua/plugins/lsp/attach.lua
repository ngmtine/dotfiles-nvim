local M = {}

local function setup_format_on_save(bufnr)
  if vim.b[bufnr].refactor_format_on_save then
    return
  end
  vim.b[bufnr].refactor_format_on_save = true

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("RefactorFormatOnSave" .. bufnr, { clear = true }),
    buffer = bufnr,
    callback = function()
      if vim.bo[bufnr].buftype ~= "" then
        return
      end
      require("plugins.lsp.format").format(bufnr, {
        write_before = false,
        sync_buffer = true,
        use_stdin = true,
      })
    end,
  })
end

function M.on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>f", function()
    require("plugins.lsp.format").format(bufnr, {
      write_before = true,
      sync_buffer = true,
    })
  end, opts)

  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  setup_format_on_save(bufnr)
end

function M.setup_autocmd()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("RefactorLspAttach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end
      require("plugins.lsp.attach").on_attach(client, args.buf)
    end,
  })
end

return M
