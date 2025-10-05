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
    dotfiles.url = "github:CapedBojji/dotfiles";
  };

  outputs = inputs@{ flake-parts, devenv-root, dotfiles, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
      let
        luauParts = dotfiles.lib.jecsLuauParts { inherit pkgs; };
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
