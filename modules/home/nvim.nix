{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
    # inputs.nixcats.packages.${pkgs.system}.default
  ];

  home.activation.copyNvim = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    set -euo pipefail
    src="${self}/.config/nvim"
    dst="${config.xdg.configHome}/nvim"   # ~/.config by default

    mkdir -p "$dst"
    # -rltgoD ≈ archive without preserving original modes (we set our own)
    ${pkgs.rsync}/bin/rsync -rltgoD --delete \
      --chmod=Du=rwx,Dgo=rx,Fu=r,Fgo=r \
      "$src"/ "$dst"/

    echo "Copied $src -> $dst (dirs 755, files 444)"
  '';
}

