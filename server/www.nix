{ config, lib, pkgs, ... }:

{
  imports =
    [ ./www/metanohi.nix
      ./www/nohix.nix
      ./www/suum.nix
      ./www/old-projects.nix
      ./www/natur.nix
      ./www/media.nix
      ./www/dikutal.nix
      ./www/burgerforslag.nix
    ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    email = config.nielx.email;
  };

  services.nginx = {
    group = "users";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    package = pkgs.nginx;
    enable = true;
    commonHttpConfig = ''
      charset UTF-8;
      log_format vcombined '$host:$server_port ' '$remote_addr - $remote_user [$time_local] ' '"$request" $status $body_bytes_sent ' '"$http_referer" "$http_user_agent"';
      access_log /var/log/nginx/access.log.gz vcombined gzip=9;

      server {
          listen 127.0.0.1:80;
          server_name 127.0.0.1;

          location /nginx_status {
              stub_status;
          }
      }
    '';
  };

  environment.etc."nginx".source = "${pkgs.nginx}/conf";

  # This is a very underpowered PHP runner, but I barely need it anyway.
  services.phpfpm.pools = {
    main = {
      user = "nginx";
      group = "users";
      settings = {
        "listen.owner" = "nginx";
        "listen.group" = "users";
        "pm" = "static";
        "pm.max_children" = 1;
      };
    };
  };

  nielx = {
    www.acmeSSL = true;
    gitea = {
      enable = true;
      name = "metanohi gitea";
      domain = "git.metanohi.name";
    };
    webhooks = {
      enable = true;
      webhooks = [
        { route = "/metanohi"; dir = "/var/www/metanohi";
          default = /var/www/metanohi/default.nix; command = "./scripts/transform-site.sh"; }
        { route = "/media"; dir = "/var/www/media";
          default = /var/www/media/default.nix; command = "./scripts/generate-site.sh"; }
        { route = "/github-web-hook"; dir = "/var/www/burgerforslag";
          default = /var/www/burgerforslag/default.nix; command = "./update"; }
      ];
    };
  };
}
