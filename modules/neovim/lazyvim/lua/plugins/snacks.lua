return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Configure Snacks properly with image disabled
    require("snacks").setup({
      -- Core components
      notifier = {
        enabled = true,
      },

      -- Explicitly disable image
      image = {
        enabled = false,
      },

      -- Configure picker properly
      picker = {
        enabled = true,
        ui = {
          select = true, -- Enable vim.ui.select integration
        },
      },

      -- Keep the rest of your preferred options
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      input = { enabled = true },
      explorer = { enabled = false },
      statuscolumn = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
    })

    -- Set vim.ui.select explicitly and re-assert after LazyDone so nothing overrides it
    vim.ui.select = require("snacks.picker").select
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyDone",
      callback = function()
        vim.ui.select = require("snacks.picker").select
      end,
    })
  end,
}
