{
  description = "JECS Luau project template";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    # Use the local dotfiles repo so the template reflects the working tree
    dotfiles = {
      url = "path:../../../../"; # relative path from template to repo root
      flake = true;
    };
  };

  outputs = inputs@{ flake-parts, devenv-root, dotfiles, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
      let
        # Make sure this template's pkgs uses the overlays exported by the
        # dotfiles flake so the custom `luau` package is visible.
        _pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ dotfiles.overlays.default ];
          config.allowUnfree = true;
        };

        luauParts = dotfiles.lib.jecsLuauParts { inherit pkgs _pkgs; };
      in {
        devenv.shells = {
          default = {
            name = "jecs-luau";
            packages = luauParts.packages;
            scripts = luauParts.scripts;
            enterShell = luauParts.enterShell system + luauParts.setupEnv;
          };
        };
      };

      flake = {};
    };
}
