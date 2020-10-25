{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."natur.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.natur.metanohi.name" "nature.metanohi.name" "www.nature.metanohi.name" ];
    extraConfig = "include /var/www/metanohi-misc-subsites/natur/natur.nginx.conf;";
  };
}
