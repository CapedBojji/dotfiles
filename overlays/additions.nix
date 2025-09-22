# parts/overlays/additions.nix
{ inputs }:
final: prev:
{
  # expose a stable nixpkgs under pkgs.stable
  stable = import inputs.nixpkgs-stable {
    system = final.system;
    config = { allowUnfree = true; };
    # overlays = [ ... ]  # usually leave empty to avoid recursion
  };
}

