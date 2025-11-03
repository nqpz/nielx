{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."hestehavegaard.dk" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    root = "/var/www/hestehavegaard.dk";
    serverAliases = [ "www.hestehavegaard.dk" ];
  };
}
