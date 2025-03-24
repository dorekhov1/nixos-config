-- LSP Configuration
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    -- Customize client capabilities
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end

    -- Log the active client for debugging
    vim.notify(string.format("LSP %s attached to buffer %d", client.name, args.buf), vim.log.levels.INFO)
  end,
  desc = "LSP: Configure client capabilities on attach",
})

-- Debug LSP when needed (uncomment when debugging)
-- vim.lsp.set_log_level('debug')
