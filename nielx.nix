{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx;
in
{
  imports =
    [ ./nielx/sshserver.nix
      ./nielx/services.nix
      ./nielx/duplicity.nix
      ./nielx/duplicity-local.nix
      ./nielx/longview.nix
      ./nielx/matrix.nix
      ./nielx/feedmael.nix
      ./nielx/roundworm.nix
      ./nielx/irc.nix
      ./nielx/postfix_relayhost.nix
      ./nielx/gitea.nix
      ./nielx/webhooks.nix
      ./nielx/apps.nix
      ./nielx/path-scripts.nix
      ./nielx/simple-emacs.nix
      ./nielx/geomyidae.nix
    ];

  options.nielx = {
    # Main values.  Should always be set.

    user = mkOption {
      type = types.str;
      example = "niels";
    };

    fullName = mkOption {
      type = types.str;
    };

    email = mkOption {
      type = types.str;
      example = "niels@example.com";
    };

    hostname = mkOption {
      type = types.str;
    };

    nixos_config_directory = mkOption {
      type = types.str;
    };

    gpgKey = mkOption {
      type = types.str;
    };

    root = mkOption {
      type = types.str;
      example = "/home/niels/config/nielx";
    };

    shellPromptColor = mkOption {
      type = types.str;
    };

    commonBash = mkOption {
      type = types.str;
    };

    commonShellAliases = mkOption {
      type = types.attrs;
    };

    www = {
      acmeSSL = mkOption {
        type = types.bool;
      };

      domain = mkOption {
        type = types.str;
        description = "main domain";
        example = "example.com";
      };
    };

    graphics = {
      timeToLock = mkOption {
        type = types.int;
      };
      timeToLockOnWifi = mkOption {
        type = types.int;
      };
      lockUnlessWifi = mkOption {
        type = types.str;
      };
    };


    # Derived values.

    home = mkOption {
      type = types.str;
      example = "/home/niels";
    };

    stateDir = mkOption {
      type = types.str;
    };
  };

  config = {
    nielx.home = "/home/${cfg.user}";
    nielx.stateDir = "/home/${cfg.user}/state";
  };
}
