{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.path-scripts;
  utils = import ../utils.nix config pkgs;
in
{
  options.nielx.path-scripts = {
    enable = mkEnableOption "putting scripts outside the nielx directory in PATH";

    root = mkOption {
      type = types.str;
      example = "/home/eample/projects/";
    };

    scripts = mkOption {
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      map (relPath: utils.binWrapper (baseNameOf relPath) "${cfg.root}/${relPath}") cfg.scripts;
  };
}
