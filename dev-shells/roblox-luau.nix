{ system, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Provide Luau and LSP for Roblox development
  packages = with pkgs; [
    luau
    luau-lsp
  ];

  enterShell = ''
    echo "✨ Roblox / Luau devshell for ${system}"
    echo
    echo "Provides: luau, luau-lsp"
    echo
  '';

  # no extra scripts for now; we can add format/lint helpers later
}
