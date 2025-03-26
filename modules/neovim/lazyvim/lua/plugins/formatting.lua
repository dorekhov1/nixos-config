return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- Make sure formatters is initialized
    opts.formatters = opts.formatters or {}

    -- Configure standard formatters for Python
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft["python"] = {
      "ruff_fix --ignore=F401", -- Skip unused imports on regular format
      "ruff_format",
      -- "black",
    }

    -- Create a custom formatter JUST for F401 (unused imports)
    opts.formatters.ruff_imports = {
      command = "ruff",
      args = function()
        return {
          "check",
          "--select=F401", -- ONLY select unused imports rule
          "--fix",
          "--stdin-filename",
          "$FILENAME",
          "-", -- Read from stdin
        }
      end,
      stdin = true,
    }

    return opts
  end,

  -- Add custom keybinding specifically for unused imports
  keys = {
    {
      "<leader>cR",
      function()
        require("conform").format({
          formatters = { "ruff_imports" },
          async = true,
          lsp_fallback = false,
        })
        vim.notify("Removed unused imports", vim.log.levels.INFO)
      end,
      desc = "Remove Unused Imports",
      ft = "python",
    },
  },
}
