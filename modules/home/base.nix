{ lib, username, pkgs, ... }:
{
  imports = [
    ./dots-registry.nix
  ];

  programs.command-not-found.enable = true;

  home.packages = with pkgs; [
    discord
  ];
  
  xdg.enable = true;

  home = {
    stateVersion = lib.mkDefault "25.05"; 
    homeDirectory = "/Users/${username}";
    username = lib.mkDefault username;
  };

  my.dotsRegistry.enable = true;
}