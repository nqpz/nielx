{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."nohix.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.nohix.metanohi.name" ];
    extraConfig = "include /var/www/metanohi-misc-subsites/nohix/nohix.nginx.conf;";
  };
}
