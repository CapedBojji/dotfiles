# Override or tweak existing packages here
final: prev: let
in {
  luau = prev.callPackage ../pkgs/luau/default.nix {
    inherit (prev) stdenv fetchFromGitHub cmake ninja pkg-conf openssl zlib lib;
  };
}
