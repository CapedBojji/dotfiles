# Override or tweak existing packages here
final: prev: let
  pkgsSrc = prev; # we will add packages to the overlay
in {
  luau = prev.callPackage ../pkgs/luau/default.nix {
    inherit (prev) stdenv fetchFromGitHub cmake ninja pkgconf openssl zlib lib;
    pkgconfig = prev."pkg-config";
  };
}
