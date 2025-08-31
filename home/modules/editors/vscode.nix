{ self, pkgs, my-lib, ... }:
let
  base = {
    userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings"."nil"."formatting"."command" = ["${pkgs.alejandra}/bin/alejandra"];
        "vim.useSystemClipboard" = true;
        "editor.minimap.enabled" = false;
        editor.fontFamily = "JetBrainsMono Nerd Font";
        "terminal.integrated.fontLigatures.enabled" = true;
        "editor.fontLigatures" = true;
    };
    extensions = with pkgs.open-vsx; [
        jnoortheen.nix-ide
        vscodevim.vim
    ] ++ (with pkgs.vscode-marketplace; [
        github.copilot
        github.copilot-chat
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