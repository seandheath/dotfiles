{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."nc.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.2:80";
        proxyWebsockets = true;
      };
    };
    virtualHosts."hs.nheath.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://10.0.0.1:8080";
        proxyWebsockets = true;
      };
    };
  };
}
