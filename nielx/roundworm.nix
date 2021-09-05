{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.roundworm;
in
{
  options.nielx.roundworm = {
    enable = mkEnableOption "browse media stored in S3";

    config = mkOption {
      type = types.str;
    };

    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    nielx.services.roundworm = {
      command = "${config.nielx.root}/nielx/roundworm/roundworm serve ${cfg.config}";
      packages = (import ./roundworm/shell.nix).buildInputs;
      user = config.nielx.user;
      group = "users";
      preStart = null;
      when = null;
    };
  };
}
