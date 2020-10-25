{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.metanohi.name" ];
    extraConfig = "include /var/www/metanohi/metanohi.nginx.conf;";
  };
}
