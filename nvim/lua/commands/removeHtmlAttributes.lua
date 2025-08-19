-- htmlの任意の属性を削除する関数
-- TODO: 範囲選択に対応する
local function RemoveHtmlAttributes(args)
    local patterns = {}

    if args.args == "" then
        -- 引数がない場合はすべての属性を削除
        table.insert(patterns, '\\s\\+[a-zA-Z0-9_-]\\+\\s*=\\s*"[^"]*"')
    else
        -- 引数がある場合、複数の属性名を処理
        for attribute in string.gmatch(args.args, "%S+") do
            table.insert(patterns, '\\s\\+' .. attribute .. '\\s*=\\s*"[^"]*"')
        end
    end

    -- 各パターンで置換を実行
    for _, pattern in ipairs(patterns) do
        vim.cmd('%s/' .. pattern .. '//g')
    end
end

-- ユーザーコマンドの作成
vim.api.nvim_create_user_command('RmAttr', RemoveHtmlAttributes, { nargs = '*' })
