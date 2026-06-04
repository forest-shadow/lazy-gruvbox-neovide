local M = {}

local namespace = vim.api.nvim_create_namespace("render_markdown_font_matches")
local legacy_window_key = "render_markdown_font_matches"
local priority = 20000

local inline_tags = {
  { open = "<b>", close = "</b>", group = "MdHtmlBoldText" },
  { open = "<strong>", close = "</strong>", group = "MdHtmlBoldText" },
  { open = "<i>", close = "</i>", group = "MdHtmlItalicText" },
  { open = "<em>", close = "</em>", group = "MdHtmlItalicText" },
}

local font_colors = {
  ["#fb4934"] = {
    text = "MdHtmlFontRedText",
    value = "MdHtmlFontRedValue",
  },
  ["#d3869b"] = {
    text = "MdHtmlFontPurpleText",
    value = "MdHtmlFontPurpleValue",
  },
  ["#d79921"] = {
    text = "MdHtmlFontYellowText",
    value = "MdHtmlFontYellowValue",
  },
}

local function clear_buffer_highlights(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
  end
end

local function clear_legacy_window_matches()
  local ids = vim.w[legacy_window_key]
  if type(ids) ~= "table" then
    return
  end

  for _, id in ipairs(ids) do
    pcall(vim.fn.matchdelete, id)
  end
  vim.w[legacy_window_key] = nil
end

local function add_highlight(buf, group, lnum, start_col, end_col)
  if start_col <= 0 or end_col < start_col then
    return
  end

  vim.api.nvim_buf_set_extmark(buf, namespace, lnum - 1, start_col - 1, {
    end_col = end_col,
    hl_group = group,
    priority = priority,
  })
end

local function highlight_plain_tags(buf, line, lnum)
  for _, tag in ipairs(inline_tags) do
    local from = 1

    while true do
      local _, open_end = line:find(tag.open, from, true)
      if not open_end then
        break
      end

      local text_start = open_end + 1
      local close_start, close_end = line:find(tag.close, text_start, true)
      if not close_start then
        break
      end

      add_highlight(buf, tag.group, lnum, text_start, close_start - 1)
      from = close_end + 1
    end
  end
end

local function highlight_font_tags(buf, line, lnum)
  local from = 1

  while true do
    local open_start, open_end, color = line:find('<font color="(#[%x]+)">', from)
    if not open_end then
      break
    end

    local groups = font_colors[color:lower()]
    if groups then
      local color_start = open_start + #'<font color="'
      local color_end = color_start + #color - 1
      local text_start = open_end + 1
      local close_start, close_end = line:find("</font>", text_start, true)

      add_highlight(buf, groups.value, lnum, color_start, color_end)

      if close_start then
        add_highlight(buf, groups.text, lnum, text_start, close_start - 1)
        from = close_end + 1
      else
        break
      end
    else
      from = open_end + 1
    end
  end
end

local function apply_buffer_highlights(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  clear_legacy_window_matches()
  clear_buffer_highlights(buf)

  if vim.bo[buf].filetype ~= "markdown" then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for lnum, line in ipairs(lines) do
    highlight_plain_tags(buf, line, lnum)
    highlight_font_tags(buf, line, lnum)
  end
end

local function schedule_apply(buf)
  vim.schedule(function()
    apply_buffer_highlights(buf)
  end)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("render_markdown_font_matches", { clear = true })

  vim.api.nvim_create_autocmd({
    "FileType",
    "BufEnter",
    "BufWinEnter",
    "WinEnter",
    "ColorScheme",
    "TextChanged",
    "TextChangedI",
  }, {
    group = group,
    pattern = { "markdown", "*" },
    callback = function(args)
      schedule_apply(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
      clear_buffer_highlights(args.buf)
    end,
  })
end

return M
