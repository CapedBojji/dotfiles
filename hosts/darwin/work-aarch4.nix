{ pkgs, ... }:
let
    username = "blackbojji";
in
{
    environment.systemPackages = with pkgs; [
        git
        zsh
        nil
        alejandra
    ];

    stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };
    
    networking.hostName = "work-aarch4";

    users.users."${username}" = {
        description = "blackbojji";
        shell = pkgs.zsh;
        home = "/Users/${username}";
    };   

    system = {
        primaryUser = username;
        defaults = {
            NSGlobalDomain = {
                ApplePressAndHoldEnabled = false;
            };
        };
    };

    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
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
        brews = [
            {
                name = "neovim";
            }
        ];
    };
}