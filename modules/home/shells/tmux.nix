{ pkgs, lib, self, ... }:
let
  mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
  fzf-tmux = mkTmuxPlugin {
    pluginName = "tmux-fzf";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "sainnhe";
      repo = "tmux-fzf";
      rev = "e91c1ae55389f2b34480ea23df77682bdd51d735";
      sha256 = "sha256-JItut2Iiuw8EEFCz6u7R1eLMxCvvPpSrQLkMbY+XXE8=";
    };
    buildInputs = [ pkgs.fzf ];
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    historyLimit = 10000;
    escapeTime = 0;
    focusEvents = true;
    # sensibleOnTop = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a"; # Ctrl-a

    plugins = with pkgs.tmuxPlugins; [
      fzf-tmux
      vim-tmux-navigator
    ];


    extraConfig = ''
    #   # TODO: find a way to toggle this?
    #   set-option -g display-time 3000

    #   set -g detach-on-destroy off # don't exit from tmux when closing a session
    #   set -g set-clipboard on      # use system clipboard
    #   set -g status-interval 3     # update the status bar every 3 seconds

    #   set -g status-left "#[fg=blue,bold]#S #[fg=white,nobold]#(gitmux -cfg ${self + "/config/tmux/gitmux.yml"}) "
    #   set -g status-right-length 80
    #   set -g status-right ""

    #   set-option -g status 2
    #   set -g status-format[1] '#[fg=blue,nobold][#(tmux ls -F "##S##{?session_attached,*,}" | tr "\n" "|" | sed "s/ $/ /" )]'

    #   set -g status-left-length 300    # increase length (from 10)
    #   set -g status-position top       # macOS / darwin style
    #   set -g status-style 'bg=default' # transparent

    #   set -g window-status-current-format '*#[fg=magenta]#W'
    #   set -g window-status-format ' #[fg=gray]#W'

    #   set -g allow-passthrough on
    #   set -g message-command-style bg=default,fg=yellow
    #   set -g message-style bg=default,fg=yellow
    #   set -g mode-style bg=default,fg=yellow
    #   set -g pane-active-border-style 'fg=black,bg=default'
    #   set -g pane-border-style 'fg=brightblack,bg=default'

    #   bind '%' split-window -c '#{pane_current_path}' -h
    #   bind '"' split-window -c '#{pane_current_path}'
    #   bind c new-window -c '#{pane_current_path}'

    #   bind -N "⌘+l last-session (via sesh) " L run-shell "sesh last || tmux display-message -d 1000 'Only one session'"
    #   bind -N "⌘+9 switch to root session (via sesh) " 9 run-shell "sesh connect --root $(pwd)"

    #   bind -N "⌘+Q kill current session" Q kill-session
    #   bind -N "⌘+⇧+t break pane" B break-pane
    #   bind -N "⌘+^+t join pane" J join-pane -t 1
    #   bind h select-pane -L
    #   bind j select-pane -D
    #   bind k select-pane -U
    #   bind l select-pane -R

    #  bind-key -T copy-mode-vi 'C-h' select-pane -L
    #  bind-key -T copy-mode-vi 'C-j' select-pane -D
    #  bind-key -T copy-mode-vi 'C-k' select-pane -U
    #  bind-key -T copy-mode-vi 'C-l' select-pane -R
    #  bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
    #  bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt (cmd+w)
    #  bind-key e send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter

    #  # NOTE: can be used for debugging
    #  # )\" 2> /tmp/sesh-$(date +"%Y-%m-%d-%H-%M-%S").txt"

    #  bind-key "Z" display-popup -E "sesh connect \$(sesh list | zf --height 24)"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.sesh = {
    enable = true;
  };

  home.packages = with pkgs; [
    gitmux
  ];
}