# flake-parts module: exports configs + your lib/overlays
{ self, inputs, ... }:
let
  my-lib = import ./lib { inherit inputs; };
  lib = inputs.nixpkgs.lib;
in
{
  flake = {
    # Hosts
    darwinConfigurations = import ./darwin.nix { 
      inherit self inputs my-lib lib; 
    };
    nixosConfigurations  = import ./nixos.nix  { inherit self inputs; };

    # Helpers exposed by your flake
    lib =  my-lib; 
    templates = import ./templates;
    overlays.default = import ./overlays { inherit inputs self; };
  };
}
