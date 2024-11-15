# CylisOS

**This is my own personal NixOS Flake, others are free to use it and build upon it.**

## Requirements:

Ensure git and vim are installed

```bash
nix-shell -p git vim
```

## How to Install

1. Get the git repo:

```bash
cd
git clone https://github.com/Cylis-Dragneel/dotfiles.git -b NixOS cylisos
```

2. Go into the directory and in the `flake.nix` change the username to whatever you want and the host variable to a predefined host(based/dragneel) or your own:

```bash
cd cylisos
vim flake.nix # change host and username on line 55 & 56 respectively
```

3. If you chose to make your own host do the following:

```bash
cd hosts
cp -r default ${your_chosen_hostname}
```

4. Generate your hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > ./hosts/${your_chosen_hostname}/hardware.nix
```

5. Finally build your configuration:

```bash
NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake ~/cylisos/#${your_chosen_hostname} --use-remote-sudo
```

## Tips & Aliases

**Some basic Aliases are setup to make navigation easier**:
`fr` - to rebuild your flake
`fu` - to update your flake
`host` - to edit your host specific configuration
`config` - to edit config files of apps
