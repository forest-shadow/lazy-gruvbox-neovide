-- ~/.config/nvim/lua/plugins/render-markdown.lua

local font_color_ns = vim.api.nvim_create_namespace("markdown_font_color")

local function set_markdown_highlights()
  local c = {
    bg0 = "#282828",
    bg1 = "#3c3836",
    bg2 = "#504945",
    fg0 = "#fbf1c7",
    fg1 = "#ebdbb2",
    gray = "#928374",

    red = "#fb4934",
    red_dark = "#cc241d",
    green = "#b8bb26",
    yellow = "#fabd2f",
    blue = "#83a598",
    purple = "#d3869b",
    aqua = "#8ec07c",
    orange = "#fe8019",
  }

  local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- HTML-style tags: <b>, <i>, <u>, <mark>, <kbd>, <code>
  hl("MdHtmlBold", { fg = c.orange, bold = true })
  hl("MdHtmlItalic", { fg = c.purple, italic = true })
  hl("MdHtmlUnderline", { fg = c.aqua, underline = true })
  hl("MdHtmlMark", { fg = c.bg0, bg = c.yellow, bold = true })
  hl("MdHtmlKbd", { fg = c.fg0, bg = c.bg2, bold = true })
  hl("MdHtmlCode", { fg = c.green, bg = c.bg1 })
  hl("MdHtmlFont", { fg = c.red })

  -- Quote indicator.
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

  -- Obsidian-like ==highlight==.
  hl("RenderMarkdownInlineHighlight", {
    fg = c.bg0,
    bg = c.yellow,
    bold = true,
  })

  -- Tables.
  hl("RenderMarkdownTableHead", {
    fg = c.yellow,
    bg = c.bg1,
    bold = true,
  })

  hl("RenderMarkdownTableRow", {
    fg = c.fg1,
    bg = "NONE",
  })

  -- Code blocks and inline code.
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

  -- Checkboxes.
  hl("MdCheckboxUnchecked", { fg = c.gray })
  hl("MdCheckboxChecked", { fg = c.green })
  hl("MdCheckboxCheckedText", { fg = c.gray, strikethrough = true })
  hl("MdCheckboxTodo", { fg = c.yellow })
  hl("MdCheckboxImportant", { fg = c.red, bold = true })
  hl("MdCheckboxQuestion", { fg = c.blue })

  -- Links / wikilinks.
  hl("RenderMarkdownLink", { fg = c.blue })
  hl("RenderMarkdownWikiLink", { fg = c.aqua })
end

local function font_color_value_highlight(color)
  local hex = color:lower()
  local group = "MdHtmlFontColorValue" .. hex:sub(2)
  local red = tonumber(hex:sub(2, 3), 16)
  local green = tonumber(hex:sub(4, 5), 16)
  local blue = tonumber(hex:sub(6, 7), 16)
  local luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
  local fg = luminance > 140 and "#282828" or "#fbf1c7"

  vim.api.nvim_set_hl(0, group, { fg = fg, bg = hex })

  return group
end

local function font_color_text_highlight(color)
  local hex = color:lower()
  local group = "MdHtmlFontColorText" .. hex:sub(2)

  vim.api.nvim_set_hl(0, group, { fg = hex })

  return group
end

local function offset_to_position(line_offsets, offset)
  local low = 1
  local high = #line_offsets

  while low <= high do
    local mid = math.floor((low + high) / 2)
    if line_offsets[mid] <= offset then
      low = mid + 1
    else
      high = mid - 1
    end
  end

  local line = math.max(high, 1)
  return line - 1, offset - line_offsets[line]
end

local function render_font_colors(ctx)
  local buf = ctx.buf
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.api.nvim_buf_clear_namespace(buf, font_color_ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines == 0 then
    return
  end

  local line_offsets = {}
  local offset = 0
  for index, line in ipairs(lines) do
    line_offsets[index] = offset
    offset = offset + #line + 1
  end

  local text = table.concat(lines, "\n")
  local stack = {}
  local search_from = 1

  while true do
    local tag_start, tag_end = text:find("</?[Ff][Oo][Nn][Tt][^>]*>", search_from)
    if not tag_start then
      break
    end

    local tag = text:sub(tag_start, tag_end)
    if tag:find("^</") then
      local current = table.remove(stack)
      if current then
        local start_row, start_col = offset_to_position(line_offsets, current.content_start)
        local end_row, end_col = offset_to_position(line_offsets, tag_start - 1)

        if start_row < end_row or start_col < end_col then
          vim.api.nvim_buf_set_extmark(buf, font_color_ns, start_row, start_col, {
            end_row = end_row,
            end_col = end_col,
            hl_group = current.text_highlight,
            priority = 10000,
          })
        end
      end
    else
      local attr_start = tag:find([[color%s*=%s*["']?#%x%x%x%x%x%x["']?]])
      if attr_start then
        local color_start, color_end = tag:find("#%x%x%x%x%x%x", attr_start)
        local color = tag:sub(color_start, color_end)
        local start_row, start_col = offset_to_position(line_offsets, tag_start + color_start - 2)
        local end_row, end_col = offset_to_position(line_offsets, tag_start + color_end - 1)

        vim.api.nvim_buf_set_extmark(buf, font_color_ns, start_row, start_col, {
          end_row = end_row,
          end_col = end_col,
          hl_group = font_color_value_highlight(color),
          priority = 10000,
        })

        table.insert(stack, {
          content_start = tag_end,
          text_highlight = font_color_text_highlight(color),
        })
      end
    end

    search_from = tag_end + 1
  end
end

local function setup_font_color_autocmds()
  local group = vim.api.nvim_create_augroup("markdown_font_color", { clear = true })

  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWinEnter",
    "TextChanged",
    "TextChangedI",
    "InsertLeave",
  }, {
    group = group,
    callback = function(event)
      local buf = event.buf
      if vim.bo[buf].filetype ~= "markdown" then
        return
      end

      vim.schedule(function()
        render_font_colors({ buf = buf })
      end)
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "markdown" then
          render_font_colors({ buf = buf })
        end
      end
    end,
  })
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = false,

    init = function()
      vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        callback = set_markdown_highlights,
      })

      setup_font_color_autocmds()
    end,

    opts = function()
      vim.env.PYTHONIOENCODING = vim.env.PYTHONIOENCODING or "utf-8"

      local converters = { "utftex" }
      local latex2text = vim.fn.exepath("latex2text")

      if latex2text == "" then
        local appdata = vim.env.APPDATA
        if appdata then
          local local_latex2text = vim.fs.joinpath(
            appdata,
            "Python",
            "Python311",
            "Scripts",
            "latex2text.exe"
          )

          if (vim.uv or vim.loop).fs_stat(local_latex2text) then
            latex2text = local_latex2text
          end
        end
      end

      if latex2text ~= "" then
        table.insert(converters, latex2text)
      else
        table.insert(converters, "latex2text")
      end

      return {
        latex = {
          enabled = true,
          converter = converters,
          highlight = "RenderMarkdownMath",
          position = "center",
          top_pad = 0,
          bottom_pad = 0,
        },

        html = {
          enabled = true,
          comment = {
            conceal = true,
          },
          tag = {
            -- Теги будут скрываться, а содержимое будет стилизоваться.
            -- Я специально не добавляю icon, чтобы не появлялся лишний горизонтальный отступ.

            b = {
              scope_highlight = "MdHtmlBold",
            },
            strong = {
              scope_highlight = "MdHtmlBold",
            },

            i = {
              scope_highlight = "MdHtmlItalic",
            },
            em = {
              scope_highlight = "MdHtmlItalic",
            },

            u = {
              scope_highlight = "MdHtmlUnderline",
            },

            mark = {
              scope_highlight = "MdHtmlMark",
            },

            kbd = {
              scope_highlight = "MdHtmlKbd",
            },

            code = {
              scope_highlight = "MdHtmlCode",
            },

            -- <font color="#..."> is handled by a local autocmd below.
            -- Keeping it out of html.tag avoids conceal shifting the text.
          },
        },

        quote = {
          enabled = true,
          icon = "▋",
          repeat_linebreak = false,
          highlight = {
            "RenderMarkdownQuote1",
            "RenderMarkdownQuote2",
            "RenderMarkdownQuote3",
            "RenderMarkdownQuote4",
            "RenderMarkdownQuote5",
            "RenderMarkdownQuote6",
          },
        },

        pipe_table = {
          enabled = true,
          preset = "round",
          cell = "padded",
          padding = 1,
          min_width = 3,
          border_enabled = true,
          border_virtual = false,
          alignment_indicator = "━",
          head = "RenderMarkdownTableHead",
          row = "RenderMarkdownTableRow",
          style = "full",
        },

        inline_highlight = {
          enabled = true,
          highlight = "RenderMarkdownInlineHighlight",
        },

        checkbox = {
          enabled = true,
          bullet = false,
          right_pad = 1,

          unchecked = {
            icon = "󰄱 ",
            highlight = "MdCheckboxUnchecked",
          },

          checked = {
            icon = "󰱒 ",
            highlight = "MdCheckboxChecked",
            scope_highlight = "MdCheckboxCheckedText",
          },

          custom = {
            todo = {
              raw = "[-]",
              rendered = "󰥔 ",
              highlight = "MdCheckboxTodo",
            },
            important = {
              raw = "[!]",
              rendered = " ",
              highlight = "MdCheckboxImportant",
            },
            question = {
              raw = "[?]",
              rendered = " ",
              highlight = "MdCheckboxQuestion",
            },
          },
        },

        link = {
          enabled = true,
          image = "󰥶 ",
          hyperlink = "󰌹 ",
          wiki = {
            enabled = true,
            icon = "󱗖 ",
            conceal_destination = true,
            highlight = "RenderMarkdownWikiLink",
          },
        },

        code = {
          enabled = true,
          sign = true,
          conceal_delimiters = true,
          language = true,
          position = "left",
          language_icon = true,
          language_name = true,
          width = "full",
          border = "hide",
          inline = true,
          highlight = "RenderMarkdownCode",
          highlight_border = "RenderMarkdownCodeBorder",
          highlight_inline = "RenderMarkdownCodeInline",
        },
      }
    end,
  },
}
