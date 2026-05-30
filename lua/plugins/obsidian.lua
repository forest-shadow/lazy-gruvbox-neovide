-- Native Windows path.
-- В Lua для Windows-путей удобнее использовать прямые слэши.
local OBSIDIAN_PARENT_DIR = "D:/Obsidian"

-- Если vault'ы лежат в Documents, можно использовать так:
-- local OBSIDIAN_PARENT_DIR = vim.fs.joinpath(vim.env.USERPROFILE, "Documents", "Obsidian")

local function obsidian_workspaces(parent_dir)
  local uv = vim.uv or vim.loop
  local workspaces = {}

  parent_dir = vim.fs.normalize(vim.fn.expand(parent_dir))

  local handle = uv.fs_scandir(parent_dir)
  if not handle then
    return workspaces
  end

  while true do
    local name, type = uv.fs_scandir_next(handle)

    if not name then
      break
    end

    if type == "directory" then
      local vault_path = vim.fs.joinpath(parent_dir, name)
      local obsidian_dir = vim.fs.joinpath(vault_path, ".obsidian")

      if uv.fs_stat(obsidian_dir) then
        table.insert(workspaces, {
          name = name,
          path = vault_path,
        })
      end
    end
  end

  table.sort(workspaces, function(a, b)
    return a.name < b.name
  end)

  return workspaces
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = "Obsidian",

    ---@module "obsidian"
    ---@type obsidian.config
    opts = {
      legacy_commands = false,

      workspaces = obsidian_workspaces(OBSIDIAN_PARENT_DIR),

      ui = {
        enable = false,
      },

      footer = {
        enabled = false,
      },

      statusline = {
        enabled = false,
      },

      completion = {
        blink = false,
        nvim_cmp = false,
      },

      frontmatter = {
        enabled = false,
      },

      templates = {
        enabled = false,
      },

      daily_notes = {
        enabled = false,
      },

      unique_note = {
        enabled = false,
      },

      checkbox = {
        enabled = false,
      },

      sync = {
        enabled = false,
      },

      comment = {
        enabled = false,
      },

      slides = {
        enabled = false,
      },

      backlinks = {
        parse_headers = false,
      },

      search = {
        sort_by = false,
        sort_reversed = false,
        max_lines = 1000,
      },

      link = {
        style = "wiki",
        format = "shortest",
        auto_update = false,
      },

      picker = {
        name = "snacks.picker",
      },

      open_notes_in = "current",
    },

    keys = {
      {
        "<leader>ow",
        "<cmd>Obsidian workspace<cr>",
        desc = "Obsidian: workspace",
      },

      {
        "<leader>oq",
        "<cmd>Obsidian quick_switch<cr>",
        desc = "Obsidian: quick switch",
      },

      {
        "<leader>os",
        "<cmd>Obsidian search<cr>",
        desc = "Obsidian: search",
      },

      {
        "<leader>of",
        "<cmd>Obsidian follow_link<cr>",
        desc = "Obsidian: follow link",
      },

      {
        "<leader>ob",
        "<cmd>Obsidian backlinks<cr>",
        desc = "Obsidian: backlinks",
      },

      {
        "<leader>on",
        "<cmd>Obsidian new<cr>",
        desc = "Obsidian: new note",
      },

      {
        "<leader>o?",
        "<cmd>Obsidian help<cr>",
        desc = "Obsidian: help",
      },
    },
  },
}