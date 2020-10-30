{ config, pkgs, lib, ... }:

with lib;

{
  options.nielx.apps = mkOption {
    default = { };
    type = types.attrsOf (types.submodule {
      options = {
        url = mkOption {
          type = types.str;
        };
        browser = mkOption {
          type = types.str;
        };
      };
    });
  };

  config = {
    environment.systemPackages =
      mapAttrsToList (name: value: (pkgs.writeScriptBin name "${value.browser} --app=${value.url}"))
        config.nielx.apps;
  };
}
