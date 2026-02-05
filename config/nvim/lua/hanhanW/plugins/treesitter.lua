-- Install parsers with :TSInstall <lang>
-- Commonly used: c cpp lua python rust mlir tablegen gitcommit git_rebase
-- markdown vim vimdoc json yaml bash cmake

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Enable treesitter highlighting for any filetype with a parser
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
