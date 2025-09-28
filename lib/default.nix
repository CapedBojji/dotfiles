{ lib }:
{
  # Export EXACT name used later:
  parseZplugPlugins = import ./parse-zplug-plugins.nix { inherit lib; };

  # (optional alias)
  parsePlugins = import ./parse-zplug-plugins.nix { inherit lib; };

  # Rust devshell components
  rustDevShellParts = import ./rust-devshell-parts.nix;

  # Tauri devshell components
  tauriDevShellParts = import ./tauri-devshell-parts.nix;
}
