{ pkgs, ... }:

let
  sources = import ./nix/sources.nix;

  overlay_niv = _: _: {
    niv = (import sources.niv {}).niv;
  };
  overlay_nur = _: super: {
    nur = import sources.NUR { pkgs = super; };
  };
in
{
  imports =
    [ "${sources.home-manager}/nixos"
      "${sources.musnix}"
      "${sources.nixos-hardware}/lenovo/thinkpad/t480s"
      "${sources.nixos-hardware}/common/pc/ssd"
    ];

  nix.nixPath = [
    "nixpkgs=${sources.nixpkgs}"
    "nixos=${sources.nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nixpkgs.pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    overlays = [ overlay_niv overlay_nur ];
  };

  # Apparently this is being used by something that I use, but I'm not sure
  # what.
  nixpkgs.config.permittedInsecurePackages = [
     "openssl-1.1.1u"
   ];

  environment.systemPackages = [ pkgs.niv ];
}
