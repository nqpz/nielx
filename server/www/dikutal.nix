{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."dikutal.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.dikutal.metanohi.name" ];
    extraConfig = "include /var/www/dikutal/dikutal.dk.nginx.conf;";
  };
  services.nginx.virtualHosts."qa.dikutal.metanohi.name" = {
    addSSL = true;
    enableACME = true;
    serverAliases = [ "www.qa.dikutal.metanohi.name" ];
    extraConfig = "include /var/www/dikutal/qa.dikutal.dk.nginx.conf;";
  };
}
