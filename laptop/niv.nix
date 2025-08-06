{ pkgs, ... }:

let
  sources = import ./nix/sources.nix;

  overlay_niv = _: _: {
    niv = (import sources.niv {}).niv;
  };
  overlay_nur = _: super: {
    nur = import sources.NUR { pkgs = super; };
  };

  # From https://github.com/hashcat/hashcat/issues/4116#issuecomment-3161672973
  overlay_intel_legacy = self: super: {
    # replace intel-compute-runtime with intel-compute-runtime-legacy1 for legacy Gen8, Gen9 and Gen11 Intel GPUs
    intel-compute-runtime = super.intel-compute-runtime-legacy1;

    # create symlink for intel-opencl/libigdrcl_legacy1.so
    super.systemd.tmpfiles.rules =
      let
        createLink = src: dest: "L+ ${dest} - - - - ${src}";
      in
        [
          (createLink "${super.pkgs.intel-compute-runtime-legacy1}/lib/intel-opencl/libigdrcl_legacy1.so" "/usr/lib/x86_64-linux-gnu/intel-opencl/libigdrcl_legacy1.so")
        ];
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
    "nixos=${sources.nixpkgs}/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nixpkgs.pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    overlays = [
      overlay_niv
      overlay_nur
      overlay_intel_legacy
    ];
  };

  environment.systemPackages = [ pkgs.niv ];
}
