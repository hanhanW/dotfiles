return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
    config = function()
      -- Configure fold settings for nvim-ufo
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.o.fillchars = 'eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸'

      -- Keymaps for folding
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })

      -- Setup ufo with treesitter and indent providers
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          -- Disable ufo for MLIR files (use custom mlir-fold plugin instead)
          if filetype == 'mlir' then
            return ''
          end
          return { 'treesitter', 'indent' }
        end,
      })
    end,
  },
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        -- configuration goes here, for example:
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          {
            sign = { name = { 'Signify' }, maxwidth = 2, colwidth = 1, auto = true },
            click = 'v:lua.ScSa'
          },
          {
            sign = { namespace = { 'diagnostic' }, maxwidth = 1, colwidth = 1 },
            click = 'v:lua.ScSa'
          },
          { text = { builtin.lnumfunc }, click = 'v:lua.ScLa', },
        }
      })
    end,
  }
}
