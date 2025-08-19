local bufferline = require('bufferline')

local currentBufBg = "#2a3158"
local currentBufStr = "#cdd1e6"
local otherBufBg = "#1e2132"
local otherBufStr = "#444b71"
local modifiedIcon = "#e4aa80"

-- デバッグ用
-- local blue = "#0000ff"
-- local red = "#ff0000"

-- 以下で言うアクティブとは、現在表示中の（vim機能の）タブページのどこかに存在している、という意味
-- 同様に、フォーカスとは、現在編集中である（vim機能の）ウィンドウ、という意味
-- タブページ ⊃ ウィンドウ ≒ バッファ
-- （個人的に）タブページ機能は使用していないので、タブページ移動にキーマッピングしてない 移動するならデフォの :tabn :tabp にて行う

-- 編集中のバッファのスタイル（アクティブかつフォーカスのバッファ）
local editing_buffer_style = {
    fg = currentBufBg,  -- 背景色
    bg = currentBufStr, -- 文字色
    bold = false,
    italic = false,
}

-- 編集中ではないバッファのスタイル（非フォーカスの全てのバッファ）
local background_buffer_style = {
    fg = otherBufBg,  -- 背景色
    bg = otherBufStr, -- 文字色
    bold = false,
    italic = false,
}

local editing_buffer_modified_icon = {
    fg = currentBufBg, -- 背景色
    bg = modifiedIcon, -- オレンジの●
}

local background_buffer_modified_icon = {
    fg = otherBufBg,   -- 背景色
    bg = modifiedIcon, -- オレンジの●
}

bufferline.setup({
    options = {
        mode = "buffers",
        separator_style = "thin", -- タブスタイル
        diagnostics = "nvim_lsp", -- lspの診断情報があるバッファについて、スタイル変更の有効化

        indicator = {
            style = "none", -- 選択中のバッファを示すインジケータを非表示
        },
    },

    -- スタイル詳細は :h bufferline-highlights
    highlights = {
        fill = {
            fg = "none" -- bufferlineのタブ部以外の空白領域に背景色を付与しない（実際はweztermで黒）
        },

        -- 画面上に表示されていないバッファ（非フォーカスかつ非アクティブ）
        background = {
            fg = otherBufBg,  -- 背景色
            bg = otherBufStr, -- 文字色
        },

        -- （vim機能の）タブページの可視化（bufferlineの機能で、画面右上に数字で表示されるもの）
        -- tab = {},
        -- tab_selected = {},
        -- tab_separator = {},
        -- tab_separator_selected = {},
        -- tab_close = {},

        -- 閉じるボタン
        close_button = background_buffer_style,
        close_button_visible = background_buffer_style,
        close_button_selected = editing_buffer_style,

        -- 表示中のバッファ（アクティブではあるが非フォーカス）
        buffer_visible = background_buffer_style,
        -- 編集中のバッファ（アクティブかつフォーカス）
        buffer_selected = editing_buffer_style,

        -- バッファ番号表示 (オプションで有効時)
        -- numbers = {},
        -- numbers_visible = {},
        -- numbers_selected = {},

        -- diagnostic = {},
        -- diagnostic_visible = {},
        -- diagnostic_selected = {},

        -- lspの診断情報があるバッファのスタイル（diagnostics = "nvim_lsp" 時に関係する項目）
        hint = background_buffer_style,
        hint_visible = background_buffer_style,
        hint_selected = editing_buffer_style,

        -- hint_diagnostic = {},
        -- hint_diagnostic_visible = {},
        -- hint_diagnostic_selected = {},

        -- info = {},
        -- info_visible = {},
        -- info_selected = {},
        -- info_diagnostic = {},
        -- info_diagnostic_visible = {},
        -- info_diagnostic_selected = {},

        -- warning = {},
        -- warning_visible = {},
        -- warning_selected = {},
        -- warning_diagnostic = {},
        -- warning_diagnostic_visible = {},
        -- warning_diagnostic_selected = {},

        -- error = {},
        -- error_visible = {},
        -- error_selected = {},
        -- error_diagnostic = {},
        -- error_diagnostic_visible = {},
        -- error_diagnostic_selected = {},

        -- 未保存の編集ありを示すオレンジアイコン
        modified = background_buffer_modified_icon,
        modified_visible = background_buffer_modified_icon,
        modified_selected = editing_buffer_modified_icon,

        -- duplicate_selected = {},
        -- duplicate_visible = {},
        -- duplicate = {},

        -- separator_selected = {},
        -- separator_visible = {},
        -- separator = {},

        -- indicator_visible = background_buffer_style,
        -- indicator_selected = editing_buffer_style,

        -- pick_selected = {},
        -- pick_visible = {},
        -- pick = {},

        -- offset_separator = {},
        -- trunc_marker = {}
    }
})
