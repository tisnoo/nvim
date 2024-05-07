-- cursor
vim.opt.guicursor = ""
vim.opt.guicursor = "i:blinkon100"

-- line number
vim.opt.number = true
vim.opt.relativenumber = true

-- device clipboard
vim.opt.clipboard = "unnamedplus"

-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-- spell
vim.opt.spell = true
vim.opt.spelllang = "en,nl"
vim.opt.spellcapcheck = ""

-- iterm multiple tabs
vim.cmd('autocmd SwapExists * let v:swapchoice = "e"')

-- format on save, moved this code to plugins/lsp-config.lua
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     vim.lsp.buf.format()
--   end,
-- })

-- dart specific
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.smartindent = true
    vim.opt_local.autoindent = true
    vim.opt_local.cindent = true
  end,
})

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Normal pane navigation, moved this to plugins/nvim-tmux-navigation.lua
-- vim.keymap.set("n", "<C-h>", "<C-w>h", {})
-- vim.keymap.set("n", "<C-j>", "<C-w>j", {})
-- vim.keymap.set("n", "<C-k>", "<C-w>k", {})
-- vim.keymap.set("n", "<C-l>", "<C-w>l", {})

-- Terminal pane navigation
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>", {})
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>", {})
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>", {})
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>", {})

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

-- Make Shift + Tab outdent
vim.keymap.set("i", "<S-Tab>", "<C-D>", { noremap = true })

-- Get out of terminal mode using escape
vim.keymap.set("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true })

vim.wo.number = true
