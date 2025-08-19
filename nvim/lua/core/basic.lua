local U = require("utils")

vim.opt.exrc = true -- ローカルの設定ファイル有効化

-- filetype --------------------------------------------------
vim.opt.fileencodings = "utf-8,sjis"

-- .fishを.shとして扱う
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.fish",
    callback = function()
        vim.opt.filetype = "sh"
    end,
})

-- style --------------------------------------------------
vim.opt.termguicolors = true -- truecolor有効化
vim.opt.number = true
vim.opt.showtabline = 2      -- タブ常に表示
vim.opt.cursorline = true
vim.opt.splitright = true    -- ウィンドウ水平分割時に、新規ウィンドウは右に作成
vim.opt.splitbelow = true    -- ウィンドウ垂直分割時に、新規ウィンドウは下に作成
vim.opt.signcolumn = "yes"   -- 行数表示列のガタツキ阻止（lspの診断情報が更新された時等）
vim.opt.updatetime = 100     -- lspの情報表示の更新頻度 デフォは4000ms

-- 特殊文字
vim.opt.list = true
vim.opt.listchars = { tab = "▸-", trail = "_", eol = "↲" }

-- edit --------------------------------------------------
vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.scriptencoding = "utf-8"
vim.opt.swapfile = false

-- clipboard ---------------------------------------------
vim.opt.clipboard = "unnamedplus"

if U.is_wsl then
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
    }
end

-- インデント
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- コメント行で行追加した場合、新規行はコメントアウト状態にしない
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function()
        vim.opt.formatoptions = "jql"
    end,
})

-- 存在しないディレクトリで保存しようとしたときにmkdir
vim.cmd([[
    augroup vimrc-auto-mkdir
    autocmd!
    function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
    endfunction
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    augroup END
]])

-- undo 永続化
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo/")

-- カーソル位置永続化
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd('silent! normal! g`"zv')
    end,
})

-- :s<Space> で :%s//　/g に展開
-- https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
vim.cmd([[
    cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])

-- ヤンクした箇所をハイライト
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end,
})
