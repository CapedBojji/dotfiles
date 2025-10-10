{ lib, python312Packages, typer }:

python312Packages.buildPythonPackage rec {
  pname = "img2art";
  version = "0.4.3";
  # This project uses a pyproject.toml (PEP 517). Use the "pyproject" format
  # so the pypa install hooks are used instead of the legacy setuptools
  # build phase which expects a setup.py file.
  format = "pyproject";

  src = python312Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-+tPFTeKGzEqaQfTy5YuT1z8LhKgT7n1VG4vyBCEfJDE=";
  };

  propagatedBuildInputs = with python312Packages; [
    pillow
    numpy
    opencv-python
    poetry-core
  ] ++ [ typer];

  meta = with lib; {
    description = "A library to convert images to ASCII art";
    homepage = "https://github.com/R-s0n/img2art";
    license = licenses.mit;
  };
}