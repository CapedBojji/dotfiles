{ pkgs, lib, ... }:
let
  vscode-pkg = pkgs.vscode;
  version = lib.getVersion vscode-pkg;
  exts = (pkgs.nix-vscode-extensions).forVSCodeVersion version;

  base = {
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings"."nil"."formatting"."command" = [ "${pkgs.alejandra}/bin/alejandra" ];
      "vim.useSystemClipboard" = true;
      "editor.minimap.enabled" = false;
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "terminal.integrated.fontLigatures.enabled" = true;
      "editor.fontLigatures" = true;
      "explorer.confirmDelete" = false;
    };
    extensions =
      # Open VSX channel
      (with exts.open-vsx; [
        jnoortheen.nix-ide
        vscodevim.vim
        littensy.charmed-icons
      ])
      ++ (with exts.vscode-marketplace-release; [
        github.copilot-chat
        github.copilot
      ]);
  };

in
{

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        userSettings = base.userSettings;
        extensions = base.extensions ++ [

        ];
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = false;
      };
    };
  };
}
