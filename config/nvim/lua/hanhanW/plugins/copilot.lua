return {
  {
    'github/copilot.vim',
    -- remap keys for accepting copilot suggestions
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<C-f>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false
        })
      vim.keymap.set('i', '<C-j>', '<Plug>(copilot-accept-word)', {desc = 'Accept copilot suggestion word'})
    end
  },
}
