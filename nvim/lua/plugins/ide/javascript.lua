local U = require("utils")
local keymap_lsp = require("core.keymap")
local lspconfig = require("lspconfig")

-- efmのsettingsテーブルを動的に構築する関数
local function build_efm_settings()
    local settings = {
        version = 2,
        rootMarkers = { ".git", "package.json" },
        lintDebounce = "500ms",
        languages = {},
    }

    local tools = {}

    -- 1. VSCode設定を最優先で確認
    local vscode_formatter = U.get_vscode_formatter()
    if vscode_formatter == "biome" then
        U.find_formatter_config({ "biome.json" }) -- biome.jsonの存在を明示的にチェック
        tools.formatter = "biome"
        tools.linter = "biome"
    elseif vscode_formatter == "prettier" then
        tools.formatter = "prettier"
    elseif vscode_formatter == "eslint" then
        tools.linter = "eslint"
    end

    -- 2. VSCode設定がない場合、ツール設定ファイルを確認
    if vim.tbl_isempty(tools) then
        local biome_config = U.find_formatter_config({ "biome.json" })
        local prettier_config = U.find_formatter_config({
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.cjs",
            "prettier.config.js",
            "prettier.config.cjs",
        })
        local eslint_config = U.find_formatter_config({
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.json",
        })

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

-- 共通on_attach関数
local on_attach = function(client, bufnr)
    local msg = string.format("[lspconfig_js] LSP client '%s' attached to buffer %d", client.name or "unknown",
        bufnr or "empty buffer")
    vim.notify(msg)
end

-- js, tsのlsp設定
lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- 共通on_attach
        on_attach(client, bufnr)

        -- キーマップ
        keymap_lsp(bufnr)

        -- ts_lsのフォーマット機能を無効化（efmとの競合回避）
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- 保存時フォーマット
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("EfmFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                U.notify_formatting_info(bufnr)
                vim.lsp.buf.format({
                    filter = function(c) return c.name == "efm" end, -- フォーマットはefmに一任
                    async = false                                    -- 非同期にするとなんかバグるので無効化
                })
            end,
        })
    end
})

-- efmのlsp設定（js, ts以外のファイルで実行させないために、この場所で指定）
lspconfig.efm.setup({
    -- on_attach(client, bufnr),                -- 共通on_attach
    settings = build_efm_settings(), -- プロジェクトがbiome, prettier, eslintのどれを採用しているかによって動的に設定
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = false,
        documentHighlight = false,
        hover = false,
        completion = false,
    },
})
