return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Note: Language-specific adapters should be added in their respective configs
      "mfussenegger/nvim-dap", -- For debug integration
    },
    config = function()
      require("neotest").setup({
        -- Core configuration
        discovery = {
          enabled = true,
          concurrent = true,
          filter_dir = function(name)
            -- Skip these directories for test discovery
            return not vim.tbl_contains({
              "venv",
              ".venv",
              "build",
              "dist",
              "__pycache__",
              ".git",
            }, name)
          end,
        },

        -- Status indicators
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },

        -- Output handling
        output = {
          enabled = true,
          open_on_run = true,
        },

        -- Summary window
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            output = "o",
            run = "r",
            run_marked = "R",
            mark = "m",
            debug = "d",
            debug_marked = "D",
            stop = "s",
            watch = "w",
          },
        },

        -- Icons for test status
        icons = {
          failed = "✖",
          passed = "✓",
          running = "⟳",
          skipped = "ﰸ",
          unknown = "?",
        },

        -- Floating window configuration
        floating = {
          border = "rounded",
          max_height = 0.8,
          max_width = 0.8,
          options = {},
        },

        -- Default test run strategy
        default_strategy = "integrated",

        -- Configure output diagnostics
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },

        -- Configure watch mode
        watch = {
          enabled = true,
          symbols_priority = 1000,
        },

        -- Run strategy configuration
        strategies = {
          integrated = {
            width = 120,
            height = 40,
          },
        },

        -- Enable jump functionality
        jump = {
          enabled = true,
        },

        -- Adapters will be configured in language-specific files
        adapters = {},
      })
    end,
    keys = {
      -- General test operations
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run Current File",
      },
      {
        "<leader>tT",
        function()
          local root = vim.fn.getcwd()
          -- Try to find the tests directory
          local tests_dir = vim.fn.isdirectory(root .. "/tests") == 1 and (root .. "/tests")
            or (vim.fn.isdirectory(root .. "/test") == 1 and (root .. "/test") or root)
          require("neotest").run.run(tests_dir)
        end,
        desc = "Run All Tests",
      },
      {
        "<leader>tx",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Tests",
      },

      -- Test debugging
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      {
        "<leader>tF",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug Current File",
      },

      -- Test watching
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle()
        end,
        desc = "Toggle Watch",
      },
      {
        "<leader>tW",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch File",
      },

      -- Test navigation
      {
        "<leader>tn",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Jump to Next Failed",
      },
      {
        "<leader>tp",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Jump to Previous Failed",
      },

      -- Test output
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },

      -- Test summary
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
    },
  },
}
