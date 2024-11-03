{ pkgs }:
let
  flavour = "macchiato";
in
{
  add_newline = false;
  character = {
    success_symbol = "[](#cbced3)";
    error_symbol = "[](#dd6777) ";
    vicmd_symbol = "[](#ecd3a0)";
    # format = "$symbol[ ](bold #b4befe) ";
    # format = "$symbol[λ ](bold #b4befe) ";
    format = "$symbol[󰅂](#b4befe) ";
  };
  format = ''
    $directory$git_branch$git_state$git_commit
    $character
  '';
  palette = "catppuccin_${flavour}";
  right_format = ''
    $all
  '';
  command_timeout = 2000;
  scan_timeout = 100;
  git_branch = {
    format = "on [$symbol$branch(:$remote_branch)]($style) ";
    symbol = " ";
    style = "bold purple";
  };
  git_commit = {
    format = "[\($hash$tag\)]($style) ";
    commit_hash_length = 7;
    style = "bold green";
  };
  golang = {
    format = "via [$symbol($version )]($style)";
    style = "bold blue";
    symbol = "[ ]($style)";
  };
  lua = {
    format = "via [$symbol($version )]($style)";
    symbol = "[]($style) ";
    style = "bold blue";
  };
  nix_shell = {
    symbol = " ";
    format = "via [$symbol$state]($style) ";
    # symbol = "󱄅 ";
    # format = "via [$symbol$state( \($name\))]($style) ";
    style = "bold blue";
    disabled = false;
  };
  nodejs = {
    format = "via [$symbol($version )]($style)";
    style = "bold green";
    symbol = " ";
    version_format = "v$raw(blue)";
  };
  ocaml = {
    format = "via [$symbol($version )(\($switch_indicator$switch_name\) )]($style)";
    symbol = "🐫 ";
    style = "bold yellow";
    version_format = "v$raw";
  };
  package = {
    format = "is [$symbol$version]($style) ";
    symbol = " ";
    style = "bold 208";
  };
  python = {
    format = "via [$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
    symbol = "[]($style) ";
    style = "bold blue";
  };

  rust = {
    format = "via [$symbol($version )]($style)";
    symbol = "[]($style) ";
    style = "bold #f74b00";
  };
  zig = {
    format = "via [$symbol($version )]($style)";
    symbol = "[ ]($style)";
    style = "bold yellow";
  };
  username = {
    show_always = true;
    format = "[ $user]($style) ";
    style_user = "bold bg:none fg:#7aa2f7";
  };
  directory = {
    read_only = " 󰌾";
    truncation_length = 3;
    truncation_symbol = "./";
    style = "bold bg:none fg:#b4befe";
  };
  time = {
    use_12hr = false;
    time_range = "-";
    time_format = "%R";
    utc_time_offset = "local";
    format = "[ $time 󰥔]($style) ";
    style = "bold #393939";
  };
  c = {
    symbol = " ";
  };
  nim = {
    symbol = "󰆥 ";
  };
  julia.symbol = " ";
  php.symbol = " ";
  ruby.symbol = " ";
}
// builtins.fromTOML (
  builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "starship";
      rev = "HEAD";
      sha256 = "sha256-t/Hmd2dzBn0AbLUlbL8CBt19/we8spY5nMP0Z+VPMXA=";
    }
    + /themes/${flavour}.toml
  )
)
