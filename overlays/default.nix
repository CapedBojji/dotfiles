# parts/overlays/default.nix
{ inputs, self ? null }:
let
  additions     = import ./additions.nix     { inherit inputs; };
  modifications = import ./modifications.nix;
in
# return a single overlay function
final: prev:
  (additions     final prev)
  // (modifications final prev)
