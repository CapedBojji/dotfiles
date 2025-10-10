{
  pkgs,
  system,
  ...
}: {
  dotfiles = import ./dotfiles.nix {inherit pkgs system;};
}
