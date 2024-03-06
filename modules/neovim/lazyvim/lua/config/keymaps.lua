-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "[B", vim.cmd.bfirst, { silent = true, desc = "Go to first buffer" })
vim.keymap.set("n", "]B", vim.cmd.blast, { silent = true, desc = "Go to last buffer" })

-- Remove {} motions from the jumplist
vim.keymap.set("n", "}", function()
  local count = vim.v.count1
  vim.cmd("keepjumps norm! " .. count .. "}")
end, { noremap = true })
vim.keymap.set("n", "{", function()
  local count = vim.v.count1
  vim.cmd("keepjumps norm! " .. count .. "{")
end, { noremap = true })

-- Move selection around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Copy
vim.keymap.set({ "v", "n" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", 'gg"+yG', { desc = "Copy the entire file to system clipboard" })
