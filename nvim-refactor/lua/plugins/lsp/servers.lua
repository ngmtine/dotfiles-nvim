local M = {}

function M.setup()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  vim.lsp.config.lua_ls = {
    capabilities = capabilities,
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  }

  vim.lsp.config.ts_ls = {
    capabilities = capabilities,
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
  }

  vim.lsp.config.pyright = {
    capabilities = capabilities,
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
  }

  vim.lsp.config.bashls = {
    capabilities = capabilities,
    filetypes = { "sh", "bash", "zsh" },
    root_markers = { ".git" },
  }

  vim.lsp.config.biome = {
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
    root_markers = { "biome.json", "biome.jsonc", "package.json", ".git" },
  }

  vim.lsp.enable({ "lua_ls", "ts_ls", "pyright", "bashls", "biome" })
end

return M
