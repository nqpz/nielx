{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.duplicity;
in
{
  options.nielx.duplicity = {
    enable = mkEnableOption "basic backups with duplicity";

    paths = mkOption {
      type = types.listOf types.str;
      example = [ "/var/lib" ];
    };
    ignore = mkOption {
      type = types.listOf types.str;
    };
    destination = mkOption {
      type = types.str;
      example = "b2://...";
    };
    password = mkOption {
      type = types.str;
    };
    frequency = mkOption {
      type = types.str;
      example = "*-*-* 01:00:00";
    };
  };

  config = mkIf cfg.enable {
    services.duplicity = {
      enable = true;
      frequency = cfg.frequency;
      root = "/";
      include = cfg.paths;
      exclude = cfg.ignore ++ [ "**" ];
      targetUrl = cfg.destination;
      secretFile = pkgs.writeText "secrets" "PASSPHRASE=${cfg.password}";
    };
  };
}
