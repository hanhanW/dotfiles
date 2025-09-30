local function fzf_config()
  local actions = require("fzf-lua.actions")
  local fzf = require("fzf-lua")
  fzf.setup({
    fzf_bin = "fzf",
    actions = {
      files = {
        ["default"] = actions.file_edit,
      },
    },
  })
  fzf.register_ui_select()

  local map = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs)
  end

  local lookupFilesFromGitRoot = function()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if git_root and git_root ~= "" then
      vim.cmd("tabnew")
      fzf.files({ cwd = git_root })
    else
      print("Not in a git repository")
      return nil
    end
  end
  -- TODO: Close the tab if no file is selected.
  map("<Leader>ff", function()
    vim.cmd("tabnew")
    fzf.files()
  end)
  map("<Leader>fg", lookupFilesFromGitRoot)
  map("<Leader>fl", fzf.files)
  map("<Leader>fb", fzf.buffers)
  map("<Leader>fw", fzf.grep)
  map("<Leader>fd", fzf.diagnostics_document)
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = fzf_config,
    event = "VeryLazy",
  },
}
