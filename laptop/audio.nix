{ config, pkgs, ... }:

let
  cfg = config.nielx;
in
{
  users.users."${cfg.user}".extraGroups = [ "audio" ];

  environment.systemPackages = with pkgs; [
    pavucontrol
    # Test JACK with jack_simple_client.
    libjack2 jack2 qjackctl libjack2 jack2 qjackctl jack_capture
    timidity vkeybd
  ];

  musnix = {
    enable = true;
    soundcardPciId = "00:1f.3"; # lspci | grep -i audio
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    home.file.".config/pulse/client.conf".text = ''
      daemon-binary=${pkgs.pulseaudio}/bin/pulseaudio
    '';
  };
}
