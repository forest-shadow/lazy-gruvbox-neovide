local M = {}

local namespace = "render_markdown_font_matches"
local priority = 20000

local matches = {
  {
    group = "MdHtmlBoldText",
    pattern = [[<b>\zs.\{-}\ze</b>]],
  },
  {
    group = "MdHtmlBoldText",
    pattern = [[<strong>\zs.\{-}\ze</strong>]],
  },
  {
    group = "MdHtmlItalicText",
    pattern = [[<i>\zs.\{-}\ze</i>]],
  },
  {
    group = "MdHtmlItalicText",
    pattern = [[<em>\zs.\{-}\ze</em>]],
  },
  {
    group = "MdHtmlFontRedText",
    pattern = [[<font color="#fb4934">\zs.\{-}\ze</font>]],
  },
  {
    group = "MdHtmlFontPurpleText",
    pattern = [[<font color="#d3869b">\zs.\{-}\ze</font>]],
  },
  {
    group = "MdHtmlFontYellowText",
    pattern = [[<font color="#d79921">\zs.\{-}\ze</font>]],
  },
  {
    group = "MdHtmlFontRedValue",
    pattern = [[<font color="\zs#fb4934\ze">]],
  },
  {
    group = "MdHtmlFontPurpleValue",
    pattern = [[<font color="\zs#d3869b\ze">]],
  },
  {
    group = "MdHtmlFontYellowValue",
    pattern = [[<font color="\zs#d79921\ze">]],
  },
}

local function clear_window_matches()
  local ids = vim.w[namespace]
  if not ids then
    return
  end

  for _, id in ipairs(ids) do
    pcall(vim.fn.matchdelete, id)
  end
  vim.w[namespace] = nil
end

local function apply_window_matches()
  if vim.bo.filetype ~= "markdown" then
    clear_window_matches()
    return
  end

  clear_window_matches()

  local ids = {}
  for _, match in ipairs(matches) do
    table.insert(ids, vim.fn.matchadd(match.group, match.pattern, priority))
  end
  vim.w[namespace] = ids
end

local function window_matches_are_valid()
  local ids = vim.w[namespace]
  if type(ids) ~= "table" or #ids ~= #matches then
    return false
  end

  local active = {}
  for _, match in ipairs(vim.fn.getmatches()) do
    active[match.id] = true
  end

  for _, id in ipairs(ids) do
    if not active[id] then
      return false
    end
  end

  return true
end

local function ensure_window_matches()
  if vim.bo.filetype ~= "markdown" then
    clear_window_matches()
    return
  end

  if not window_matches_are_valid() then
    apply_window_matches()
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("render_markdown_font_matches", { clear = true })

  vim.api.nvim_create_autocmd({
    "FileType",
    "BufWinEnter",
    "WinEnter",
    "ColorScheme",
  }, {
    group = group,
    pattern = { "markdown", "*" },
    callback = apply_window_matches,
  })

  vim.api.nvim_create_autocmd({
    "CursorMoved",
    "CursorMovedI",
    "ModeChanged",
    "WinScrolled",
  }, {
    group = group,
    callback = ensure_window_matches,
  })

  vim.api.nvim_create_autocmd("BufWinLeave", {
    group = group,
    callback = clear_window_matches,
  })
end

return M
