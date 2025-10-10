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
      search.useIgnoreFiles = true;
      search.exclude = {
        "**/.direnv" = true;
        "**/results" = true;
      };
      chat.tools.terminal.autoApprove = {
        "git add" = true;
        "git commit" = true;
        "apply-flake" = true;
      };
    };
    extensions =
      # Open VSX channel
      (with exts.open-vsx; [
        fill-labs.dependi
        rust-lang.rust-analyzer
        tauri-apps.tauri-vscode
        jnoortheen.nix-ide
        vscodevim.vim
        littensy.charmed-icons
        tamasfe.even-better-toml
        johnnymorganz.luau-lsp
      ])
      ++ (with exts.vscode-marketplace-release; [
        github.copilot-chat
        github.copilot
      ])
      ++ (with exts.vscode-marketplace; [
          ms-python.python
          ms-python.debugpy
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
          # Add any extra extensions here
        ];
        # enableUpdateCheck = true;
        # enableExtensionUpdateCheck = false;
      };
    };
  };
}

       
       
         
         
           
           
         
         
         
           
           
           
         
         
         
           
           
           
         
         
         
           
           
           
         
         
         
           
           
           
         
       
       
       
     
   
 

