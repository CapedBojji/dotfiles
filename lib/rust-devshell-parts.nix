{ pkgs }:
{
  # Rust packages from the rust-dev shell
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

  # Environment setup from rust-dev shell
  setupEnv = ''
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

  # All the cargo scripts from rust-dev shell
  scripts = {
    build.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo build --all-targets
    '';

    build-release.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo build --release --all-targets
    '';

    check.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo check --all-targets --all-features
    '';

    test.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      if command -v cargo-nextest >/dev/null 2>&1; then
        cargo nextest run --all-features
      else
        cargo test --all-features --all-targets
      fi
    '';

    fmt.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo fmt --all -- --check
    '';

    fmt-fix.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo fmt --all
    '';

    clippy.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo clippy --all-targets --all-features -- -D warnings
    '';

    doc.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo doc --no-deps --all-features
    '';

    watch.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo watch -x "check --all-targets --all-features" -x "test --all-features --all-targets"
    '';

    clean.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      cargo clean
    '';

    # Common chat script
    chat.exec = "code chat -r @args";
  };
}