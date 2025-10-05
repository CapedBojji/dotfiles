{ stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, openssl, zlib, lib, makeWrapper ? null }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "git-main";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    rev = "bb3956547affc1af7b7d196f96756895255dd05d";
    # pinned to specific commit
    sha256 = "0106wd28pffkfi7284dh04sck3ba38f5ivwylix2klaaf2ybrmky";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig ];
  buildInputs = [ openssl zlib ];

  cmakeFlags = [ "-DLUAU_BUILD_TESTS=OFF" "-DCMAKE_BUILD_TYPE=Release" ];

  buildPhase = ''
    mkdir -p build
    cmake -S . -B build -G Ninja ${toString cmakeFlags}
    cmake --build build --target luau -j ${toString stdenv.concurrentBuilds}
    cmake --build build --target luau-analyze -j ${toString stdenv.concurrentBuilds} || true
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 build/luau $out/bin/luau
    if [ -f build/luau-analyze ]; then
      install -m755 build/luau-analyze $out/bin/luau-analyze
    fi
  '';

  meta = with lib; {
    description = "Luau language runtime and tooling (built from upstream)";
    homepage = "https://github.com/luau-lang/luau";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
