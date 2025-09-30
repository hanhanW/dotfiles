return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      window = {
        position = 'right',
      },
      close_if_last_window = true,
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "▸",
          expander_expanded = "▾",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "",
            untracked = "#",
            ignored = "~",
            unstaged = "*",
            staged = "+",
            conflict = "?",
          },
        },
      },
      -- This is the default renderers, with icon removed.
      -- :lua require('neo-tree').paste_default_config()
      renderers = {
        directory = {
          { "indent" },
          { "current_filter" },
          { "name", use_git_status_colors = false },
          {
            "symlink_target",
            highlight = "NeoTreeSymbolicLinkTarget",
          },
        },
        file = {
          { "indent" },
          { "modified" },
          { "diagnostics" },
          { "git_status" },
          {
            "name",
          },
          {
            "symlink_target",
            highlight = "NeoTreeSymbolicLinkTarget",
          },
        },
      },
    },
    cmd = { 'Neotree' },
    keys = {
      {
        '<Leader><Tab>',
        function()
          require('neo-tree.command').execute({
            action = 'focus',
            toggle = true,
            position = 'right',
          })
        end,
        desc = 'Toggle nvim-tree',
      },
      {
        "<Leader>n",
        ":Neotree reveal<CR>:wincmd p<CR>",
        silent = true,
        desc = "Focus current file in NERDTree",
      },
    }
  }
}
