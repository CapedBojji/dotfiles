{
  description = "Description for the project";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    # Reference your dotfiles repo for dev shells
    dotfiles.url = "github:CapedBojji/dotfiles";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, devenv-root, dotfiles, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: 
      let
        tauriParts = dotfiles.lib.tauriDevShellParts { inherit pkgs; };
      in {
        devenv.shells = {
          default = {
            name = "tauri-project";

            # Enable language support
            languages.rust.enable = true;
            languages.deno.enable = true;

            # Use tauri packages from dotfiles (includes rust + tauri extras)
            packages = tauriParts.packages;

            # Use tauri scripts from dotfiles (includes rust + tauri scripts)
            scripts = tauriParts.scripts;

            # Use common enterShell with environment setup
            enterShell = tauriParts.enterShell system + tauriParts.setupEnv;
          };
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
