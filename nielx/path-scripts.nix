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
          # There is some overhead in this, but not too much.  The nice thing is
          # that we won't have to rebuild the system if these external projects
          # change something.  If they were more central to this repository, we
          # could instead integrate them fully and not have this slight
          # nix-shell entering overhead, but then we would lose the other
          # benefit.
          if data.nix
          then pkgs.writeScriptBin s ''#!/bin/sh
args="$@"
exec ${pkgs.nix}/bin/nix-shell --command "${d}/${s} $args" ${d}/shell.nix''
          else utils.binWrapper s "${d}/${s}") cfg.scripts;
  };
}
