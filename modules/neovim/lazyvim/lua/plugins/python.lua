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
      local lsp = vim.g.lazyvim_python_lsp or "pyright"
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

      -- Configure Ruff LSP to defer to Pyright for certain capabilities
      opts.setup[ruff] = function()
        require("lazyvim.util").lsp.on_attach(function(client, _)
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
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
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
