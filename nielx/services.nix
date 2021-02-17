{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx;

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
    wantedBy = if when != null then [] else [ "multi-user.target" ];
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

  config = let
    systemd_email = pkgs.writeScript "systemd_email" ''#!/bin/sh
${pkgs.postfix}/bin/sendmail -t <<EOF
To: ${cfg.email}
Subject: [${cfg.hostname} systemd] $1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8

$(${pkgs.systemd}/bin/systemctl status --full "$1")
EOF
'';
  in {
    systemd.timers = mapAttrs makeServiceTimer config.nielx.services;
    systemd.services = mapAttrs makeServiceService config.nielx.services // {
      "status_email_user@" = {
        enable = true;
        path = with pkgs; [ systemd postfix ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${systemd_email} %i";
          User = "root";
          Group = "systemd-journal";
        };
      };
    };
  };
}
