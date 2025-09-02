{ lib, username, email, ... }:
{
    imports = [ ../options/nix/dots-registry.nix ];

    my.dotsRegistry = {
        enable = true;
        source = "path";
    };

    home = {
        stateVersion = lib.mkDefault "25.05";
    };

    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.git = {
        enable = true;
        userName = username;
        userEmail = email;
    };
}