{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.postfix_relayhost;
  passwd_file = "postfix.local/sasl_passwd";
in
{
  options.nielx.postfix_relayhost = {
    enable = mkEnableOption "postfix server using another mail server as a relay";

    relayHost = mkOption {
      type = types.str;
      example = "example.com";
    };

    emailUser = mkOption {
      type = types.str;
    };

    emailPassword = mkOption {
      type = types.str;
    };

    defaultOriginDomain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.postfix = {
      enable = true;

      settings.main = {
        myorigin = cfg.defaultOriginDomain; # Default
        relayhost = [ "${cfg.relayHost}" ];
        smtp_sasl_password_maps = "hash:/etc/${passwd_file}";
        smtp_tls_wrappermode = "yes";
        smtp_tls_security_level = lib.mkForce "verify";
        smtp_tls_mandatory_protocols = "!SSLv2, !TLSv1, !TLSv1.1";
        tls_high_cipherlist = "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";
        smtp_tls_mandatory_ciphers = "high";
        smtp_tls_loglevel = "2";
        smtp_sasl_auth_enable = "yes";
        smtp_sasl_mechanism_filter = "plain";
        smtp_sasl_security_options = "noanonymous";
        smtp_tls_CAfile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      };
    };

    environment.etc."${passwd_file}" = {
      text = "${cfg.relayHost} ${cfg.emailUser}:${cfg.emailPassword}";
      mode = "600";
    };
    # systemd.services.postfix.preStart = "${pkgs.postfix}/sbin/postmap /etc/${passwd_file}";
  };
}
