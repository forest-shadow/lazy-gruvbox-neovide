return {
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = {
        enabled = true,
        size = 1.5 * 1024 * 1024, -- 1.5 MB
      },
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