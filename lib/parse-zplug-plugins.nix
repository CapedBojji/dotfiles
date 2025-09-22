# lib/parse-zplug-plugins.nix
{ lib }:
let
  split = lib.strings.splitString;
  trim  = lib.strings.trim or (s: s);  # fallback if very old lib
in
# [ "name; tag1; tag2" ... ] -> [ { name = "name"; tags = [ "tag1" "tag2" ]; } ... ]
input:
let
  parse = s:
    let parts = map trim (split ";" s);
    in {
      name = builtins.head parts;
      tags = builtins.tail parts;
    };
in
map parse input


