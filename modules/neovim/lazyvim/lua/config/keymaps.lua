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

-- LSP Navigation
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions({ reuse_win = true })
end, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Go to References" })
vim.keymap.set("n", "gI", function()
  require("telescope.builtin").lsp_implementations({ reuse_win = true })
end, { desc = "Go to Implementation" })
vim.keymap.set("n", "gy", function()
  require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
end, { desc = "Go to Type Definition" })

-- Noice / Notifications / Logs
vim.keymap.set("n", "<leader>nh", function()
  require("noice").cmd("history")
end, { desc = "Noice History" })
vim.keymap.set("n", "<leader>nl", function()
  require("noice").cmd("last")
end, { desc = "Noice Last Message" })
vim.keymap.set("n", "<leader>ne", function()
  require("noice").cmd("errors")
end, { desc = "Noice Errors" })
vim.keymap.set("n", "<leader>nn", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification History (Snacks)" })
vim.keymap.set("n", "<leader>nN", function()
  require("snacks").notifier.hide()
end, { desc = "Dismiss Notifications (Snacks)" })
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy log<cr>", { desc = "Lazy Log" })
