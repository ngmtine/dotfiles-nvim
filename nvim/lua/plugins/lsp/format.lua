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

local function find_local_bin(startpath, bin_name)
  local path = find_upward({ "node_modules/.bin/" .. bin_name }, startpath)
  if path and vim.fn.executable(path) == 1 then
    return path
  end
  return ""
end

local function find_executable(startpath, bin_name)
  local local_bin = find_local_bin(startpath, bin_name)
  if local_bin ~= "" then
    return local_bin
  end
  return vim.fn.exepath(bin_name)
end

local function run_cmd(cmd)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(result, vim.log.levels.ERROR)
    return false
  end
  return true
end

local function run_cmd_capture(cmd, input_text)
  local result = vim.fn.system(cmd, input_text)
  if vim.v.shell_error ~= 0 then
    vim.notify(result, vim.log.levels.ERROR)
    return nil
  end
  return result
end

local function get_buffer_text(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return table.concat(lines, "\n")
end

local function set_buffer_text(bufnr, text)
  if text == nil then
    return
  end
  local normalized = text:gsub("\r\n", "\n")
  local lines = vim.split(normalized, "\n", { plain = true })
  if #lines > 0 and lines[#lines] == "" then
    table.remove(lines, #lines)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local function sync_buffer_from_file(bufnr, filepath)
  if vim.fn.filereadable(filepath) == 0 then
    return
  end
  local file_lines = vim.fn.readfile(filepath)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, file_lines)
end

local function format_python_file(filepath)
  local ruff = vim.fn.exepath("ruff")
  if ruff == "" then
    local mason_ruff = vim.fn.stdpath("data") .. "/mason/bin/ruff"
    if vim.fn.executable(mason_ruff) == 1 then
      ruff = mason_ruff
    end
  end

  if ruff == "" then
    vim.notify("ruff not found", vim.log.levels.WARN)
    return false
  end

  run_cmd({ ruff, "format", filepath })
  return true
end

local function format_python_stdin(bufnr, filepath)
  local ruff = vim.fn.exepath("ruff")
  if ruff == "" then
    local mason_ruff = vim.fn.stdpath("data") .. "/mason/bin/ruff"
    if vim.fn.executable(mason_ruff) == 1 then
      ruff = mason_ruff
    end
  end
  if ruff == "" then
    vim.notify("ruff not found", vim.log.levels.WARN)
    return false
  end

  local input = get_buffer_text(bufnr)
  local output = run_cmd_capture({ ruff, "format", "--stdin-filename", filepath, "-" }, input)
  if output == nil then
    return false
  end
  set_buffer_text(bufnr, output)
  return true
end

local function format_js_file(filepath)
  local root = vim.fs.root(filepath, { "biome.json", "biome.jsonc", "package.json", ".git" })
  local base = root or vim.fn.fnamemodify(filepath, ":p:h")

  local biome_cfg = find_upward({ "biome.json", "biome.jsonc" }, base)
  local prettier_cfg = find_upward({ ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js", "prettier.config.cjs" }, base)
  local eslint_cfg = find_upward({ ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs", "eslint.config.js", "eslint.config.cjs", "eslint.config.mjs" }, base)

  local biome = find_executable(base, "biome")
  if biome == "" then
    local mason_biome = vim.fn.stdpath("data") .. "/mason/bin/biome"
    if vim.fn.executable(mason_biome) == 1 then
      biome = mason_biome
    end
  end

  if biome_cfg then
    if biome ~= "" then
      run_cmd({ biome, "format", "--write", filepath })
      return true
    end
    vim.notify("biome not found", vim.log.levels.WARN)
    return false
  end

  if prettier_cfg then
    local prettier = find_executable(base, "prettier")
    if prettier ~= "" then
      run_cmd({ prettier, "--write", filepath })
      return true
    end
  end

  if eslint_cfg then
    local eslint = find_executable(base, "eslint")
    if eslint ~= "" then
      run_cmd({ eslint, "--fix", filepath })
      return true
    end
  end

  if biome ~= "" then
    local fallback = vim.fn.stdpath("config") .. "/biome/biome.json"
    run_cmd({ biome, "format", "--config-path", fallback, "--write", filepath })
    return true
  end

  vim.notify("no formatter found for JS/TS", vim.log.levels.WARN)
  return false
end

local function eslint_fix_with_temp(bufnr, filepath, eslint)
  local dir = vim.fn.fnamemodify(filepath, ":p:h")
  local ext = vim.fn.fnamemodify(filepath, ":e")
  local suffix = ext ~= "" and ("." .. ext) or ""
  local tmp = string.format("%s/.nvim-refactor-eslint-%d%s", dir, vim.uv.hrtime(), suffix)
  local ok = pcall(vim.fn.writefile, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), tmp)
  if not ok then
    return false
  end

  local fixed = run_cmd({ eslint, "--fix", tmp })
  if fixed then
    local lines = vim.fn.readfile(tmp)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
  pcall(vim.fn.delete, tmp)
  return fixed
end

local function format_js_stdin(bufnr, filepath)
  local root = vim.fs.root(filepath, { "biome.json", "biome.jsonc", "package.json", ".git" })
  local base = root or vim.fn.fnamemodify(filepath, ":p:h")

  local biome_cfg = find_upward({ "biome.json", "biome.jsonc" }, base)
  local prettier_cfg = find_upward({ ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", "prettier.config.js", "prettier.config.cjs" }, base)
  local eslint_cfg = find_upward({ ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.cjs", "eslint.config.js", "eslint.config.cjs", "eslint.config.mjs" }, base)

  local biome = find_executable(base, "biome")
  if biome == "" then
    local mason_biome = vim.fn.stdpath("data") .. "/mason/bin/biome"
    if vim.fn.executable(mason_biome) == 1 then
      biome = mason_biome
    end
  end

  local input = get_buffer_text(bufnr)

  if biome_cfg and biome ~= "" then
    local output = run_cmd_capture({ biome, "format", "--stdin-file-path", filepath }, input)
    if output ~= nil then
      set_buffer_text(bufnr, output)
      return true
    end
    return false
  end

  if prettier_cfg then
    local prettier = find_executable(base, "prettier")
    if prettier ~= "" then
      local output = run_cmd_capture({ prettier, "--stdin-filepath", filepath }, input)
      if output ~= nil then
        set_buffer_text(bufnr, output)
        return true
      end
      return false
    end
  end

  if eslint_cfg then
    local eslint = find_executable(base, "eslint")
    if eslint ~= "" then
      return eslint_fix_with_temp(bufnr, filepath, eslint)
    end
  end

  if biome ~= "" then
    local fallback = vim.fn.stdpath("config") .. "/biome/biome.json"
    local output = run_cmd_capture({ biome, "format", "--config-path", fallback, "--stdin-file-path", filepath }, input)
    if output ~= nil then
      set_buffer_text(bufnr, output)
      return true
    end
    return false
  end

  vim.notify("no formatter found for JS/TS", vim.log.levels.WARN)
  return false
end

function M.format(bufnr, opts)
  opts = opts or {}
  local write_before = opts.write_before ~= false
  local sync_buffer = opts.sync_buffer ~= false
  local use_stdin = opts.use_stdin == true

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype

  if filepath == "" then
    return
  end

  if write_before then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("silent noautocmd write")
    end)
  end

  if filetype == "python" then
    local ok = use_stdin and format_python_stdin(bufnr, filepath) or format_python_file(filepath)
    if ok and sync_buffer and not use_stdin then
      sync_buffer_from_file(bufnr, filepath)
    end
    return
  end

  if js_like[filetype] then
    local ok = use_stdin and format_js_stdin(bufnr, filepath) or format_js_file(filepath)
    if ok and sync_buffer and not use_stdin then
      sync_buffer_from_file(bufnr, filepath)
    end
    return
  end

  vim.lsp.buf.format({ bufnr = bufnr, async = false })
end

return M
