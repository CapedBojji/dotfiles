{ pkgs }:
let
  rustParts = import ./rust-devshell-parts.nix { inherit pkgs; };
in
{
  # Tauri-specific packages (includes rust packages + tauri extras)
  packages = rustParts.packages ++ (with pkgs; [
    # Node/JS tooling for frontend
    nodejs_22
    pnpm
    bun

    # Additional deps for Tauri
    jq
    libiconv
  ]) ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.apple_sdk.frameworks.Security
    pkgs.darwin.apple_sdk.frameworks.AppKit
    pkgs.darwin.apple_sdk.frameworks.Foundation
    pkgs.darwin.apple_sdk.frameworks.WebKit
    pkgs.darwin.apple_sdk.frameworks.CoreServices
  ]);

  # Environment setup (same as rust + tauri-specific)
  setupEnv = rustParts.setupEnv;

  # Tauri scripts (includes all rust scripts + tauri-specific ones)
  scripts = rustParts.scripts // {
    frontend-install.exec = ''
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

    tauri-dev.exec = ''
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

    tauri-build.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      tauri-dev build "$@"
    '';

    tauri-icon.exec = ''
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
  };
}