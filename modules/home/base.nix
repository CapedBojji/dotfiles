{ lib, username, ... }:
{
  imports = [
    ./dots-registry.nix
  ];

  programs.command-not-found.enable = true;
  
  xdg.enable = true;

  home = {
    stateVersion = lib.mkDefault "25.05"; 
    homeDirectory = "/Users/${username}";
    username = lib.mkDefault username;
  };
}