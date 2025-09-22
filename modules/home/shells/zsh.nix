# home/modules/shell/zsh.nix
{ self, config, lib, pkgs, my-lib, ... }:
let
  plugins = my-lib.parseZplugPlugins [
    "plugins/command-not-found; from:oh-my-zsh"
    "plugins/aliases; from:oh-my-zsh"
    "plugins/git; from:oh-my-zsh"
    "plugins/sudo; from:oh-my-zsh"
    "plugins/colorize; from:oh-my-zsh"
    "plugins/ssh; from:oh-my-zsh"
    "plugins/ssh-agent; from:oh-my-zsh"
  ];
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;                 # HM option
    defaultKeymap = "emacs";                 # HM option

    autocd = true;

    # Modern nested options
    autosuggestion.enable = true;            # HM option (singular)
    syntaxHighlighting.enable = true;        # HM option
    historySubstringSearch = {
      enable = true;
      searchUpKey = "^P";
      searchDownKey = "^N";
    };
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
      ignoreAllDups = true;
      saveNoDups    = true;
    };

    zplug = {
      enable = true;
      inherit plugins;
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

  programs.zsh.initContent = ''
    bindkey '^@' autosuggest-accept
    function sesh-sessions() {
      {
        exec </dev/tty
        exec <&1
        local session
        session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
        [[ -z "$session" ]] && return
        sesh connect $session
      }
    }

    zle     -N             sesh-sessions
    bindkey -M emacs '\es' sesh-sessions
    bindkey -M vicmd '\es' sesh-sessions
    bindkey -M viins '\es' sesh-sessions

  '';

  programs.zsh.profileExtra = lib.mkMerge [
    (lib.mkAfter ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '')
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd"];
  };

  programs.command-not-found = {
    enable = true;
  };

  home.packages = with pkgs; [
    zoxide
    eza
    fd
  ];
}
