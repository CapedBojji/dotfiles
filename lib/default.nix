{ lib }:
{
  # Export EXACT name used later:
  parseZplugPlugins = import ./parse-zplug-plugins.nix { inherit lib; };

  # (optional alias)
  parsePlugins = import ./parse-zplug-plugins.nix { inherit lib; };
}
