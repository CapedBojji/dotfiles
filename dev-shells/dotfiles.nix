{ system, self', inputs', pkgs, config, ... }:

{
  packages = with pkgs; [
    git
    nixfmt-rfc-style
    alejandra
    nixd
    # agenix-cli
    ragenix
  ];
  
  enterShell = ''
    echo "✨ Dotfiles devshell for ${system}"
    echo
    echo "Available scripts:"
    echo "  build-flake [host]   -> build darwin flake config (defaults to \$(hostname -s))"
    echo "  apply-flake [host]   -> build & apply darwin flake config (defaults to \$(hostname -s))"
    echo "  encrypt <file> <out> -> encrypt a plaintext file into an .age secret (uses secrets.nix policy)"
    echo
  '';

  scripts.build-flake.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail

    HOST="''${1:-$(hostname -s)}"
    echo "🔨 Building flake for host: $HOST"
    darwin-rebuild build --flake .#"$HOST"
  '';

  scripts.apply-flake.exec = ''
    #!/usr/bin/env bash
    set -euo pipefail
    build-flake "$@"

    # pick the newest result symlink (handles result, result-2, …)
      link="$(ls -dt result* 2>/dev/null | head -n1 || true)"
      if [ -z "$link" ] || [ ! -x "$link/activate" ]; then
        echo "No activation script found (expected ./result/activate)."
        echo "Ensure build-flake runs: nix build .#darwinConfigurations.\"''${1:-$(hostname -s)}\".system"
        exit 1
      fi

      echo "🔧 Activating from $link"
      sudo "$link/activate"
  '';

  scripts.encrypt.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if [ $# -lt 2 ]; then
        echo "Usage: devenv encrypt <plaintext-file> <dest-age-file>" >&2
        exit 1
      fi

      input="$1"
      output="$2"

      if [ ! -f "$input" ]; then
        echo "Error: plaintext file '$input' not found" >&2
        exit 1
      fi

      if [ ! -f secrets.nix ]; then
        echo "Error: secrets.nix not found in repo root (needed for recipients)" >&2
        exit 1
      fi

      echo "Encrypting $input -> $output"
      ${pkgs.ragenix}/bin/ragenix -e "$output" --editor - < "$input"

      echo "✅ Done. Encrypted file written to $output"
      echo "⚠️ Remember to shred or remove $input if you don’t want the plaintext lying around."
    '';
}
