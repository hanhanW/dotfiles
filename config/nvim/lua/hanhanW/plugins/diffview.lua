-- A plugin for reviewing diffs of all modified files in a GitHub-like UI.
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Review uncommitted changes" },
    { "<leader>dm", "<cmd>DiffviewFileHistory --range=origin/main...HEAD --right-only --no-merges<cr>", desc = "Review commits vs main" },
    { "<leader>dp", function()
      local parent = vim.trim(vim.fn.system("git rev-parse --abbrev-ref --symbolic-full-name @{u}"))
      if vim.v.shell_error ~= 0 then
        vim.notify("No upstream tracking branch set", vim.log.levels.WARN)
        return
      end
      vim.cmd("DiffviewFileHistory --range=" .. parent .. "...HEAD --right-only --no-merges")
    end, desc = "Review commits vs parent branch" },
    { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = "diff2_horizontal" },
    },
  },
}
