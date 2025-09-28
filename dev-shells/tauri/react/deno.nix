{ system, pkgs, ... }:
let
  tauriParts = import ../../../lib/tauri-devshell-parts.nix { inherit pkgs; };
in
{
  imports = [ ../../common.nix ];
  
  # Use devenv's language integrations where possible
  languages.rust = {
    enable = true;
  };
  languages.deno = {
    enable = true;
  };

  # Use tauri packages from lib (includes rust + tauri extras)
  packages = tauriParts.packages;

  # Use common enterShell with environment setup
  enterShell = tauriParts.enterShell system + tauriParts.setupEnv;

  # Use tauri scripts from lib (includes rust + tauri scripts)
  scripts = tauriParts.scripts;
}
