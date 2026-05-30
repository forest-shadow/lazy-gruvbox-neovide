return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.list_contains(opts.ensure_installed, "latex") then
        table.insert(opts.ensure_installed, "latex")
      end
    end,
  },
}
