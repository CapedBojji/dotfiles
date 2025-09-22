# modules/home/nix/dots-registry.nix
{ self, lib, config, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.my.dotsRegistry;

  githubTo =
    { owner, repo, ref ? null }:
    {
      type = "github";
      inherit owner repo;
    } // (lib.optionalAttrs (ref != null) { inherit ref; });

  pathTo = path: {
    type = "path";
    inherit path;
  };

  preferPath =
    cfg.source == "path"
    || (cfg.preferPathIfExists && cfg.path != null && builtins.pathExists (toString cfg.path));

  aliasName = cfg.name;
in
{
  options.my.dotsRegistry = {
    enable = mkEnableOption "Register a flake alias (e.g. `dots`) for your templates";

    # Name of the alias, e.g. `dots` so you can do: nix flake init -t dots#<template>
    name = mkOption {
      type = types.str;
      default = "dots";
      description = "Registry alias name.";
    };

    # Where to point the alias by default
    source = mkOption {
      type = types.enum [ "path" "github" ];
      default = "github";
      description = "Primary source for the alias.";
    };

    # If true and 'path' exists, prefer it over GitHub automatically.
    preferPathIfExists = mkOption {
      type = types.bool;
      default = true;
      description = "Prefer local path when it exists, even if source=github.";
    };

    # Local path (used when source=path, or when preferPathIfExists is true and the path exists)
    path = mkOption {
      type = types.nullOr types.path;
      default = self;
      description = "Local path to your dots flake (default = this flake).";
    };

    # GitHub owner/repo (used when source=github)
    githubOwner = mkOption {
      type = types.str;
      default = "YourUserName";
      description = "GitHub owner or org for your dots flake.";
    };

    githubRepo = mkOption {
      type = types.str;
      default = "dots";
      description = "GitHub repository name for your dots flake.";
    };

    # Optional: pin to a branch/tag (e.g., \"main\", \"v1.2.3\")
    githubRef = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Optional GitHub ref (branch or tag) to use for the alias.";
    };
  };

  config = mkIf cfg.enable {
    # Create/override the registry entry declaratively.
    nix.registry.${aliasName} = {
      from = {
        type = "indirect";
        id = aliasName;
      };

      to =
        if preferPath && cfg.path != null then
          pathTo (toString cfg.path)
        else
          githubTo {
            owner = cfg.githubOwner;
            repo  = cfg.githubRepo;
            ref   = cfg.githubRef;
          };
    };
  };
}
