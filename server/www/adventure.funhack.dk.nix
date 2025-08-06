{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."adventure.funhack.dk" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    root = "/var/www/adventure.funhack.dk";
  };
}
