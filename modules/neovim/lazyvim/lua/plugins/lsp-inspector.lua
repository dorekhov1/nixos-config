return {
  "neovim/nvim-lspconfig",
  keys = {
    {
      "<leader>ci",
      function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
          return
        end

        local lines = { "LSP Clients for current buffer:" }
        for _, client in ipairs(clients) do
          table.insert(lines, string.format("- %s (id: %d)", client.name, client.id))

          local caps = client.server_capabilities
          table.insert(lines, "  Capabilities:")
          table.insert(lines, string.format("  - Definition: %s", caps.definitionProvider and "✓" or "✗"))
          table.insert(lines, string.format("  - References: %s", caps.referencesProvider and "✓" or "✗"))
          table.insert(lines, string.format("  - Hover: %s", caps.hoverProvider and "✓" or "✗"))
          table.insert(lines, string.format("  - Completion: %s", caps.completionProvider and "✓" or "✗"))
          table.insert(lines, string.format("  - CodeAction: %s", caps.codeActionProvider and "✓" or "✗"))
        end

        -- Create a floating window to display the information
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        local width = 60
        local height = #lines
        local opts = {
          relative = "editor",
          width = width,
          height = height,
          col = math.floor((vim.o.columns - width) / 2),
          row = math.floor((vim.o.lines - height) / 2),
          style = "minimal",
          border = "rounded",
        }

        local win = vim.api.nvim_open_win(buf, true, opts)
        vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })

        -- Highlight
        vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)
        for i, line in ipairs(lines) do
          if line:match("^- ") then
            vim.api.nvim_buf_add_highlight(buf, -1, "Function", i - 1, 0, -1)
          elseif line:match("^  - .+: ✓") then
            vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticOk", i - 1, 0, -1)
          elseif line:match("^  - .+: ✗") then
            vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticError", i - 1, 0, -1)
          end
        end
      end,
      desc = "Inspect LSP Clients",
    },
  },
}
