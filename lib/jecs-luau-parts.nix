{ pkgs }:
{
  packages = with pkgs; [
    luau
    luau-lsp
    luau-compile
  ];

  setupEnv = ''
    # Use per-project luau cache locations if needed
    export LUAU_HOME="$PWD/.luau"
  '';

  enterShell = system: ''
    echo "✨ JECS Luau devshell for ${system}"
    echo
    echo "Available scripts:"
    echo "  fmt       -> format/compile checks (using luau-compile)"
    echo "  analyze   -> run luau-analyze if available"
    echo "  run <src> -> run a Luau script"
    echo
  '';

  scripts = {
    fmt.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      if ! command -v luau-compile >/dev/null 2>&1; then
        echo "luau-compile not found in PATH" >&2
        exit 1
      fi
      luau-compile --check .
    '';

    analyze.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      if ! command -v luau-analyze >/dev/null 2>&1; then
        echo "luau-analyze not found" >&2
        exit 1
      fi
      luau-analyze .
    '';

    run.exec = ''
      #!/usr/bin/env bash
      set -euo pipefail
      if [ $# -lt 1 ]; then
        echo "Usage: devenv run <script.lua>" >&2
        exit 1
      fi
      luau "$1"
    '';
  };
}
