{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."old-projects.metanohi.name" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.old-projects.metanohi.name" "projects.metanohi.name" "www.projects.metanohi.name" ];
    extraConfig = "include /var/www/metanohi-misc-subsites/old-projects/old-projects.nginx.conf;";
  };
}
