-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g
local wo = vim.wo

-- Enable true colour support
if fn.has("termguicolors") then
  opt.termguicolors = true
end
