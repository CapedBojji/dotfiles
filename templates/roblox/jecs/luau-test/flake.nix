{
  description = "JECS Luau test project template";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    dotfiles.url = "github:CapedBojji/dotfiles";
  };

  outputs = inputs@{ flake-parts, dotfiles, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
      let
        _pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ dotfiles.overlays.default ];
          config.allowUnfree = true;
        };

        luauParts = dotfiles.lib.jecsLuauParts { pkgs = _pkgs; };
      in {
        devenv.shells = {
          default = {
            name = "jecs-luau-test";
            packages = luauParts.packages;
            scripts = luauParts.scripts;
            enterShell = luauParts.enterShell system + luauParts.setupEnv;
          };
        };
      };

      flake = {};
    };
}
