local treesitter_langs = {
  "c",
  "cpp",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "mlir",
  "python",
  "rust",
  "ruby",
  "styled",
  "tablegen",
  "typescript",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = treesitter_langs,
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- TODO: Switch to main branch once mlir is fixed.
  -- {
  --  'nvim-treesitter/nvim-treesitter',
  --  branch = 'main',
  --  lazy = false,
  --  build = ':TSUpdate',
  --  config = function()
  --    local configs = require('nvim-treesitter')
  --    configs.setup({
  --      ensure_installed = treesitter_langs,
  --      sync_install = false,
  --      auto_install = true,
  --      ignore_install = {},
  --      modules = {},
  --      highlight = { enable = true },
  --      indent = { enable = true },
  --    })
  --  end,
  -- },
}
