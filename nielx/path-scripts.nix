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
      example = "/home/example/projects/";
    };

    scripts = mkOption {
      type = types.listOf (types.submodule {
        options = {
          dir = mkOption {
            type = types.str;
          };
          script = mkOption {
            type = types.str;
          };
          nix = mkOption {
            type = types.bool;
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      map (data:
        let
          d = "${cfg.root}/${data.dir}";
          s = data.script;
        in
          # There is some overhead in this, but not too much.
          if data.nix
          then pkgs.writeScriptBin s ''#!/bin/sh
exec ${pkgs.nix}/bin/nix-shell --command "${d}/${s} $@" ${d}/shell.nix''
          else utils.binWrapper s "${d}/${s}") cfg.scripts;
  };
}
