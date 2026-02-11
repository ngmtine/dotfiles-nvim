local M = {}

local js_like = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  json = true,
  jsonc = true,
}

local function find_upward(names, startpath)
  local found = vim.fs.find(names, { upward = true, path = startpath })
  return found[1]
end

local function run_cmd(cmd)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(result, vim.log.levels.ERROR)
    return false
  end
  return true
end

local function format_python(filepath)
  local ruff = vim.fn.exepath("ruff")
  if ruff == "" then
    local mason_ruff = vim.fn.stdpath("data") .. "/mason/bin/ruff"
    if vim.fn.executable(mason_ruff) == 1 then
      ruff = mason_ruff
    end
  end

  if ruff == "" then
    vim.notify("ruff not found", vim.log.levels.WARN)
    return
  end

  run_cmd({ ruff, "format", filepath })
  vim.cmd("checktime")
end

local function format_js(filepath)
  local root = vim.fs.root(filepath, { "biome.json", "biome.jsonc", "package.json", ".git" })
  local base = root or vim.fn.fnamemodify(filepath, ":p:h")

  local biome_cfg = find_upward({ "biome.json", "biome.jsonc" }, base)
  local prettier_cfg = find_upward({ ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js", "prettier.config.cjs" }, base)
  local eslint_cfg = find_upward({ ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs", "eslint.config.js", "eslint.config.cjs", "eslint.config.mjs" }, base)

  local biome = vim.fn.exepath("biome")
  if biome == "" then
    local mason_biome = vim.fn.stdpath("data") .. "/mason/bin/biome"
    if vim.fn.executable(mason_biome) == 1 then
      biome = mason_biome
    end
  end

  if biome_cfg then
    if biome ~= "" then
      run_cmd({ biome, "format", "--write", filepath })
      vim.cmd("checktime")
      return
    end
    vim.notify("biome not found", vim.log.levels.WARN)
    return
  end

  if prettier_cfg then
    local prettier = vim.fn.exepath("prettier")
    if prettier ~= "" then
      run_cmd({ prettier, "--write", filepath })
      vim.cmd("checktime")
      return
    end
  end

  if eslint_cfg then
    local eslint = vim.fn.exepath("eslint")
    if eslint ~= "" then
      run_cmd({ eslint, "--fix", filepath })
      vim.cmd("checktime")
      return
    end
  end

  if biome ~= "" then
    local fallback = vim.fn.stdpath("config") .. "/biome/biome.json"
    run_cmd({ biome, "format", "--config-path", fallback, "--write", filepath })
    vim.cmd("checktime")
    return
  end

  vim.notify("no formatter found for JS/TS", vim.log.levels.WARN)
end

function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype

  if filepath == "" then
    return
  end

  vim.cmd("silent write")

  if filetype == "python" then
    format_python(filepath)
    return
  end

  if js_like[filetype] then
    format_js(filepath)
    return
  end

  vim.lsp.buf.format({ bufnr = bufnr, async = false })
end

return M
