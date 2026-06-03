local M = {}

function M.setup()
  local c = {
    bg0 = "#282828",
    bg1 = "#3c3836",
    bg2 = "#504945",
    fg0 = "#fbf1c7",
    fg1 = "#ebdbb2",
    gray = "#928374",

    red = "#fb4934",
    green = "#b8bb26",
    yellow = "#fabd2f",
    yellow_muted = "#d79921",
    blue = "#83a598",
    purple = "#d3869b",
    aqua = "#8ec07c",
    orange = "#fe8019",
  }

  local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hl("MdHtmlBold", { fg = c.orange, bold = true })
  hl("MdHtmlItalic", { fg = c.purple, italic = true })
  hl("MdHtmlBoldText", { bold = true })
  hl("MdHtmlItalicText", { italic = true })
  hl("MdHtmlUnderline", { fg = c.aqua, underline = true })
  hl("MdHtmlMark", { fg = c.bg0, bg = c.yellow, bold = true })
  hl("MdHtmlKbd", { fg = c.fg0, bg = c.bg2, bold = true })
  hl("MdHtmlCode", { fg = c.green, bg = c.bg1 })
  hl("MdHtmlFont", { fg = c.red })
  hl("MdHtmlFontTag", { fg = c.red })
  hl("MdHtmlFontRedText", { fg = c.red })
  hl("MdHtmlFontPurpleText", { fg = c.purple })
  hl("MdHtmlFontYellowText", { fg = c.yellow_muted })
  hl("MdHtmlFontRedValue", { fg = c.bg0, bg = c.red, bold = true })
  hl("MdHtmlFontPurpleValue", { fg = c.bg0, bg = c.purple, bold = true })
  hl("MdHtmlFontYellowValue", { fg = c.bg0, bg = c.yellow_muted, bold = true })

  for _, group in ipairs({
    "RenderMarkdownQuote",
    "RenderMarkdownQuote1",
    "RenderMarkdownQuote2",
    "RenderMarkdownQuote3",
    "RenderMarkdownQuote4",
    "RenderMarkdownQuote5",
    "RenderMarkdownQuote6",
  }) do
    hl(group, { fg = c.red, bg = "NONE" })
  end

  hl("RenderMarkdownInlineHighlight", {
    fg = c.bg0,
    bg = c.yellow,
    bold = true,
  })

  hl("RenderMarkdownTableHead", {
    fg = c.yellow,
    bg = c.bg1,
    bold = true,
  })

  hl("RenderMarkdownTableRow", {
    fg = c.fg1,
    bg = "NONE",
  })

  hl("RenderMarkdownCode", {
    bg = c.bg1,
  })

  hl("RenderMarkdownCodeBorder", {
    fg = c.bg2,
    bg = c.bg1,
  })

  hl("RenderMarkdownCodeInline", {
    fg = c.green,
    bg = c.bg1,
  })

  hl("MdCheckboxUnchecked", { fg = c.gray })
  hl("MdCheckboxChecked", { fg = c.green })
  hl("MdCheckboxCheckedText", { fg = c.gray, strikethrough = true })
  hl("MdCheckboxTodo", { fg = c.yellow })
  hl("MdCheckboxImportant", { fg = c.red, bold = true })
  hl("MdCheckboxQuestion", { fg = c.blue })

  hl("RenderMarkdownLink", { fg = c.blue })
  hl("RenderMarkdownWikiLink", { fg = c.aqua })
end

return M
