-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if vim.g.neovide then
  -- Copy selected text to system clipboard
  vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })

  -- Paste from system clipboard in normal/visual/insert/command/terminal modes
  vim.keymap.set({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
  vim.keymap.set("i", "<C-v>", '<C-r>+', { desc = "Paste from system clipboard" })
  vim.keymap.set("c", "<C-v>", '<C-r>+', { desc = "Paste from system clipboard" })

  -- Optional Ctrl+Shift variants
  vim.keymap.set("v", "<C-S-c>", '"+y', { desc = "Copy to system clipboard" })
  vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+p', { desc = "Paste from system clipboard" })
  vim.keymap.set("i", "<C-S-v>", '<C-r>+', { desc = "Paste from system clipboard" })
  vim.keymap.set("c", "<C-S-v>", '<C-r>+', { desc = "Paste from system clipboard" })
end