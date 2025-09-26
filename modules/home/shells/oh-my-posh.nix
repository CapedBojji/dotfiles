{ self, ... }:
let
  settings = builtins.fromTOML (builtins.readFile (self + "/.config/shells/oh-my-posh.toml"));
in
{
  programs.oh-my-posh = {
    enable = true;
    # useTheme = "catppuccin_mocha"; # List of themes: https://ohmyposh.dev/docs/themes
    enableZshIntegration = true;
    settings = settings;
  };
}
