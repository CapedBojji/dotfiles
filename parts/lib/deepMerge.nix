# parts/lib/deepMerge.nix
# Usage:
#   let deepMerge = (self.lib.deepMerge lib);
#   in deepMerge base extra
{ inputs }:
base: extra:
let
  lib = inputs.nixpkgs.lib;
  mergeValues = a: b:
    if lib.isAttrs a && lib.isAttrs b then
      lib.recursiveUpdateWith (x: y: mergeValues x y) a b
    else if lib.isList a && lib.isList b then
      lib.unique (a ++ b)
    else
      b;
in
mergeValues base extra

