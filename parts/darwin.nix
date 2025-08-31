# Define nix-darwin hosts; integrate Home Manager
{ self, inputs, lib, my-lib, ...}:
let
  inherit (inputs) darwin home-manager stylix;
in
{
  # Replace "work-aarch4" and "your-username" to match your machine/user
  work-aarch4 = let 
    username = "blackbojji";
    specialArgs = { inherit self inputs username my-lib;
      email = "blackbojji@gmail.com";
      system = "aarch64-darwin";
    };
  in
  darwin.lib.darwinSystem {
    specialArgs = { inherit self inputs username; };

    modules = [
      # Platform for this host
      { nixpkgs.hostPlatform = "aarch64-darwin"; }

      # Set stateVersion to the latest version of nix-darwin you have
      { system.stateVersion = lib.mkDefault 6; }

      # (Optional) Make your overlay available system-wide
      { 
        nixpkgs.overlays = [ 
          self.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ]; 
      }

      # Enable Stylix (theme manager)
      stylix.darwinModules.stylix

      # Home Manager as a nix-darwin module
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;

        # Use your actual macOS username here (quoted is fine)
        home-manager.users."${username}" = {
          home.username = username;
          home.homeDirectory = "/Users/${username}";

          imports = [
            (self + "/home/common")
            (self + "/home/profiles/base.nix")

            # add HM modules you want everywhere
            (self + "/home/modules/shells/zsh.nix")
            (self + "/home/modules/editors/nvim.nix")
            (self + "/home/modules/editors/vscode.nix")
          ];
        };
      }

      # Per-host overrides live here (file or dir with default.nix)
      (self + "/hosts/darwin/work-aarch4.nix")

      (self + "/parts/modules/system/nix/darwin.nix")
    ];
  };
}
