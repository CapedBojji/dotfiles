{
  description = "Dotfiles: nix-darwin + (optional) NixOS + Home Manager";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    nixcats = {
      url = "github:CapedBojji/nixcats";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";
    ragenix.url = "github:yaxitech/ragenix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs@{
      self,
      devenv,
      flake-parts,
      darwin,
      devenv-root,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];

      imports = [ devenv.flakeModule ];

      flake = {
        darwinConfigurations = {
          work-aarch4 =
            let
              system = "aarch64-darwin";
              username = "blackbojji";
              my-lib = import ./lib { inherit (inputs.nixpkgs) lib; };
            in
            darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit
                  self
                  inputs
                  username
                  my-lib
                  ;
              };
              modules = [
                ./profiles/darwin/work-aarch4.nix
              ];
            };
        };

        overlays = {
          default = import ./overlays { inherit inputs self; };
        };

        lib = import ./lib { inherit (inputs.nixpkgs) lib; };

        templates = import ./templates { inherit self inputs; };
      };

      perSystem =
        {
          system,
          self',
          inputs',
          pkgs,
          config,
          lib,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };

          devenv.shells = {
            dotfiles = import ./dev-shells/dotfiles.nix {
              inherit
                system
                pkgs
                ;
            };
            rust-dev = import ./dev-shells/rust-dev.nix {
              inherit system pkgs;
            };
            tauri-react-deno = import ./dev-shells/tauri/react/deno.nix {
              inherit system pkgs;
            };
          };
        };
    };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };
}
