{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.geomyidae;
in
{
  options.nielx.geomyidae = {
    enable = mkEnableOption "run a gopher server";

    baseDir = mkOption {
      type = types.path;
      default = "/var/gopher";
    };

    hostname = mkOption {
      type = types.str;
      default = "localhost";
    };

    allowExternal = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = if cfg.allowExternal then [ 70 ] else [ ];

    nielx.services.geomyidae = {
      command = "${pkgs.geomyidae}/bin/geomyidae -d -e -b ${cfg.baseDir} -h ${cfg.hostname} -u ${config.nielx.user} -g users";
      packages = [];
      user = "root";
      group = "root";
      preStart = null;
      when = null;
    };
  };
}
