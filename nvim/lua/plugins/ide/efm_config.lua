local U = require("utils")

-- efmのsettingsテーブルを動的に構築する関数
-- @param bufnr (number, optional) 対象のバッファ番号
-- @param root_dir (string, optional) プロジェクトルートディレクトリ
local function build_efm_settings(bufnr, root_dir)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local settings = {
        version = 2,
        rootMarkers = { ".git", "package.json" },
        lintDebounce = "500ms",
        languages = {},
    }

    local tools = {}

    -- 1. VSCode設定を最優先で確認
    local vscode_formatter = U.get_vscode_formatter(bufnr, root_dir)
    if vscode_formatter == "biome" then
        U.find_formatter_config({ "biome.json" }, bufnr, root_dir) -- biome.jsonの存在を明示的にチェック
        tools.formatter = "biome"
        tools.linter = "biome"
    elseif vscode_formatter == "prettier" then
        tools.formatter = "prettier"
    elseif vscode_formatter == "eslint" then
        tools.linter = "eslint"
    end

    -- 2. VSCode設定がない場合、ツール設定ファイルを確認
    if vim.tbl_isempty(tools) then
        local biome_config = U.find_formatter_config({ "biome.json" }, bufnr, root_dir)
        local prettier_config = U.find_formatter_config({
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.cjs",
            "prettier.config.js",
            "prettier.config.cjs",
        }, bufnr, root_dir)
        local eslint_config = U.find_formatter_config({
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.json",
        }, bufnr, root_dir)

        if biome_config then
            -- BiomeがあればPrettierは無視
            tools.formatter = "biome"
            tools.linter = "biome"
        else
            if prettier_config then
                tools.formatter = "prettier"
            end
            if eslint_config then
                tools.linter = "eslint"
            end
        end
    end

    -- 3. どの設定も見つからない場合はPrettierをデフォルトにする
    if vim.tbl_isempty(tools) then
        tools.formatter = "prettier"
    end

    -- 4. 決定したツールに基づいてefmの設定を構築
    local lang_settings = {}
    if tools.formatter == "biome" then
        table.insert(lang_settings, {
            formatCommand = "biome format --stdin-file-path ${INPUT}",
            formatStdin = true,
        })
    elseif tools.formatter == "prettier" then
        table.insert(lang_settings, {
            formatCommand = "prettier --stdin-filepath ${INPUT}",
            formatStdin = true,
        })
    end

    if tools.linter == "biome" then
        table.insert(lang_settings, {
            lintCommand = "biome lint --stdin-file-path ${INPUT}",
            lintStdin = true,
            lintFormats = { "%f:%l:%c %t: %m" },
        })
    elseif tools.linter == "eslint" then
        table.insert(lang_settings, {
            lintCommand = "eslint --format=compact --stdin --stdin-filename ${INPUT}",
            lintStdin = true,
            lintFormats = { "%f:%l:%c: %m [%t/%e]", "%f:%l:%c: %m" },
        })
    end

    -- 各言語に構築したツールのリストを割り当て
    local target_languages = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" }
    for _, lang in ipairs(target_languages) do
        settings.languages[lang] = lang_settings
    end

    return settings
end

-- 関数として export（バッファごとに呼び出せるようにする）
return {
    build_settings = build_efm_settings,
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = false,
        documentHighlight = false,
        hover = false,
        completion = false,
    },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "json" },
}
