{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."mad.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.mad.metanohi.name" ];
    root = "/var/www/mad/site";
  };
}
