{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."media.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.media.metanohi.name" ];
    extraConfig = "include /var/www/media/media.nginx.conf;";
  };
}
