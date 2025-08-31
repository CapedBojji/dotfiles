# dotfiles for Macbook Air M4

This repository contains my personal dotfiles and configurations for my Macbook Air M4, utilizing Nix and Home Manager for package management and system configuration.

## Project Structure

- **flake.nix**: Defines the Nix flake, specifying inputs, outputs, and configurations for the project.
- **flake.lock**: Locks the versions of the inputs specified in `flake.nix` to ensure reproducibility.
- **overlays/**: Contains Nix overlays to modify or extend existing packages.
  - **default.nix**: A Nix overlay for general package modifications.
  - **stable.nix**: A Nix overlay for stable versions of packages.
- **pkgs/**: Defines custom packages for the project.
  - **default.nix**: Custom package definitions.
- **modules/**: Contains configuration modules.
  - **common/**: Shared configurations used across the system.
    - **nix.nix**: Shared Nix configurations.
    - **shells.nix**: Shared shell configurations.
    - **options.nix**: Custom options for modules.
  - **darwin/**: Darwin-specific configurations.
    - **defaults.nix**: Default configurations for Darwin.
    - **services.nix**: Services management for Darwin.
- **home/**: Home Manager modules for user-specific configurations.
  - **shared/**: Shared Home Manager modules.
    - **zsh.nix**: Zsh shell configurations.
    - **git.nix**: Git configurations.
    - **direnv.nix**: Direnv configurations.
  - **users/**: User-specific Home Manager configurations.
    - **blackbojji/**: Configurations for user blackbojji.
      - **common.nix**: User-wide Home Manager configurations.
      - **macbook-air-m4.nix**: Host-specific Home Manager tweaks for Macbook Air M4.
- **hosts/**: Host-specific configurations.
  - **darwin/**: Darwin host configurations.
    - **macbook-air-m4.nix**: Configurations specific to the Macbook Air M4 host.
- **parts/**: Additional project definitions.
  - **devshells.nix**: Development shells for the project.
  - **overlays.nix**: Additional overlays for the project.
- **.gitignore**: Specifies files and directories to be ignored by Git.

## Usage

To use these dotfiles, clone the repository and follow the instructions in the respective configuration files. Ensure you have Nix and Home Manager installed on your Macbook Air M4.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
