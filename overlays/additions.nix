# parts/overlays/additions.nix
{ inputs }:
final: prev:
{
  # expose a stable nixpkgs under pkgs.stable
  stable = import inputs.nixpkgs-stable {
    system = final.system;
    config = { allowUnfree = true; };
    # overlays = [ ... ]  # usually leave empty to avoid recursion
  };
  # Import the package using the pkgs.callPackage helper so it gets all
  # required arguments (lib, buildPythonPackage, fetchers, python3Packages,
  # etc.) from the `prev` package set. This avoids "undefined variable"
  # errors for `buildPythonPackage` when the overlay is evaluated.
  img2art = prev.callPackage ../pkgs/img2art.nix {
    inherit (prev) lib python312Packages;
    typer = final.typer_0_15;
  };
  typer_0_15 = prev.python312Packages.buildPythonPackage rec {
    pname = "typer";
    version = "0.15.4";
    format = "pyproject";
    src = prev.python312Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-iVB7EE+bagcwNU8nw5+uW2PM0MlbHOHxproM/TKZl8M=";
    };

    # build/runtime inputs for this pinned typer version
    propagatedBuildInputs = with prev.python312Packages; [ click typing-extensions shellingham rich ];

    # pdm-backend is available and provides the PEP517 backend implementation
    # needed by this typer version during build.
    nativeBuildInputs = with prev.python312Packages; [ pdm-backend ];

    meta = with prev.lib; {
      description = "Typer pinned to 0.15.4 for img2art";
      license = licenses.mit;
    };
  };
}

