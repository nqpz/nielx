{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.gitea;
in
{
  options.nielx.gitea = {
    enable = mkEnableOption "gitea";

    name = mkOption {
      type = types.str;
    };

    domain = mkOption {
      type = types.str;
    };

    port = mkOption {
      type = types.int;
    };

    sshPort = mkOption {
      type = types.int;
    };

    dbpassword = mkOption {
      type = types.str;
    };

    locationsPre = mkOption {
      type = types.attrs;
    };

    backupFrequency = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.etc."gitea.local/dbpassword" = {
      text = cfg.dbpassword;
      user = "gitea";
      group = "wheel";
      mode = "0640";
    };

    services.gitea = {
      enable = true;
      disableRegistration = true;
      appName = cfg.name;
      database = {
        type = "postgres";
        passwordFile = "/etc/gitea.local/dbpassword";
      };
      domain = "${cfg.domain}";
      rootUrl = "https://${cfg.domain}/";
      httpPort = cfg.port;
      ssh = {
        enable = true;
        clonePort = cfg.sshPort;
      };
      settings = let
        docutils = pkgs.python3.withPackages (ps: with ps; [ docutils pygments ]);
      in {
        mailer = {
          ENABLED = true;
          FROM = "gitea@${cfg.domain}";
        };
        service = {
          REGISTER_EMAIL_CONFIRM = true;
        };
        markdown = {
          ENABLE_HARD_LINE_BREAK_IN_COMMENTS = false;
        };
        "markup.restructuredtext" = {
          ENABLED = true;
          FILE_EXTENSIONS = ".rst";
          RENDER_COMMAND = "${docutils}/bin/rst2html.py";
          IS_INPUT_FILE = false;
        };
        server = {
          LANDING_PAGE = "explore";
        };
        repository = {
          DEFAULT_PRIVATE = "public";
          ENABLE_PUSH_CREATE_USER = true;
          USE_COMPAT_SSH_URI = true;
        };
        "cron.archive_cleanup" = {
          SCHEDULE = "@every 1h";
          OLDER_THAN = "1h";
        };
      };
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;

      locations = cfg.locationsPre // {
        "/".proxyPass = "http://localhost:${builtins.toString cfg.port}/";
      };
      extraConfig = "client_max_body_size 128M;";
    };

    services.postgresql = {
      enable = true;

      authentication = ''
      local gitea all ident map=gitea-users
    '';
      identMap = ''
      gitea-users gitea gitea
    '';
    };

    nielx.services.gitea-dump = let
      stateDir = "/var/lib/gitea";
      giteaDump = pkgs.writeScript "gitea_dump" ''#!/bin/sh
set -e
cd ${stateDir}

# Remove achives to keep the dump size small.
rm -f repositories/*/*/archives/targz/*.tar.gz repositories/*/*/archives/zip/*.zip

# Dump.
cd dump
GITEA_WORK_DIR=${stateDir} gitea dump > /dev/null

# Overwrite any earlier file since these dumps take up a bit of space.
mv -f gitea-dump-*.zip gitea-dump.zip
'';
    in {
      preStart = null;
      command = "${giteaDump}";
      packages = [ pkgs.gitea ];
      user = "gitea";
      group = "wheel";
      when = cfg.backupFrequency;
    };
  };
}
