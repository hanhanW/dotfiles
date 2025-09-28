local function comment_nvim_keys()
  return {
    {
      '<Leader>c<Leader>',
      function()
        if vim.api.nvim_get_vvar('count') == 0 then
          return '<Plug>(comment_toggle_linewise_current)'
        else
          return '<Plug>(comment_toggle_linewise_count)'
        end
      end,
      expr = true,
      desc = 'Toggle the comment of current line',
    },
    {
      '<Leader>c<Leader>',
      '<Plug>(comment_toggle_linewise_visual)',
      mode = 'x',
      desc = 'Toggle comment with linewise style',
    },
    {
      '<Leader>cc',
      function()
        if vim.api.nvim_get_vvar('count') == 0 then
          return '<Plug>(comment_toggle_blockwise_current)'
        else
          return '<Plug>(comment_toggle_blockwise_count)'
        end
      end,
      expr = true,
      desc = 'Toggle the comment of current line with block style',
    },
    {
      '<Leader>cc',
      '<Plug>(comment_toggle_blockwise_visual)',
      mode = 'x',
      { desc = 'Toggle comment with blockwise style' },
    },
    {
      '<Leader>ca',
      function()
        require('Comment.api').locked('insert.linewise.eol')()
      end,
      desc = 'Insert comment at the end of the current line',
    },
  }
end

return {
  {
    'numToStr/Comment.nvim',
    opts = {
      mappings = {
        basic = false,
        extra = false,
      },
    },
    keys = comment_nvim_keys(),
  },
}
