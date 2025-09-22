{
  inputs,
  self,
  username,
  ...
}:
let
  email = "blackbojji@gmail.com";
  inherit (inputs) ragenix catppuccin;
in
{

  imports = [
    ragenix.homeManagerModules.default
    catppuccin.homeModules.catppuccin
    (self + "/modules/home/catppuccin.nix")
    (self + "/modules/home/vscode.nix")
    (self + "/modules/home/terminals/kitty.nix")
    (self + "/modules/home/shells/zsh.nix")
    (self + "/modules/home/shells/oh-my-posh.nix")
    (self + "/modules/home/shells/tmux.nix")
    (self + "/modules/home/apps/keepassxc.nix")
    (self + "/modules/home/nvim.nix")
    (self + "/modules/home/syncthing.nix")
    (self + "/modules/home/base.nix")
    (self + "/modules/home/age.nix")
  ];

  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  my.dotsRegistry = {
    enable = true;
    source = "path";
  };
}
