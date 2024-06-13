{ pkgs, ... }:

let
  sources = import ./nix/sources.nix;

  overlay_niv = _: _: {
    niv = (import sources.niv {}).niv;
  };
  overlay_nur = _: super: {
    nur = import sources.NUR { pkgs = super; };
  };
  overlay_hybrid_codec = _: super: {
    intel-vaapi-driver = super.intel-vaapi-driver.override { enableHybridCodec = true; };
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
    overlays = [ overlay_niv overlay_nur overlay_hybrid_codec ];
  };

  environment.systemPackages = [ pkgs.niv ];
}
