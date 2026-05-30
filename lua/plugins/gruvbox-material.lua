return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Настройки темы
      vim.g.gruvbox_material_background = "hard" -- soft | medium | hard
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = 0

      -- Применить тему
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
