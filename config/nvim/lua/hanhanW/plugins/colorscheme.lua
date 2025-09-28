return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colors = require("onedarkpro.helpers").get_colors("vaporwave")
      require("onedarkpro").setup({
        colors = {
          onedark = { bg = colors.black },
        },
        highlights = {
        },
      })
      vim.cmd [[colorscheme onedark]]
    end,
  },
}
