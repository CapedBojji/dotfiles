{ pkgs, username, ... }:
pkgs.writeShellScriptBin "on" # bash
  ''
    if [ -z "$1" ]; then
      echo "Enter a filename"
      exit 1
    fi

    # file_name=$(echo "$1" | tr ' ' '-')
    file_name=$(echo "$1")
    # formatted_file_name="$(date "+%d-%m-%Y") - $file_name.md"
    formatted_file_name="$file_name.md"
    cd "/home/${username}/Documents/Main/01 - Rough Notes/" || exit
    touch "$formatted_file_name"
    nvim "$formatted_file_name"
  ''
