-- exコマンドの実行結果をバッファに表示
-- 例: :PipeBuffer :map
local function PipeBuffer(cmd)
    local result = vim.fn.execute(cmd)
    vim.cmd('tabe')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
    vim.bo.modifiable = true
    vim.bo.modified = true
end

-- ユーザーコマンドの作成
vim.api.nvim_create_user_command("PipeBuffer", function(opts)
    PipeBuffer(opts.args)
end, { nargs = 1, complete = "command" })
