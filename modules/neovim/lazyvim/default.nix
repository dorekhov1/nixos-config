{ inputs, config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # withPython3 = true;
    extraPackages = with pkgs; [
      # Required C libraries
      stdenv.cc.cc.lib
      gcc13Stdenv.cc.cc.lib
      zlib

      # LazyVim
      lua-language-server
      stylua

      # Telescope
      ripgrep

      # nix
      nil
      # rnix-lsp # TODO

      # nixd
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix source files
      alejandra # Nix Code Formatter

    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraPython3Packages = ps: with ps; [
      pynvim  # This is the package that provides the 'neovim' Python module
    ];

    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
            # LazyVim
            LazyVim
            bufferline-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp_luasnip
            conform-nvim
            dashboard-nvim
            dressing-nvim
            flash-nvim
            friendly-snippets
            gitsigns-nvim
            indent-blankline-nvim
            neo-tree-nvim
            neoconf-nvim
            neodev-nvim
            noice-nvim
            snacks-nvim
            nui-nvim
            nvim-cmp
            nvim-lint
            nvim-lspconfig
            nvim-notify
            nvim-spectre
            nvim-ts-autotag
            nvim-ts-context-commentstring
            nvim-web-devicons
            persistence-nvim
            plenary-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            todo-comments-nvim
            tokyonight-nvim
            trouble-nvim
            vim-illuminate
            vim-startuptime
            which-key-nvim
            { name = "LuaSnip"; path = luasnip; }
            { name = "catppuccin"; path = catppuccin-nvim; }

            nvim-dap
            nvim-dap-ui
            nvim-nio
            nvim-dap-python
            nvim-dap-virtual-text
            yanky-nvim
            sqlite-lua # dependency for yanky-nvim
            edgy-nvim
            tmux-nvim
            vim-just
            harpoon
            windsurf-nvim
            remote-nvim-nvim

            obsidian-nvim
        ];
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          rocks = {
            enabled = false,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "." },
            -- fallback to download
            fallback = true,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- explicitly use the new mini.icons repo to avoid rename warnings
            { "nvim-mini/mini.icons" },

            -- { import = "lazyvim.plugins.extras.ui.alpha" },
            -- { import = "lazyvim.plugins.extras.ui.edgy" },

            -- disable mason.nvim, use programs.neovim.extraPackages
            { "mason-org/mason-lspconfig.nvim", enabled = false },
            { "mason-org/mason.nvim", enabled = false },

            -- import/override with your plugins
            { import = "plugins" },
            -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
            { "nvim-treesitter/nvim-treesitter", opts = function(_, opts) opts.ensure_installed = {} end },
          },
        })
      '';

  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
          bash
          c
          csv
          jsonc
          lua
          markdown
          markdown_inline
          nix
          regex
          python
          vimdoc
          query
          vim
          
          html
          css
          javascript
          typescript
          tsx
          latex
          scss
          svelte
          vue
          
          yaml
          toml
          json
          sql
          dockerfile
          diff
          git_rebase
          gitattributes
          gitcommit
          gitignore
          # norg
          typst
        ])).dependencies;
      };
    in
    "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
