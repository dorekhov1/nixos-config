return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Set up diagnostics display
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- Could be '■', '▎', 'x'
      },
      severity_sort = true,
      float = {
        source = "always", -- Show source in diagnostics window
        border = "rounded",
        style = "minimal",
      },
    })

    -- Override handlers for better hover and signature help
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    -- Create a command to toggle LSP logging level
    vim.api.nvim_create_user_command("LspDebugToggle", function()
      local current_level = vim.lsp.get_log_level()
      if current_level ~= "DEBUG" then
        vim.lsp.set_log_level("DEBUG")
        vim.notify("LSP log level set to DEBUG", vim.log.levels.INFO)
      else
        vim.lsp.set_log_level("WARN")
        vim.notify("LSP log level set to WARN", vim.log.levels.INFO)
      end
    end, { desc = "Toggle LSP debug logging" })

    -- Add command to open LSP log
    vim.api.nvim_create_user_command("LspLog", function()
      vim.cmd("edit " .. vim.lsp.get_log_path())
    end, { desc = "Open the LSP log file" })

    return opts
  end,
}
