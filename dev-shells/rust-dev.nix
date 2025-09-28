{ system, pkgs, ... }:
let
  rustParts = import ../lib/rust-devshell-parts.nix { inherit pkgs; };
in
{
  imports = [ ./common.nix ];
  
  # Use rust packages from lib
  packages = rustParts.packages;

  # Use common enterShell with environment setup
  enterShell = rustParts.enterShell system + rustParts.setupEnv;

  # Use rust scripts from lib
  scripts = rustParts.scripts;
}