{ pkgs }:
{
  packages = with pkgs; [
    luau
  ];

  setupEnv = ''
    # Use per-project luau cache locations if needed
    export LUAU_HOME="$PWD/.luau"
  '';

  enterShell = system: ''
    echo "✨ JECS Luau devshell for ${system}"
    echo
    echo "Available scripts:"
    echo "  run <src> -> run a Luau script"
    echo
  '';

  scripts = {
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
