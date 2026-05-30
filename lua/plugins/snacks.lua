return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = false,
      },
      picker = {
        sources = {
          explorer = {
            -- show dot-files and directories:
            -- .env, .gitignore, .github/, .config/, etc.
            hidden = true,

            -- explorer panel settings
            win = {
              list = {
                wo = {
                  number = true,
                  relativenumber = false,
                },
              },
            },

            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                position = "right",
              },
            },
          },
        },
      },
    },
  },
}