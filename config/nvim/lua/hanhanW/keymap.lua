local map = vim.keymap.set
local function simap(mode, lhs, rhs, opts)
  if opts == nil then
    opts = {}
  end
  opts.silent = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<Leader>t", ":tabe ", { desc = "New tab" })
map("n", "<Leader>\\", ":vsp ", { desc = "Vertical split" })
map("n", "<Tab>", ":tabnext<CR> ", { desc = "Go to next tab" })
map("n", "<S-Tab>", ":tabprevious<CR> ", { desc = "Go to previous tab" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map({ "n", "v" }, ";", ":")

map("n", "<PageUp>", "<C-b>")
map("n", "<PageDown>", "<C-f>")
map("n", "<Home>", "0")
map("n", "<End>", "$")

-- Swap j <-> gj, k <-> gk. It is more intuitive when moving in long lines.
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")

-- Indent the selected block around.
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Make +/- be increasing/decreasing the number.
map("n", "+", "<C-a>", { desc = "Increase number under cursor" })
map("n", "-", "<C-x>", { desc = "Decrease number under cursor" })

-- Tmux uses <C-a>. Let's use <C-b> instead.
map("i", "<C-b>", "<C-a>")

simap("n", "<Leader>/", "<Cmd>nohl<CR>", { desc = "Clear search highlight" })
simap("n", "<Leader>w", "<Cmd>w!<CR>", { desc = "Save file" })
simap("n", "<Leader>q", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
simap("n", "<Leader><Leader>", "<Cmd>b #<CR>", { desc = "Switch to last buffer" })

map({ "n", "x" }, "<Find>", "0")
map({ "i", "c" }, "<Find>", "<Home>")
map({ "n", "x" }, "<Select>", "$")
map({ "i", "c" }, "<Select>", "<End>")
