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

  -- lua default desciprtion to nil if not provided.
  local map = function(mapping, func, description --[[@as string|nil]])
    vim.keymap.set("n", mapping, func, { desc = description })
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
  end, "Find files in current dir in new tab")
  map("<Leader>fg", lookupFilesFromGitRoot, "Find files from git root")
  map("<Leader>fl", fzf.files, "Find files in current dir in the current tab")
  map("<Leader>fb", fzf.buffers, "Find buffers")
  map("<Leader>fw", fzf.grep, "Grep in files")
  map("<Leader>fd", fzf.diagnostics_document, "Diagnostics in current file")
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = fzf_config,
    event = "VeryLazy",
  },
}
