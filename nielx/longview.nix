{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.longview;
in
{
  options.nielx.longview = {
    enable = mkEnableOption "linode longview";

    api_key = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.longview = {
      enable = true;
      apiKeyFile = pkgs.writeText "keyfile" cfg.api_key;
    };
  };
}
