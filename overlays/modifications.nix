# Override or tweak existing packages here
final: prev: {
  luau = prev.callPackage ../pkgs/luau/default.nix {
    inherit (prev) stdenv fetchFromGitHub cmake ninja pkg-config openssl zlib lib;
  };
}
