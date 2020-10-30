{ config, pkgs, lib, ... }:

with lib;

let
  makeServiceTimer = name: { preStart, command, packages, user, group, when }:
    if when != null then {
      enable = true;
      requires = [ "${name}.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "${name}.service";
        OnCalendar = when;
      };
    } else {};

  makeServiceService = name: { preStart, command, packages, user, group, when }: {
    enable = true;
    wants = if when != null then [ "${name}.timer" ] else [];
    wantedBy = [ "multi-user.target" ];
    path = packages;
    onFailure = [ "status_email_user@${name}.service" ];
    serviceConfig = {
      User = "${user}";
      Group = "${group}";
      Type = if when != null then "oneshot" else "simple";
      ExecStart = command;
    };
    preStart = if preStart != null then preStart else "";
  };
in
{
  options.nielx.services = mkOption {
    default = { };
    type = types.attrsOf (types.submodule {
      options = {
        preStart = mkOption {
          type = types.nullOr types.str;
        };
        command = mkOption {
          type = types.str;
        };
        packages = mkOption {
          type = types.listOf types.package;
        };
        user = mkOption {
          type = types.str;
        };
        group = mkOption {
          type = types.str;
        };
        when = mkOption {
          type = types.nullOr types.str;
        };
      };
    });
  };

  config = {
    systemd.timers = mapAttrs makeServiceTimer config.nielx.services;
    systemd.services = mapAttrs makeServiceService config.nielx.services;
  };
}
