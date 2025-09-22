{ config, self, ... }:
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      syncthing-cert = {
        file  = "${self}/secrets/syncthing-cert.pem.age";
        mode  = "0400";
      };

      syncthing-key = {
        file  = "${self}/secrets/syncthing-key.pem.age";
        mode  = "0400";
      };
    };
  };
}