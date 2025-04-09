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
      ./www/mad.nix
    ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = config.nielx.email;
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
    gitea = {
      enable = true;
      name = "metanohi gitea";
      domain = "git.metanohi.name";
      locationsPre = {
        "/metanohi.git".extraConfig = "return 301 /ngws/metanohi;";
        "/media.git".extraConfig = "return 301 /ngws/media;";
        "/metanohi-misc-subsites.git".extraConfig = "return 301 /ngws/metanohi-misc-subsites;";
        "/a-robots-conundrum.git".extraConfig = "return 301 /ngws/a-robots-conundrum;";
        "/indirectassassin.git".extraConfig = "return 301 https://github.com/nqpz/indirectassassin;";
        "/hest.git".extraConfig = "return 301 https://github.com/nqpz/hest;";
        "/gravnoise.git".extraConfig = "return 301 https://github.com/nqpz/gravnoise;";
        "/electruth.git".extraConfig = "return 301 https://github.com/nqpz/electruth;";
        "/dotbox.git".extraConfig = "return 301 https://github.com/nqpz/dotbox;";
        "/canvase.git".extraConfig = "return 301 https://github.com/nqpz/canvase;";
        "/bytebeat.git".extraConfig = "return 301 https://github.com/nqpz/bytebeat;";
        "/alp.git".extraConfig = "return 301 https://github.com/nqpz/alp;";
        "/alart.git".extraConfig = "return 301 https://github.com/nqpz/alart;";
        "/aeltei.git".extraConfig = "return 301 https://github.com/nqpz/aeltei;";
        "/hbcht.git".extraConfig = "return 301 https://github.com/nqpz/hbcht;";
        "/dililatum.git".extraConfig = "return 301 https://github.com/nqpz/dililatum;";
        "/forestquest.git".extraConfig = "return 301 https://github.com/nqpz/forestquest;";
        "/violat.git".extraConfig = "return 301 https://github.com/nqpz/violat;";
        "/reje.git".extraConfig = "return 301 https://github.com/nqpz/reje;";
        "/perspektrino.git".extraConfig = "return 301 https://github.com/nqpz/perspektrino;";
        "/Na.git".extraConfig = "return 301 https://github.com/nqpz/Na;";
        "/pumila.git".extraConfig = "return 301 https://github.com/nqpz/pumila;";
        "/shadowloss.git".extraConfig = "return 301 https://github.com/nqpz/shadowloss;";
      };
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
        { route = "/metanohi-gopher"; dir = "/var/gopher";
          default = /var/gopher/shell.nix; command = "make"; }
        { route = "/mad"; dir = "/var/www/mad";
          default = /var/www/media/default.nix; command = "./byg/result/bin/byg"; }
      ];
    };
  };
}
