{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."hest.quest" = {
    addSSL = config.nielx.www.acmeSSL;
    enableACME = config.nielx.www.acmeSSL;
    serverAliases = [ "www.hest.quest" ];
    root = "/var/www/hest.quest";
    extraConfig = ''
location ~* \.php$ {
    fastcgi_pass unix:/run/phpfpm/main.sock;
    include /etc/nginx/fastcgi.conf;
}
'';
  };
}
