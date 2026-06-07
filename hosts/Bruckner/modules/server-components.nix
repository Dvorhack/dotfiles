{ lib, config, ... }:
{

  imports = [
    ../../../modules/common/docker-compose.nix
  ];

  dockerComposeApp = {
    enable = true;
    sopsAgeKeyFile = [ "/etc/ssh/ssh_host_ed25519_key" ];
    networks = [ "traefik-net" ];
    instances = {
      traefik = {
        composeFile = ./docker/traefik/compose.yaml;
        sopsSecretFile = ./docker/traefik/secrets.enc.env;
      };
      error-pages = {
        composeFile = ./docker/error-pages/compose.yaml;
      };
      pairdrop = {
        composeFile = ./docker/pairdrop/compose.yaml;
      };
      webhook = {
        composeFile = ./docker/webhook/compose.yaml;
      };
      miniflux = {
        composeFile = ./docker/miniflux/compose.yaml;
        sopsSecretFile = ./docker/miniflux/secrets.enc.env;
      };
      ntfy = {
        composeFile = ./docker/ntfy/compose.yaml;
      };
      # beszel-agent = {
      #   overrideCompose = ./docker/beszel-agent/prod.yaml;
      #   composeFile = ../../../docker/beszel/agent.yaml;
      #   sopsSecretFile = ./docker/beszel-agent/secrets.enc.env;
      # };
    };
  };

  system.activationScripts.error-pages-html = ''
    mkdir -p /var/lib/error-pages
    cp -f ${./docker/error-pages/html/404.html} /var/lib/error-pages/404.html
    cp -f ${./docker/error-pages/html/403.html} /var/lib/error-pages/403.html
    cp -f ${./docker/error-pages/nginx.conf} /var/lib/error-pages/nginx.conf
    chmod 644 /var/lib/error-pages/*.html /var/lib/error-pages/nginx.conf
  '';
}
