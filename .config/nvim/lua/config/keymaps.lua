-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-f>", ":!tmux neww search<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { noremap = true, silent = true })
