return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- Make sure the definition keymap is properly set
    for i, key in ipairs(keys) do
      if key[1] == "gd" then
        keys[i] = {
          "gd",
          function()
            require("telescope.builtin").lsp_definitions({ reuse_win = true })
          end,
          desc = "Goto Definition",
          has = "definition",
        }
      end
      if key[1] == "gr" then
        keys[i] = {
          "gr",
          function()
            require("telescope.builtin").lsp_references()
          end,
          desc = "References",
        }
      end
    end

    -- Ensure the keys for implementation and type definition are set
    local has_key = function(keys, keystroke)
      for _, key in ipairs(keys) do
        if key[1] == keystroke then
          return true
        end
      end
      return false
    end

    if not has_key(keys, "gI") then
      keys[#keys + 1] = {
        "gI",
        function()
          require("telescope.builtin").lsp_implementations({ reuse_win = true })
        end,
        desc = "Goto Implementation",
      }
    end

    if not has_key(keys, "gy") then
      keys[#keys + 1] = {
        "gy",
        function()
          require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
        end,
        desc = "Goto Type Definition",
      }
    end
  end,
}
