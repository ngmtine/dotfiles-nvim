local M = {}

function M.setup_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  lualine.setup({
    options = {
      theme = "iceberg",
      section_separators = "",
      component_separators = "|",
    },
  })
end

function M.setup_bufferline()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then
    return
  end

  local currentBufBg = "#2a3158"
  local currentBufStr = "#cdd1e6"
  local otherBufBg = "#1e2132"
  local otherBufStr = "#444b71"
  local modifiedIcon = "#e4aa80"

  -- 編集中のバッファのスタイル（アクティブかつフォーカスのバッファ）
  local editing_buffer_style = {
    fg = currentBufBg,
    bg = currentBufStr,
    bold = false,
    italic = false,
  }

  -- 編集中ではないバッファのスタイル（非フォーカスの全てのバッファ）
  local background_buffer_style = {
    fg = otherBufBg,
    bg = otherBufStr,
    bold = false,
    italic = false,
  }

  local editing_buffer_modified_icon = {
    fg = currentBufBg,
    bg = modifiedIcon,
  }

  local background_buffer_modified_icon = {
    fg = otherBufBg,
    bg = modifiedIcon,
  }

  bufferline.setup({
    options = {
      mode = "buffers",
      separator_style = "thin",
      diagnostics = "nvim_lsp",
      indicator = {
        style = "none",
      },
    },
    highlights = {
      fill = {
        fg = "NONE",
      },
      background = {
        fg = otherBufBg,
        bg = otherBufStr,
      },
      close_button = background_buffer_style,
      close_button_visible = background_buffer_style,
      close_button_selected = editing_buffer_style,
      buffer_visible = background_buffer_style,
      buffer_selected = editing_buffer_style,
      hint = background_buffer_style,
      hint_visible = background_buffer_style,
      hint_selected = editing_buffer_style,
      modified = background_buffer_modified_icon,
      modified_visible = background_buffer_modified_icon,
      modified_selected = editing_buffer_modified_icon,
    },
  })
end

return M
