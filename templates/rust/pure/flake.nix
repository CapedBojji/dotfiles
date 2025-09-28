{
  description = "Rust project template (pure Rust)";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
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
        rustParts = dotfiles.lib.rustDevShellParts { inherit pkgs; };
      in {
        devenv.root = devenv-root;
        devenv.shells = {
          default = {
            name = "rust-project";

            # Use rust packages from dotfiles
            packages = rustParts.packages;

            # Use rust scripts from dotfiles
            scripts = rustParts.scripts;

            enterShell = ''
              echo "✨ Rust devshell for ${system}"
              echo
              echo "Available scripts:"
              echo "  build            -> cargo build (debug)"
              echo "  build-release    -> cargo build --release"
              echo "  check            -> cargo check (all targets)"
              echo "  test             -> run tests (uses nextest if available)"
              echo "  fmt              -> check formatting"
              echo "  fmt-fix          -> apply formatting"
              echo "  clippy           -> clippy all targets/features, deny warnings"
              echo "  doc              -> build docs (no-deps)"
              echo "  watch            -> cargo watch -x check -x test"
              echo "  clean            -> cargo clean"
              echo "  chat [args]      -> open VS Code Chat and pass args"
              echo

              ${rustParts.setupEnv}
            '';
          };
        };
      };

      flake = {};
    };
}
