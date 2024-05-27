{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.irc;
in
{
  options.nielx.irc = {
    enable = mkEnableOption "irc wrapper";

    nick = mkOption {
      type = types.str;
    };

    znc = {
      password = mkOption {};
      port = mkOption {
        type = types.int;
      };
      user = mkOption {
        type = types.str;
      };
      group = mkOption {
        type = types.str;
      };
    };

    bitlbee = {
      enable = mkEnableOption "integrate with bitlbee";
      password = mkOption {
        type = types.str;
      };
      hostName = mkOption {
        type = types.str;
      };
      port = mkOption {
        type = types.int;
      };
    };

    networks = mkOption {
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    services.znc = {
      enable = true;
      mutable = false;
      useLegacyConfig = false;
      openFirewall = true;
      user = "${cfg.znc.user}";
      group = "${cfg.znc.group}";

      config = {
        MaxBufferSize = 500000;
        Listener.l.Port = cfg.znc.port;
        LoadModule = [ "adminlog" "log" ];
        User."${cfg.nick}" = {
          Admin = true;
	  Buffer = 500000;
	  ChanBufferSize = 500000;
          Pass.password = cfg.znc.password;
          Network = cfg.networks // (if cfg.bitlbee.enable then {
            bitlbee = {
              Server = "127.0.0.1 ${builtins.toString cfg.bitlbee.port} ${cfg.bitlbee.password}";
              Chan = { };
              Nick = cfg.nick;
              JoinDelay = 2;
            };
          } else {});
        };
      };
    };

    users.users.bitlbee = mkIf cfg.bitlbee.enable {
      group = "bitlbee";
      isSystemUser = true;
    };
    users.groups.bitlbee = mkIf cfg.bitlbee.enable {};

    # nixpkgs.config.bitlbee.enableLibPurple = cfg.bitlbee.enable;
    # services.bitlbee = mkIf cfg.bitlbee.enable {
    #   enable = true;
    #   hostName = cfg.bitlbee.hostName;
    #   portNumber = cfg.bitlbee.port;
    #   authMode = "Registered";
    #   libpurple_plugins = [
    #     pkgs.purple-matrix
    #   ];
    # };
  };
}
