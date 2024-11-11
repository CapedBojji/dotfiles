{ pkgs }:
pkgs.writeShellScriptBin "clip" # bash
  ''
    ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi-wayland}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
  ''
