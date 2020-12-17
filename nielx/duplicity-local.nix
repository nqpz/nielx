{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.duplicity-local;
in
{
  options.nielx.duplicity-local = {
    enable = mkEnableOption "local backups with duplicity";

    destination = mkOption {
      type = types.str;
    };
    paths = mkOption {
      type = types.listOf types.str;
    };
    ignores = mkOption {
      type = types.listOf types.str;
      example = [ "*.o" ];
    };
    frequency = mkOption {
      type = types.str;
      example = "*-*-* 20:00:00";
    };
    backupIfWifi = mkOption {
      type = types.str;
      description = "only backup if on this wifi essid";
    };
    password = mkOption {
      type = types.str;
    };
  };

  config = let
    paths' = builtins.concatStringsSep "\n" cfg.paths;
    ignores' = builtins.concatStringsSep "\n" (map (ignore: "- ${ignore}") cfg.ignores);
    globbingFileList = pkgs.writeText "globbingFileList" ("${paths'}\n${ignores'}\n- **\n");
    script = pkgs.writeScriptBin "backup" ''
#!/bin/sh

export PASSPHRASE=${cfg.password}
export SSH_AUTH_SOCK=/run/user/1000/ssh-agent

${pkgs.time}/bin/time -p \
     ${pkgs.duplicity}/bin/duplicity \
     --include-filelist ${globbingFileList} \
     / ${cfg.destination}
'';
    scriptIfWifi = pkgs.writeScriptBin "backup-if-wifi" ''
#!/bin/sh

set -e
if ${pkgs.iw}/bin/iw wlp3s0 link | grep -q ${cfg.backupIfWifi}; then
    ${script}/bin/backup
fi
'';
  in mkIf cfg.enable {
    environment.systemPackages = [ script scriptIfWifi ];

    nielx.services.duplicity-local = {
      preStart = null;
      command = "${scriptIfWifi}/bin/backup-if-wifi";
      packages = [ pkgs.openssh ];
      user = "${config.nielx.user}";
      group = "users";
      when = cfg.frequency;
    };
  };
}
