{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."suum.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.suum.metanohi.name" ];
    extraConfig = "include /var/www/suum/suum.nginx.conf;";
  };
}
