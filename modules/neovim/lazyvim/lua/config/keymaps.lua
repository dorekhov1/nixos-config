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

-- Smart paste that respects current indentation
vim.keymap.set("n", "p", function()
  -- Get the current indentation level
  local indent_level = vim.fn.indent(vim.fn.line("."))
  local lines = vim.fn.getreg('"'):gsub("\n$", ""):split("\n")

  -- Check if we're pasting a Python block
  local is_python_block = vim.bo.filetype == "python" and #lines > 1

  if is_python_block then
    -- Determine the minimum indentation in the yanked code
    local min_indent = math.huge
    for _, line in ipairs(lines) do
      if #line:match("^%s*") < min_indent and line:match("%S") then
        min_indent = #line:match("^%s*")
      end
    end

    -- Re-indent each line to match the current position
    local indented_lines = {}
    for _, line in ipairs(lines) do
      if line:match("%S") then
        local spaces = line:match("^%s*")
        local content = line:sub(#spaces + 1)
        local new_indent = string.rep(" ", indent_level + (#spaces - min_indent))
        table.insert(indented_lines, new_indent .. content)
      else
        table.insert(indented_lines, "")
      end
    end

    -- Put the indented text
    vim.api.nvim_put(indented_lines, "l", true, true)
  else
    -- For non-python or single-line pastes, use normal p
    return "p"
  end
end, { expr = true, silent = true, desc = "Smart paste respecting indentation" })
