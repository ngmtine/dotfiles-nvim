local safe_require = require("utils/safe_require")

--- 渡されたディレクトリ直下のluaを全てsafe_requireする関数（現状は再帰なし 再帰の方が便利かも）
--- 各モジュールがテーブルを返した場合、その内容をマージしたテーブルを返す
--- @param dir string lua/ からの相対パス
--- @return table merged_table マージされた結果テーブル
local function safe_require_all(dir)
    local merged_table = {} -- 返却テーブル初期化
    local config_path = vim.fn.stdpath("config")
    local base_dir_path = config_path .. "/lua/" .. dir
    local module_prefix = dir:gsub("/", ".") .. "."

    -- ファイル/ディレクトリ名のテーブルを取得
    local entries = vim.fn.readdir(base_dir_path)

    -- ディレクトリが読み込めない、または見つからない場合、空テーブルを返して終了
    if type(entries) ~= "table" then
        local msg = string.format("[safe_require_all] Could not read directory or directory not found: '%s'", base_dir_path)
        return merged_table
    end

    -- 各エントリを処理
    for _, filename in ipairs(entries) do
        -- 念の為
        if filename == "." or filename == ".." then
            goto continue
        end

        -- 拡張子.lua以外はスキップ
        if not filename:match("%.lua$") then
            goto continue
        end

        -- 読み込み不可はスキップ
        local full_filepath = base_dir_path .. "/" .. filename
        if not vim.fn.filereadable(full_filepath) then
            goto continue
        end

        -- 以降、読み込み対象のファイル
        local module_name_suffix = filename:gsub("%.lua$", "")
        local full_module_name = module_prefix .. module_name_suffix

        -- init.lua自身はスキップ（無限ループ防止）
        if module_name_suffix == "init" then
            goto continue
        end

        -- 読み込み
        local ok, result = safe_require(full_module_name)

        -- 失敗時はスキップ
        if not ok then
            goto continue
        end

        -- 以降、読み込み成功時
        if type(result) == "table" then
            -- 読み込んだものがテーブルの場合
            for key, value in pairs(result) do
                if merged_table[key] ~= nil and merged_table[key] ~= value then
                    local msg = string.format("[safe_require_all] Warning: Key '%s' from table in '%s' overwriting.", key, full_module_name)
                    vim.notify(msg, vim.log.levels.WARN)
                end
                merged_table[key] = value
            end
        elseif result ~= nil then
            -- テーブル以外でnilでない場合 (function, boolean, string, number)
            local key = module_name_suffix
            if merged_table[key] ~= nil then
                local msg = string.format("[safe_require_all] Warning: Key '%s' (from %s in '%s') overwriting existing value.", key, type(result), full_module_name)
                vim.notify(msg, vim.log.levels.WARN)
            end
            merged_table[key] = result
        end

        ::continue:: -- NOTE: luaにcontinue文は無いのでgotoとラベルで代用
    end

    return merged_table
end

return safe_require_all
