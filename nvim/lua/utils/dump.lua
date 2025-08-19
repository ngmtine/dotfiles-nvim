-- 内部で使用する再帰的なダンプ関数
-- @param value any ダンプする値
-- @param indent number 現在のインデントレベル
-- @param visited table 循環参照検出用
-- @return string フォーマットされた文字列
local function dump_recursive(value, indent, visited)
    local value_type = type(value)
    local indent_str = string.rep("  ", indent)          -- 現在のインデント
    local next_indent_str = string.rep("  ", indent + 1) -- 次のインデント

    if value_type == "string" then
        -- 文字列: クォートで囲み、エスケープ
        return '"' .. value:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t") .. '"'
    elseif value_type == "number" or value_type == "boolean" or value_type == "nil" then
        -- 数値, boolean, nil: そのまま文字列化
        return tostring(value)
    elseif value_type == "table" then
        -- テーブル: 循環参照をチェック
        if visited[value] then
            return '"*RECURSION*"' -- 循環検出
        end
        visited[value] = true      -- 訪問済みマーク

        local parts = {}           -- テーブルの各要素の文字列を格納
        local is_first = true

        -- テーブルの内容を処理
        for key, val in pairs(value) do
            local key_str
            -- キーのフォーマット
            if type(key) == "string" and key:match("^[a-zA-Z_][a-zA-Z0-9_]*$") then
                key_str = key                                                     -- Luaの識別子として有効な文字列キー
            elseif type(key) == "string" then
                key_str = '["' .. key:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"]' -- その他の文字列キー
            else
                key_str = '[' .. tostring(key) .. ']'                             -- 数値キーなど
            end

            -- 値を再帰的にフォーマット
            local val_str = dump_recursive(val, indent + 1, visited)

            -- 要素文字列を作成 (カンマは後で結合)
            table.insert(parts, next_indent_str .. key_str .. " = " .. val_str)
        end

        visited[value] = nil -- 訪問済みマーク解除

        -- 結果を組み立てる
        if #parts == 0 then
            return "{}" -- 空テーブル
        else
            -- 各要素をカンマと改行で結合し、{}で囲む
            return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent_str .. "}"
        end
    elseif value_type == "function" then
        return tostring(value) -- 例: "function: 0x..."
    else                       -- userdata, thread など
        return '"' .. value_type .. ': ' .. tostring(value) .. '"'
    end
end

--- テーブルや任意の値を人間が読める形式で表示するためのラッパー関数
-- @param value any ダンプしたい値
-- @return string フォーマットされた文字列
local function dump(value)
    -- 内部関数を初期インデント0、空のvisitedテーブルで呼び出す
    return dump_recursive(value, 0, {})
end

return dump
