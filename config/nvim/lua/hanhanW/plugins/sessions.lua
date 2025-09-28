return {
  "rmagatti/auto-session",
  lazy = false,
  -- TODO: Add telescope integration.
  config = function()
    require("auto-session").setup()
  end,
}
