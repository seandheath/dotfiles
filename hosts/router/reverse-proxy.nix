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
    recommendedGzipSettinsg = true;
    recommendedOptimisation = true;
    virtualHosts."nc.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.2:80";
        proxyWebsockets = true;
      };
      extraConfig = ''
        proxy_ssl_server_name on;
        proxy_pass_header Authorization;
      '';
    };
    virtualHosts."hs.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
      extraConfig = ''
        proxy_ssl_server_name on;
        proxy_pass_header Authorization;
      '';
    };
  };
}
