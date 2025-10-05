{
  self,
  inputs,
  username,
  pkgs,
  lib,
  my-lib,
  ...
}:
let
  inherit (inputs) home-manager stylix ragenix;
in
{
  imports = [
    home-manager.darwinModules.home-manager
    ragenix.darwinModules.default
    stylix.darwinModules.stylix
    (self + "/modules/system/nix/darwin.nix")
    # (self + "/modules/system/syncthing.nix")
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit
        self
        inputs
        username
        my-lib
        ;
    };

    users."${username}" = import ../home/${username}.nix {
      inherit self inputs username;
    };
  };

  users.users."${username}" = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  networking.hostName = "work-aarch4";

  environment.systemPackages = with pkgs; [
    git
    # vim
    zsh
    nil
    alejandra
    neovim
    luau
    ragenix
    pokemon-colorscripts
  ];

  # stylix = {
  #   enable = true;
  #   autoEnable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  # };

  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    stateVersion = lib.mkDefault 6;
    primaryUser = username;
    defaults = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ];

  security = {
    pam = {
      services = {
        sudo_local = {
          touchIdAuth = true;
        };
      };
    };
  };

  homebrew = {
    enable = true;
    casks = [
      "roblox"
      "robloxstudio"
      "anki"
    ];
  };
}
