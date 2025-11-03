return {
  -- A plugin to highlight trailing whitespace in Vim.
  {
    'hanhanW/vim-trailing-whitespace',
    lazy = false,
  },
  -- A plugin that adds indentation guides to all lines (including empty lines).
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    event = 'VeryLazy',
  },
  -- A plugin that shows a git diff in the sign column.
  {
    'mhinz/vim-signify',
  },
  -- A Git wrapper so awesome, it should be illegal.
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  -- A plugin to enhance the f and t motions in Vim.
  {
    'rhysd/clever-f.vim',
    event = 'VeryLazy',
  },
  -- A plugin that shows a popup with possible keybindings of the command you
  -- started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- A light and configurable statusline/tabline plugin for Vim.
  {
    'itchyny/lightline.vim',
    event = 'VeryLazy',
  },
  -- A plugin for aligning text in Vim.
  {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
    keys = { { '<Leader>a', '<Plug>(EasyAlign)', mode = { 'n', 'x' } } },
  },
}
