{pkgs, ...}: {
  home.packages = with pkgs; 
    [
      # Core utilities
      fzf
      fd
      lazygit
      ripgrep
      
      # Terminal image/media previewers
      viu           # Terminal image viewer
      chafa         # Terminal graphics
      ueberzugpp    # Terminal image previewer
      
      # Image, PDF and document processing tools
      imagemagick   # For 'magick' and 'convert' commands
      ghostscript   # For 'gs' PDF rendering
      mermaid-cli   # For 'mmdc' Mermaid diagrams
      sqlite        # For picker history and frecency tracking
      sqlitebrowser  # For SQLite DB management
      sqlite-interactive  # Command-line interface
      
      # LaTeX support
      tectonic      # Modern LaTeX engine
      # Or alternatively:
      # texlive.combined.scheme-medium  # Traditional LaTeX with pdflatex
      
      #-- c/c++
      cmake
      cmake-language-server
      gnumake
      checkmake
      # c/c++ compiler, required by nvim-treesitter!
      gcc
      # c/c++ tools with clang-tools, the unwrapped version won't
      # add alias like `cc` and `c++`, so that it won't conflict with gcc
      llvmPackages.clang-unwrapped
      lldb

      #-- python
      ruff       # Use new ruff instead of ruff-lsp
      pyright    # python language server
      basedpyright
      (python311.withPackages (
        ps:
          with ps; [
            debugpy
            black   # Python formatter
            isort   # Import sorter
            # Data science and ML packages
            numpy
            pandas
            matplotlib
            scikit-learn
            jupyter
            ipython
          ]
      ))

      #-- nix
      nil
      statix      # Lints and suggestions for the nix programming language
      deadnix     # Find and remove unused code in .nix source files
      alejandra   # Nix Code Formatter

      #-- lua
      stylua
      lua-language-server

      #-- bash
      nodePackages.bash-language-server
      shellcheck
      shfmt

      #-- javascript/typescript
      nodePackages.nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      # HTML/CSS/JSON/ESLint language servers extracted from vscode
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
      emmet-ls

      #-- CloudNative
      nodePackages.dockerfile-language-server-nodejs
      terraform-ls
      jsonnet
      jsonnet-language-server
      hadolint # Dockerfile linter

      #-- AI Coding Assistance
      curl # Required by avante.nvim
      gnutar # Required by avante.nvim
      cargo # Required by avante.nvim if building from source

      #-- Others
      taplo # TOML language server / formatter / validator
      nodePackages.yaml-language-server
      sqlfluff # SQL linter
      actionlint # GitHub Actions linter
      buf # protoc plugin for linting and formatting
      proselint # English prose linter

      #-- Misc
      tree-sitter # common language parser/highlighter
      nodePackages.prettier # common code formatter
      marksman # language server for markdown
      glow # markdown previewer
      pandoc # document converter
      hugo # static site generator

      #-- Optional Requirements:
      gdu # disk usage analyzer, required by AstroNvim
      (ripgrep.override {withPCRE2 = true;}) # recursively searches directories for a regex pattern
    ];
}
