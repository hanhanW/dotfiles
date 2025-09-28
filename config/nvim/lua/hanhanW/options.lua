vim.autoread = true -- Trigger autoread when files change on disk
local opt = vim.opt

opt.background = 'dark' -- Set background to dark.
opt.termguicolors = true -- Enable 24-bit RGB colors.

opt.autoindent = true -- Auto indent new lines.
opt.number = true -- Show line numbers.
opt.showmatch = true -- Highlight matching parenthesis.
opt.ignorecase = true -- Ignore case when searching.
opt.incsearch = true -- Show search matches as you type.
opt.hlsearch = true -- Highlight search results.
opt.history = 10000 -- Number of commands to remember in history.
opt.wrap = false -- Don't wrap lines.
opt.wildmenu = true -- Use wildmenu for command line completion.
opt.laststatus = 2 -- Always show the status line.
opt.mouse = 'a' -- Enable mouse support in all modes.

opt.textwidth = 80 -- Maximum width of text that is being inserted.
opt.expandtab = true -- Use spaces instead of tabs.
opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations.
opt.smartcase = true -- Don't ignore case if search contains uppercase letters.
opt.signcolumn = 'yes' -- Always show the sign column to avoid text shifting.
opt.colorcolumn = '+1' -- Highlight column for max text width.
opt.ruler = true -- Show the cursor position all the time.

opt.splitright = true -- Vertical splits will automatically be to the right.

opt.encoding = 'utf8'
opt.fileencoding = 'utf8'

opt.updatetime = 100
opt.timeoutlen = 300
opt.ttimeoutlen = 20

opt.showmode = true -- Don't show mode since we use a statusline.
opt.showcmd = true -- Show (partial) command in the last line of the screen.

opt.foldenable = true -- Enable code folding.
opt.foldmethod = 'marker' -- Set fold method to marker.

-- Disable auto wrap if filetype is mlir.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'mlir',
  callback = function()
    opt.wrap = false
    opt.textwidth = 0
    opt.wrapmargin = 0
    opt.colorcolumn = "81"
    vim.bo.filetype = "mlir"
  end,
})

-- Save your swp files to a less annoying place than the current directory.
-- If you have .vim-swap in the current directory, it'll use that.
-- Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if vim.fn.isdirectory('~/.local/share/nvim/swap') == 0 then
  vim.fn.mkdir(vim.fn.expand('~/.local/share/nvim/swap'), 'p')
end
opt.directory = { './.vim-swap//', vim.fn.expand('~/.local/share/nvim/swap//'), vim.fn.expand('~/tmp//'), '.' }

-- undofile - This allows you to use undos after exiting and restarting
-- This, like swap and backups, uses .vim-undo first, then ~/.vim/undo,
-- then .
opt.undofile = true
if vim.fn.isdirectory(vim.fn.expand('~/.nvim/undo')) == 0 then
  vim.fn.mkdir(vim.fn.expand('~/.nvim/undo'), 'p')
end
opt.undodir = { './.nvim-undo//', vim.fn.expand('~/.nvim/undo//'), '.' }
