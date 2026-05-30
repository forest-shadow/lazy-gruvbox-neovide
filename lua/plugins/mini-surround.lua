return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
      require("mini.surround").setup({
        custom_surroundings = {
          R = {
            input = { '<font color="#fb4934">().-()</font>' },
            output = { left = '<font color="#fb4934">', right = "</font>" },
          },
          P = {
            input = { '<font color="#d3869b">().-()</font>' },
            output = { left = '<font color="#d3869b">', right = "</font>" },
          },
          Y = {
            input = { '<font color="#d79921">().-()</font>' },
            output = { left = '<font color="#d79921">', right = "</font>" },
          },
          C = {
            input = { "```[%w_%-]*\n().-()\n```" },
            output = function()
              local lang = MiniSurround.user_input("Language: ")
              if lang == nil then
                return nil
              end

              return {
                left = "```" .. lang .. "\n",
                right = "\n```",
              }
            end,
          },
          L = {
            input = { '$$().-()$$' },
            output = { left = "$$", right = "$$" },
          }
        },
      })
    end,
  },
}
