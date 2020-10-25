{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.feedmael;
in
{
  options.nielx.feedmael = {
    enable = mkEnableOption "send emails when RSS and Atom feeds update";

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/feedmael";
    };

    stateFile = mkOption {
      type = types.str;
      default = "state";
    };

    fromAddress = mkOption {
      type = types.str;
    };

    toAddress = mkOption {
      type = types.str;
    };

    feeds = mkOption {
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    nielx.services.services.feedmael = {
      preStart = "mkdir -p ${cfg.stateDir}";
      command = "${config.nielx.root}/nielx/feedmael/feedmael.py ${cfg.stateDir}/${cfg.stateFile} ${cfg.fromAddress} ${cfg.toAddress} ${builtins.concatStringsSep " " cfg.feeds}";
      packages = (import ./feedmael/default.nix).buildInputs;
      user = config.nielx.user;
      group = "users";
      when = "hourly";
    };
  };
}
