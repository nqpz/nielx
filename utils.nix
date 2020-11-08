config: pkgs:

{
  # Sometimes it's nice to be able to live-edit a file instead of waiting for
  # 'nixos-rebuild switch' to copy it and finish.  This function addresses that
  # usecase by making a derivation that symlinks to the actual file in this
  # repository.  I guess this is a bit wrong.
  symlinkTo = source:
    let
      linkDir = pkgs.stdenv.mkDerivation {
        name = "symlink";
        phases = "installPhase";
        installPhase = ''
          mkdir -p $out
          ln -s ${config.nielx.root}/laptop/${source} $out/symlink
        '';
      };
    in
      "${linkDir}/symlink";

  binWrapper = dest: src:
    pkgs.writeScriptBin dest ''#!/bin/sh
      exec ${src} "$@"
    '';
}
