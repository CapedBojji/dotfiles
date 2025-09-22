{ self, ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      include ${self}/config/terminals/kitty/kitty.conf
      window_padding_width 20
    '';
  };
}

