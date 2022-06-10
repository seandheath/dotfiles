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
    virtualHosts."sunrise.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.2:8096";
        proxyWebsockets = true;
      };
    };
    virtualHosts."nc.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.2/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 32G;
          client_body_timeout 300s;
          fastcgi_buffers 64 4k;
        '';
      };
    };
    # Config for valoren server
    streamConfig = ''
      server {
        listen 14004;
        proxy_timeout 20s;
        proxy_pass 10.0.0.2:14004;
      }
    '';
  };
}
