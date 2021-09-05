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

    port = mkOption {
      type = types.int;
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

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [ "www.${cfg.domain}" ];
      locations."/".proxyPass = "http://localhost:${builtins.toString cfg.port}";
    };
  };
}
