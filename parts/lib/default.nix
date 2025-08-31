{ inputs, ... }:
# Collect all your lib helpers here
{
  # deepMerge expects nixpkgs lib; returns base -> extra -> merged
  deepMerge = lib: import ./deepMerge.nix { inherit inputs; };

  # Add more helpers like:
  # uniqAppend = lib: xs: lib.unique xs;
}
