{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.matrix;
in
{
  options.nielx.matrix = {
    enable = mkEnableOption "matrix synapse server";

    mainDomain = mkOption {
      type = types.str;
      example = "example.com";
    };

    internalPort = mkOption {
      type = types.int;
      description = "This number can be picked arbitrarily.";
    };
  };

  config = let
    identityServer = "https://vector.im";
  in mkIf cfg.enable {
    services.matrix-synapse = {
      enable = true;
      settings = {
        server_name = "${cfg.mainDomain}";
        database.name = "sqlite3";
        listeners = [
          {
            port = cfg.internalPort;
            bind_addresses = [ "::" "0.0.0.0" ];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
              {
                names = [ "client" "federation" ];
                compress = false;
              }
            ];
          }
        ];
      };
      # account_threepid_delegates.email = identityServer;
    };

    services.nginx.enable = true;

    services.nginx.virtualHosts."matrix.${cfg.mainDomain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".return = "404";
      locations."/_matrix" = {
        proxyPass = "http://[::1]:${builtins.toString cfg.internalPort}";
      };
    };

    # Add extra hints to main domain.
    services.nginx.virtualHosts."${cfg.mainDomain}".locations = {
      "= /.well-known/matrix/server".extraConfig =
        let server = {
              "m.server" = "matrix.${cfg.mainDomain}:443";
            };
        in ''
        add_header Content-Type application/json;
        return 200 '${builtins.toJSON server}';
'';

      "= /.well-known/matrix/client".extraConfig =
        let client = {
              "m.homeserver" = { "base_url" = "https://matrix.${cfg.mainDomain}"; };
              "m.identity_server" =  { "base_url" = identityServer; };
            };
        in ''
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '${builtins.toJSON client}';
'';
    };
  };
}
