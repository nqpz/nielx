{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."burgerforslag.dk" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.burgerforslag.dk" "burgerforslag.metanohi.name" "www.burgerforslag.metanohi.name" ];
    extraConfig = "include /var/www/burgerforslag/burgerforslag.nginx.conf;";
  };

  nielx.services.services.burgerforslag-update = {
    preStart = null;
    command = "${pkgs.dash}/bin/dash -c '/var/www/burgerforslag/get_missing_borgerforslag && /var/www/burgerforslag/update'";
    packages = (import /var/www/burgerforslag/default.nix).buildInputs;
    user = config.nielx.user;
    group = "users";
    when = "*-*-* 12:15:00";
  };
}
