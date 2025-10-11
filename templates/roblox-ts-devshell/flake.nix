{
  description = "JECS Luau project template";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {
    flake-parts,
    devenv-root,
    ...
  }: let
    game-name = "Game";
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [inputs.devenv.flakeModule];
      systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devenv.shells = {
          default = let
            unstable = with inputs'.nixpkgs-unstable.legacyPackages; [
              nodejs_24
              lune
              pnpm_9
              rojo
            ];

            packages = with pkgs; [nodejs_24 lune pnpm_9];
            scripts = {};
            enterShell = ''
              echo "Welcome to the JECS Luau Roblox-TS project shell!"
              echo "Project: $GAME_NAME"
              echo "Node version: $(node --version)"
              echo "PNPM version: $(pnpm --version)"
              echo "Lune version: $(lune --version)"
            '';
          in {
            env = {
              GAME_NAME = game-name;
            };
            name = "jecs-luau";
            packages = packages ++ unstable;
            inherit scripts;
            inherit enterShell;
          };
        };
      };

      flake = {};
    };
}
