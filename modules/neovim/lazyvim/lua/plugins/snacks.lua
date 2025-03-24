return {
  -- Use folke's fork of snacks.nvim
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Core components
      notifier = {
        enabled = true,
      },

      -- Keep enabled components that are working
      bigfile = {
        enabled = true,
      },
      dashboard = {
        enabled = true,
      },
      input = {
        enabled = true,
      },

      -- Fix picker configuration
      picker = {
        enabled = true,
        -- Maintain existing vim.ui.select provider if it's working
        ui = {
          select = false, -- Don't override existing select UI
        },
      },

      -- Fix image settings
      image = {
        enabled = true,
        terminal = {
          wezterm = {
            enabled = true,
          },
          kitty = {
            enabled = false,
          },
        },
      },

      -- Adjust explorer to avoid duplicates with neo-tree
      explorer = {
        enabled = false, -- Disable since neo-tree is already active
      },

      statuscolumn = {
        enabled = true,
      },

      quickfile = {
        enabled = true,
      },
      scope = {
        enabled = true,
      },
      scroll = {
        enabled = true,
      },
      toggle = {
        enabled = true,
      },
      words = {
        enabled = true,
      },
    },
  },
}
