-- ~/.config/nvim/lua/plugins/render-markdown.lua

if vim.env.NVIM_NEOVIDE_DISABLE_RENDER_MARKDOWN == "1" then
  return {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      enabled = false,
    },
  }
end

local highlights = require("config.render_markdown.highlights")
local font_matches = require("config.render_markdown.font_matches")

local function markdown_rendering_is_minimal()
  return vim.env.NVIM_NEOVIDE_MINIMAL_RENDER_MARKDOWN == "1"
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },

    init = function()
      if vim.env.NVIM_NEOVIDE_DISABLE_RENDER_MARKDOWN_HIGHLIGHTS ~= "1" then
        vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
          callback = highlights.setup,
        })
      end

      font_matches.setup()
    end,

    opts = function()
      if markdown_rendering_is_minimal() then
        return {
          html = { enabled = false },
          latex = { enabled = false },
          pipe_table = { enabled = false },
          inline_highlight = { enabled = false },
          checkbox = { enabled = false },
          link = { enabled = false },
          code = {
            enabled = true,
            sign = false,
            conceal_delimiters = false,
            language = false,
            language_icon = false,
            language_name = false,
            width = "block",
            inline = false,
          },
        }
      end

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

            -- <b>, <strong>, <i>, and <em> are handled by Tree-sitter.
            -- Supported <font color="#..."> values are handled by lightweight window matches.

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
