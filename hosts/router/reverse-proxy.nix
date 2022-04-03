{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "se@nheath.com";
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    virtualHosts."nc.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.2/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 32G;
        '';
      };
    };
    virtualHosts."hs.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/headscale." = {
          extraConfig = ''
            grpc_pass grpc://${config.services.headscale.settings.grpc_listen_addr};
          '';
          priority = 1;
        };
        "/metrics" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          extraConfig = ''
            allow 10.0.0.0/8;
            allow 100.64.0.0/16;
            deny all;
          '';
          priority = 2;
        };
        "/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          extraConfig = ''
            keepalive_requests          100000;
            keepalive_timeout           160s;
            proxy_buffering             off;
            proxy_connect_timeout       75;
            proxy_ignore_client_abort   on;
            proxy_read_timeout          900s;
            proxy_send_timeout          600;
            send_timeout                600;
          '';
          priority = 99;
        };
      };
    };
  };
}
