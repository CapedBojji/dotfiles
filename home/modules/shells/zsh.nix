# home/modules/shell/zsh.nix
{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;                 # HM option
    defaultKeymap = "viins";                 # HM option

    autocd = true;

    # Modern nested options
    autosuggestion.enable = true;            # HM option (singular)
    syntaxHighlighting.enable = true;        # HM option
    historySubstringSearch.enable = true;    # HM submodule

    # History: safe, widely-available fields
    history = {
      path        = "${config.xdg.dataHome}/zsh/history";
      size        = 50000;
      save        = 50000;
      share       = true;
      extended    = true;
      ignoreDups  = true;
      ignoreSpace = true;
      # If your HM version has it, you can uncomment:
      # ignoreAllDups = true;
      # saveNoDups    = true;
    };

    # Put session vars in ~/.zshenv via HM
    sessionVariables = {
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_CACHE_HOME  = "${config.home.homeDirectory}/.cache";
      XDG_DATA_HOME   = "${config.home.homeDirectory}/.local/share";
    };

    # Handy aliases (layer more per-profile/host)
    shellAliases = {
      ls = "eza --icons=auto";
      ll = "eza -lah --icons=auto";
      gs = "git status -sb";
      v  = "nvim";
    };
  };

  programs.zsh.initContent = lib.mkMerge [
    (lib.mkBefore ''
      zmodload zsh/complist
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    '')
    (lib.mkAfter ''
      bindkey -v
      bindkey '^P' up-history
      bindkey '^N' down-history
      stty -ixon

      # Respect EDITOR if set elsewhere; default to nvim
      export EDITOR="''${EDITOR:-nvim}"
    '')
  ];

  programs.zsh.profileExtra = lib.mkMerge [
    (lib.mkAfter ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '')
  ];

  home.packages = with pkgs; [
    eza
    fzf
    zoxide
    direnv
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
