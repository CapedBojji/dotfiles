{ system, pkgs, ... }:

{
  # Use devenv's language integrations where possible
  languages.rust = {
    enable = true;
  };
  languages.deno = {
    enable = true;
  };

  # Extra packages beyond base language toolchains
  packages = with pkgs; [
    # Rust helpers and build deps
    cargo-watch
    cargo-edit
    cargo-nextest
    pkg-config
    openssl
    cmake
    llvmPackages.bintools-unwrapped
    lldb
    libiconv
    sccache

    # Node interoperability in case some Tauri tasks or tooling assume npm/pnpm
    nodejs_22
    pnpm
    bun

    # Utils
    git
    jq
  ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.apple_sdk.frameworks.Security
    pkgs.darwin.apple_sdk.frameworks.AppKit
    pkgs.darwin.apple_sdk.frameworks.Foundation
    pkgs.darwin.apple_sdk.frameworks.WebKit
    pkgs.darwin.apple_sdk.frameworks.CoreServices
  ]);

  enterShell = ''
    echo "✨ Tauri React (Deno) devshell for ${system}"
    echo
    echo "Available scripts:"
    echo "  build               -> cargo build (debug)"
    echo "  build-release       -> cargo build --release"
    echo "  check               -> cargo check (all targets)"
    echo "  test                -> run tests (uses nextest if available)"
    echo "  fmt                 -> check formatting"
    echo "  fmt-fix             -> apply formatting"
    echo "  clippy              -> clippy all targets/features, deny warnings"
    echo "  doc                 -> build docs (no-deps)"
    echo "  watch               -> cargo watch -x check -x test"
    echo "  clean               -> cargo clean"
    echo "  frontend-install    -> install frontend deps (pnpm|bun|npm if present; Deno uses cache/import maps)"
    echo "  tauri-dev           -> start Tauri dev (prefers tauri-cli via deno/npm runners)"
    echo "  tauri-build         -> build Tauri app"
    echo "  tauri-icon <img>    -> generate app icons from a square PNG/SVG"
    echo

    # Per-project cargo dirs
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

  # Common Rust scripts
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

  # Frontend helpers
  scripts.frontend-install.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    # Deno typically doesn't need install; but if project mixes npm/pnpm/bun, support it
    if command -v pnpm >/dev/null 2>&1 && [ -f package.json ]; then
      pnpm install
    elif command -v bun >/dev/null 2>&1 && [ -f package.json ]; then
      bun install
    elif command -v npm >/dev/null 2>&1 && [ -f package.json ]; then
      npm install
    else
      echo "No package.json found or no npm-compatible tool; Deno projects may not need this."
    fi
  '';

  # Tauri helpers (prefer Node runners for @tauri-apps/cli; fallback to Deno if present)
  scripts.tauri-dev.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    run_with_cli() {
      subcmd="$1"; shift || true
      if command -v pnpm >/dev/null 2>&1; then
        if [ -f package.json ] && jq -e '.scripts["tauri:dev"]' package.json >/dev/null 2>&1 && [ "$subcmd" = dev ]; then
          exec pnpm run tauri:dev
        elif [ -f package.json ] && jq -e '.scripts["tauri:build"]' package.json >/dev/null 2>&1 && [ "$subcmd" = build ]; then
          exec pnpm run tauri:build
        else
          exec pnpm dlx @tauri-apps/cli@latest "$subcmd" "$@"
        fi
      elif command -v bun >/dev/null 2>&1; then
        exec bunx --bun @tauri-apps/cli@latest "$subcmd" "$@"
      elif command -v npx >/dev/null 2>&1; then
        exec npx -y @tauri-apps/cli@latest "$subcmd" "$@"
      elif command -v deno >/dev/null 2>&1; then
        # Use Deno to run npm:@tauri-apps/cli if project is configured for it
        exec deno run -A npm:@tauri-apps/cli "$subcmd" "$@"
      else
        echo "No runner found for @tauri-apps/cli (need pnpm/bun/npx/deno)" >&2
        exit 1
      fi
    }
    subcmd="''${1:-dev}"; shift || true
    run_with_cli "$subcmd" "$@"
  '';

  scripts.tauri-build.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    tauri-dev build "$@"
  '';

  scripts.tauri-icon.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    if [ $# -lt 1 ]; then
      echo "Usage: tauri-icon <icon.(png|svg)>" >&2
      exit 1
    fi
    ICON="$1"
    if [ ! -f "$ICON" ]; then
      echo "Icon file not found: $ICON" >&2
      exit 1
    fi
    if command -v pnpm >/dev/null 2>&1; then
      pnpm dlx @tauri-apps/cli@latest icon "$ICON"
    elif command -v bun >/dev/null 2>&1; then
      bunx --bun @tauri-apps/cli@latest icon "$ICON"
    elif command -v npx >/dev/null 2>&1; then
      npx -y @tauri-apps/cli@latest icon "$ICON"
    elif command -v deno >/dev/null 2>&1; then
      deno run -A npm:@tauri-apps/cli icon "$ICON"
    else
      echo "No runner found for @tauri-apps/cli (need pnpm/bun/npx/deno)" >&2
      exit 1
    fi
  '';
}
