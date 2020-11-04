{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.rdiff-backup;
in
{
  options.nielx.rdiff-backup = {
    enable = mkEnableOption "basic backups with rdiff-backup";

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
  };

  config = let
    paths' = builtins.concatStringsSep "\n" cfg.paths;
    ignores' = builtins.concatStringsSep "\n" (map (ignore: "- ${ignore}") cfg.ignores);
    globbingFileList = pkgs.writeText "globbingFileList" ("${paths'}\n${ignores'}\n- **\n");
    script = pkgs.writeScriptBin "backup" ''
#!/bin/sh

export SSH_AUTH_SOCK=/run/user/1000/ssh-agent

${pkgs.time}/bin/time -p \
     ${pkgs.rdiff-backup}/bin/rdiff-backup \
     --include-symbolic-links \
     --include-globbing-filelist ${globbingFileList} \
     ${config.nielx.home} ${cfg.destination}
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

    nielx.services.rdiff-backup = {
      preStart = null;
      command = "${scriptIfWifi}/bin/backup-if-wifi";
      packages = [ pkgs.openssh ];
      user = "${config.nielx.user}";
      group = "users";
      when = cfg.frequency;
    };
  };
}
