{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.sshserver;
in
{
  options.nielx.sshserver = {
    enable = mkEnableOption "ssh server";

    port = mkOption {
      type = types.int;
      example = 22;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
