local find_formatter_config = require("utils.find_formatter_config")

-- .vscode/settings.json を解析してフォーマッタ設定を返す
-- @param bufnr (number, optional) 対象のバッファ番号
-- @param root_dir (string, optional) プロジェクトルートディレクトリ
-- @return string|nil フォーマッタ名 (例: "biome", "prettier") or nil
local function get_vscode_formatter(bufnr, root_dir)
    local vscode_settings_path = find_formatter_config({ ".vscode/settings.json" }, bufnr, root_dir)
    if not vscode_settings_path then
        return nil
    end

    -- ファイル内容を読み込む
    local file = io.open(vscode_settings_path, "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()

    -- Neovimの機能でJSONをパース
    local ok, settings = pcall(vim.fn.json_decode, content)
    if not ok or type(settings) ~= "table" then
        vim.notify("[vscode_settings] Failed to parse .vscode/settings.json", vim.log.levels.WARN)
        return nil
    end

    -- フォーマッタ設定を特定
    -- TODO: "[javascript]" のような言語固有設定も考慮するとより堅牢になる
    local formatter = settings["editor.defaultFormatter"]
    if not formatter or type(formatter) ~= "string" then
        return nil
    end

    -- "esbenp.prettier-vscode" -> "prettier" のように単純化して返す
    if formatter:match("biome") then
        return "biome"
    elseif formatter:match("prettier") then
        return "prettier"
    elseif formatter:match("eslint") then
        return "eslint"
    end

    return nil
end

return get_vscode_formatter
