{ config, ... }:
{
  services.syncthing = {
    enable = true;
    # cert   = config.age.secrets."syncthing-cert".path;
    # key    = config.age.secrets."syncthing-key".path;

    settings = {
      folders = {
        default = {
          path = config.home.homeDirectory + "/sync";
          type = "sendreceive";
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "31536000";
            };
          };
          devices = [ "s21-ultra" ];
        };
      };
      devices = {
        s21-ultra = {
          id = "RXVAQEJ-ZZSEMA5-4HGFQGP-MTWP5WD-TAXIZP4-4U5F5ID-LA7C6XN-23LQKQ6";
          autoAcceptFolders = true;
        };
      };
    };
  };
}

