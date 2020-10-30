{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.webhooks;
in
{
  options.nielx.webhooks = {
    enable = mkEnableOption "git hooks to be run on web requests";

    port = mkOption {
      type = types.int;
    };

    webhooks = mkOption {
      type = types.listOf (types.submodule {
        options = {
          route = mkOption {
            type = types.str;
          };
          dir = mkOption {
            type = types.str;
          };
          default = mkOption {
            type = types.path;
          };
          command = mkOption {
            type = types.str;
          };
        };
      });
    };
  };

  config = let
    formatAction = { route, dir, default, command }:
      "${route} ${dir} PATH=${builtins.concatStringsSep ":"
        (map (pkg: "${pkg}/bin") (import default).buildInputs)}:$PATH ${command}";
    webhooksActionsFile = pkgs.writeText "actions" (builtins.concatStringsSep "\n" (map formatAction cfg.webhooks));
    webhooksScript = pkgs.writeScript "webhooks.py" (builtins.readFile ./webhooks.py);
  in mkIf cfg.enable {
    nielx.services.webhooks = {
      preStart = null;
      command = "${webhooksScript} ${builtins.toString cfg.port} ${webhooksActionsFile}";
      packages = with pkgs; [ python3 git ];
      user = config.nielx.user;
      group = "users";
      when = null;
    };
  };
}
