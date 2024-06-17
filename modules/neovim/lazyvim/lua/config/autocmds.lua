-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local function zellij_nav(short_direction, direction)
  local cur_winnr = vim.fn.winnr()
  vim.cmd("wincmd " .. short_direction)
  if cur_winnr == vim.fn.winnr() then
    os.execute("zellij action move-focus " .. direction)
  end
end

local function ZellijNavigateUp()
  zellij_nav("k", "up")
end

local function ZellijNavigateDown()
  zellij_nav("j", "down")
end

local function ZellijNavigateRight()
  zellij_nav("l", "right")
end

local function ZellijNavigateLeft()
  zellij_nav("h", "left")
end

local function ZellijLock()
  os.execute("zellij action switch-mode locked")
end

local function ZellijUnlock()
  os.execute("zellij action switch-mode normal")
end

local function ZellijNewPane(direction)
  ZellijUnlock()
  local dir = (direction and #direction > 0) and (" --direction " .. direction) or " --floating"
  os.execute(
    "zellij action new-pane" .. dir .. ' --close-on-exit --cwd "' .. vim.fn.getcwd() .. '" -- ' .. os.getenv("SHELL")
  )
end

local zellij_navigator_loaded = vim.g.zellij_navigator_loaded
local zellij_navigator_enabled = vim.g.zellij_navigator_enabled

if zellij_navigator_loaded or (zellij_navigator_enabled and zellij_navigator_enabled ~= 1) then
  return
end

vim.g.zellij_navigator_loaded = 1

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  group = augroup("zellij_lock"),
  callback = function()
    ZellijLock()
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup("zellij_unlock"),
  callback = function()
    ZellijUnlock()
  end,
})

vim.api.nvim_create_user_command("ZellijNavigateUp", function()
  ZellijNavigateUp()
end, {})

vim.api.nvim_create_user_command("ZellijNavigateDown", function()
  ZellijNavigateDown()
end, {})

vim.api.nvim_create_user_command("ZellijNavigateLeft", function()
  ZellijNavigateLeft()
end, {})

vim.api.nvim_create_user_command("ZellijNavigateRight", function()
  ZellijNavigateRight()
end, {})

vim.api.nvim_create_user_command("ZellijNewPane", function()
  ZellijNewPane()
end, {})

vim.api.nvim_create_user_command("ZellijNewPaneSplit", function()
  ZellijNewPane("down")
end, {})

vim.api.nvim_create_user_command("ZellijNewPaneVSplit", function()
  ZellijNewPane("right")
end, {})

local zellij_navigator_no_default_mappings = vim.g.zellij_navigator_no_default_mappings
if zellij_navigator_no_default_mappings and zellij_navigator_no_default_mappings == 1 then
  return
end

vim.api.nvim_set_keymap("n", "<C-h>", ":ZellijNavigateLeft<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":ZellijNavigateDown<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":ZellijNavigateUp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":ZellijNavigateRight<CR>", { noremap = true, silent = true })
