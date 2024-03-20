# taken from https://github.com/shahinism/devenv-templates/blob/main/python/flake.nix

{
  # TODO update me
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          python-packages = p:
            with p; [
              pip
              debugpy
            ];
        in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        devenv.shells.default = {
          # TODO update me
          name = "Name of the project";

          imports = [
            # This is just like the imports in devenv.nix.
            # See https://devenv.sh/guides/using-with-flake-parts/#import-a-devenv-module
            # ./devenv-foo.nix
          ];

          # https://devenv.sh/reference/options/
          packages = with pkgs;
            [
              nodePackages.pyright
              ruff
              ruff-lsp

              just # makefile alternative
              stdenv.cc.cc.lib # required by Jupyter
              (python3.withPackages python-packages)
            ];

          # https://devenv.sh/basics/
          env = {
            GREET = "🛠️ Let's hack 🧑🏻‍💻";
          };

          # https://devenv.sh/scripts/
          scripts.hello.exec = "echo $GREET";

          enterShell = ''
            hello
          '';

          # https://devenv.sh/languages/
          languages.python = {
            enable = true;
            version = "3.12";
            poetry = {
              enable = true;
              activate.enable = true;
              install.enable = true;
              install.allExtras = true;
            };
          };

          # Make diffs fantastic
          difftastic.enable = true;

          # https://devenv.sh/pre-commit-hooks/
          pre-commit.hooks = {
            nixfmt.enable = true;
            yamllint.enable = true;
            pyright.enable = true;
            editorconfig-checker.enable = true;
            ruff.enable = true;
          };

          # Plugin configuration
          pre-commit.settings = {
            yamllint.relaxed = true;
          };

          # https://devenv.sh/integrations/dotenv/
          dotenv.enable = true;

        };

      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}