-- コードブロック可視化プラグイン
require("hlchunk").setup({
    chunk = {
        enable = true,
        use_treesitter = true,
        chars = {
            horizontal_line = "═",
            vertical_line = "║",
            left_top = "╔",
            left_bottom = "╚",
            right_arrow = "▶",
        },
        duration = 100,
        delay = 100,
        textobject = "ac", -- テキストオブジェクト定義 dac, yac等でチャンク全体を操作できる
    },
    indent = {
        enable = false,
        use_treesitter = false, -- trueにするとエラーになる（という問題もあり、そもそもこの機能がそんなに有用だと思ってないのでenable=false）
    },
    line_num = {
        enable = true,
        use_treesitter = true,
    },
})
