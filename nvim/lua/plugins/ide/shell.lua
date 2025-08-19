local keymap_lsp = require("core.keymap")

-- シェルスクリプトのlsp設定
require("lspconfig").bashls.setup({
    on_attach = function(client, bufnr)
        local msg = string.format("[lspconfig_sh] LSP client '%s' attached to buffer %d", client.name, bufnr)
        vim.notify(msg, vim.log.levels.INFO, { title = "LSP Attach" })

        -- 共通のキーマップを設定
        keymap_lsp(bufnr)
    end,

    filetypes = { "sh", "bash" },
})

-- フォーマット関数
local function format_with_beautysh(bufnr)
    if vim.fn.executable("beautysh") == 0 then
        vim.notify("[lspconfig_sh] beautysh command not found. Please install it (:MasonInstall beautysh)", vim.log.levels.WARN, { title = "Formatting" })
        return
    end

    -- バッファローカルで beautysh を実行
    vim.api.nvim_buf_call(bufnr, function()
        -- カーソル位置を保存
        local cursor_pos = vim.api.nvim_win_get_cursor(0)

        -- 実行
        vim.cmd("silent %!beautysh -")

        -- beautysh の実行結果を確認 (vim.cmd の直後に vim.v.shell_error を確認)
        if vim.v.shell_error == 0 then
            -- 成功時
            vim.notify("[lspconfig_sh] Formatted buffer " .. bufnr .. " with beautysh", vim.log.levels.INFO, { title = "Formatting" })
        else
            -- 失敗時
            local msg = string.format("[lspconfig_sh] Failed to format with beautysh. Exit code: %d", vim.v.shell_error)
            vim.notify(msg, vim.log.levels.ERROR, { title = "Formatting" })
            vim.cmd("silent undo")
        end

        -- カーソル位置を復元
        pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
    end)
end

-- 保存時にbeautyshでフォーマット実行するオートコマンド
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("ShFtplugin", { clear = true }),
    buffer = 0, -- 現在のバッファにのみ適用
    desc = "Format shell script with beautysh on save (ftplugin)",
    callback = function(args)
            local current_bufnr = args.buf
        local filetype = vim.api.nvim_buf_get_option(current_bufnr, 'filetype')
        if filetype ~= "sh" then
            return
        end
        format_with_beautysh(args.buf)
    end,
})

-- TODO: そのうち以下ちゃんと調べる

-- Q. nvimで.sh開いた場合、数秒待たないとフォーマットできない問題
-- bashlsのlspのon_attachでは、lspの読み込みが完全に完了してからフォーマットが実行されるような雰囲気があります。（＝ファイル読み込み直後はフォーマット不可）
-- 一方、同様のフォーマット処理を実装しているlspconfig_lua.luaでは、ファイルを開いた直後からフォーマット処理を実行可能です。
-- この違いは何でしょうか？luaファイルに対して即時フォーマットができるならば、シェルスクリプトに対しても同様に即時フォーマットが出来てもおかしくないのですが。

-- A.（gemini 2.5pro）
-- 現在の状況は、おそらく以下のようになっているのではないでしょうか。
-- Lua: ファイルを開く → lua_ls が高速にアタッチ → :Format (または保存時トリガーの vim.lsp.buf.format()) がすぐに機能する。
-- Bash: ファイルを開く → bashls のアタッチを待つ → on_attach が実行され、カスタムの BufWritePre オートコマンド (format_with_beautysh を呼ぶもの) が定義される → その後の保存で beautysh によるフォーマットが実行される。
-- つまり、Lua と Bash で「フォーマットを実行する仕組み」が異なっている（Lua は LSP 標準のフォーマット、Bash はカスタム関数による外部コマンド実行）ため、特に Bash 側で LSP のアタッチタイミングの影響を受けているのだと考えられます。
-- というわけでシェルスクリプトに関してはlspの外側でautocmd設定してフォーマットする方針にした
