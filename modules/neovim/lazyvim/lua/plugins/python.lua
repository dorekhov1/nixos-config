return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Determine which Python LSP to use based on config (defaults to pyright)
      local lsp = vim.g.lazyvim_python_lsp or "basedpyright"
      -- Determine which Ruff implementation to use (defaults to new "ruff")
      local ruff = vim.g.lazyvim_python_ruff or "ruff"

      -- Configure servers
      if lsp == "pyright" then
        opts.servers.pyright = {
          settings = {
            pyright = {
              -- Let Ruff handle imports
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        }
      elseif lsp == "basedpyright" then
        opts.servers.basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        }
      end

      -- Configure Ruff
      if ruff == "ruff" then
        opts.servers.ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        }
      elseif ruff == "ruff_lsp" then
        opts.servers.ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        }
      end

      -- Enable/disable servers
      local servers = { "pyright", "basedpyright", "ruff", "ruff_lsp" }
      for _, server in ipairs(servers) do
        opts.servers[server] = opts.servers[server] or {}
        opts.servers[server].enabled = (server == lsp) or (server == ruff)
      end

      -- Set up handlers
      opts.setup = opts.setup or {}
      opts.setup.basedpyright = function()
        -- Explicitly enable hover support
        Snacks.util.lsp.on(function(bufnr, client)
          -- Force enable hover support for BasedPyright
          if client.name == "basedpyright" then
            client.server_capabilities.hoverProvider = true
          end
        end)
        return false -- Continue with default setup
      end

      -- Configure Ruff LSP to defer to Pyright for certain capabilities
      opts.setup[ruff] = function()
        Snacks.util.lsp.on(function(_, client)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
          -- Optionally disable other capabilities if needed
          -- client.server_capabilities.completionProvider = false
        end)
        return false -- Return false to allow the default setup to proceed
      end

      return opts
    end,
  },
  {
    "nvim-neotest/neotest-python",
    dependencies = {
      "nvim-neotest/neotest",
    },
    ft = { "python" },
    config = function()
      -- Configure Python testing adapter
      local neotest = require("neotest")

      -- Create Python adapter with proper settings
      local neotest_python = require("neotest-python")({
        -- Use pytest as the test runner
        runner = "pytest",

        -- Arguments passed to pytest
        args = {
          "--verbose",
          "--color=yes",
        },

        -- Configure debugger settings
        dap = {
          justMyCode = false,
          console = "integratedTerminal",
        },

        -- Discover parametrized tests
        pytest_discover_instances = true,
      })

      -- Register Python adapter with neotest
      neotest.setup({
        adapters = {
          neotest_python,
        },
      })

      -- Add Python-specific test commands
      vim.api.nvim_create_user_command("PytestDir", function(opts)
        local dir = opts.args ~= "" and opts.args or "tests"
        local path = vim.fn.getcwd() .. "/" .. dir
        neotest.run.run(path)
      end, { nargs = "?", complete = "dir" })

      vim.api.nvim_create_user_command("PytestFile", function(opts)
        local file = opts.args ~= "" and opts.args or vim.fn.expand("%")
        neotest.run.run(file)
      end, { nargs = "?", complete = "file" })

      -- Add key mapping for running test class/method under cursor
      vim.keymap.set("n", "<leader>tc", function()
        -- Get the current line
        local line = vim.fn.getline(".")

        -- Try to find a class or method definition
        local class_match = line:match("^class%s+([%w_]+)")
        local method_match = line:match("^%s*def%s+([%w_]+)")
        local test_name = class_match or method_match

        if test_name then
          -- Get current file path
          local file_path = vim.fn.expand("%:p")

          -- Construct the test identifier
          local test_id = file_path
          if class_match then
            test_id = test_id .. "::" .. class_match
            if method_match then
              test_id = test_id .. "::" .. method_match
            end
          elseif method_match then
            test_id = test_id .. "::" .. method_match
          end

          -- Run the specific test
          neotest.run.run(test_id)
        else
          -- Fall back to running the nearest test
          neotest.run.run()
        end
      end, { desc = "Run Test Class/Method Under Cursor" })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        require("dap-python").setup("python")
        table.insert(require("dap").configurations.python, {
          type = "python",
          request = "launch",
          name = "My custom launch configuration",
          program = "${file}",
          justMyCode = false,
        })
      end,
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    ft = { "python" },
    config = function()
      -- Get DAP Python adapter
      local dap_python = require("dap-python")

      -- Configure DAP Python to work with your virtual environment
      local python_path = vim.fn.exepath("python")
      dap_python.setup(python_path)

      -- Add Python testing configurations
      dap_python.test_runner = "pytest"

      -- Add a command to debug the current Python test file
      vim.api.nvim_create_user_command("PytestDebug", function(opts)
        local file = opts.args ~= "" and opts.args or vim.fn.expand("%")

        -- Run test with DAP
        require("neotest").run.run({
          file,
          strategy = "dap",
        })
      end, { nargs = "?", complete = "file" })
    end,
  },
  {
    "williamboman/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      -- Don't mess up DAP adapters provided by nvim-dap-python
      handlers = {
        python = function() end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },
}
