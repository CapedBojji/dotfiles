{ system, pkgs, ... }:

{
  imports = [ ./common.nix ];
  packages = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

    # Cargo helpers
    cargo-watch
    cargo-edit
    cargo-nextest

    # Build deps commonly needed by crates
    pkg-config
    openssl
    cmake
    llvmPackages.bintools-unwrapped
    lldb

    # Optional build/cache tools
    sccache

    # Utils
    git
  ];

  enterShell = ''
    echo "✨ Rust devshell for ${system}"
    echo
    echo "Available scripts:"
    echo "  build            -> cargo build (debug)"
    echo "  build-release    -> cargo build --release"
    echo "  check            -> cargo check (all targets)"
    echo "  test             -> run tests (uses nextest if available)"
    echo "  fmt              -> check formatting"
    echo "  fmt-fix          -> apply formatting"
    echo "  clippy           -> clippy all targets/features, deny warnings"
    echo "  doc              -> build docs (no-deps)"
    echo "  watch            -> cargo watch -x check -x test"
    echo "  clean            -> cargo clean"
  echo "  chat [args]      -> open VS Code Chat and pass args (devenv scripts.chat)"
    echo

    # Per-project cargo dirs (keeps global home clean)
    export CARGO_HOME="$PWD/.cargo"
    export RUSTUP_HOME="$PWD/.rustup"

    # Speed up builds with sccache if present
    if command -v sccache >/dev/null 2>&1; then
      export RUSTC_WRAPPER="$(command -v sccache)"
      export SCCACHE_DIR="$PWD/.sccache"
    fi

    # Help crates like openssl-sys find headers/libs
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
    export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
    export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  scripts.build.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo build --all-targets
  '';

  scripts.build-release.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo build --release --all-targets
  '';

  scripts.check.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo check --all-targets --all-features
  '';

  scripts.test.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v cargo-nextest >/dev/null 2>&1; then
      cargo nextest run --all-features
    else
      cargo test --all-features --all-targets
    fi
  '';

  scripts.fmt.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo fmt --all -- --check
  '';

  scripts.fmt-fix.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo fmt --all
  '';

  scripts.clippy.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo clippy --all-targets --all-features -- -D warnings
  '';

  scripts.doc.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo doc --no-deps --all-features
  '';

  scripts.watch.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo watch -x "check --all-targets --all-features" -x "test --all-features --all-targets"
  '';

  scripts.clean.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    cargo clean
  '';
}