{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    dockerComposeApp = {
      enable = lib.mkEnableOption "Enable multi-instance docker-compose app service";

      sopsAgeKeyFile = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        description = "Path to Age private key (e.g., /home/user/.config/sops/age/keys.txt). If null, sops-nix uses its defaults.";
      };

      networks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "External Docker networks to create before starting any instance.";
      };

      instances = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                composeFile = lib.mkOption {
                  type = lib.types.path;
                  default = ./docker-compose.yaml;
                  description = "Path to docker-compose.yaml (default: ./docker-compose.yaml).";
                };
                overrideCompose = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  default = null;
                  description = "Optional path to an override docker-compose YAML file. If set, it will be passed as a second -f argument.";
                };
                envFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  default = null;
                  description = "Optional path to .env. If null, no /etc/<instance>/.env will be created or passed to docker compose.";
                };
                sopsSecretFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  default = null;
                  description = "Optional encrypted dotenv secrets file (e.g., secrets.env.enc) managed by sops-nix. If null, no /etc/<instance>/secrets.env will be created or passed to docker compose.";
                };
              };
            }
          )
        );
        default = { };
        description = "Attribute set of docker-compose instances keyed by instance id.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.dockerComposeApp.enable {
      sops.age.sshKeyPaths = lib.mkIf (
        config.dockerComposeApp.sopsAgeKeyFile != null
      ) config.dockerComposeApp.sopsAgeKeyFile;

      environment.etc = lib.mkMerge (
        lib.attrValues (
          lib.mapAttrs (
            id: instCfg:
            let
              composeSrc = instCfg.composeFile or ./docker-compose.yaml;
              overrideEntry =
                if instCfg.overrideCompose != null then
                  { "${id}/docker-compose.override.yaml".source = instCfg.overrideCompose; }
                else
                  { };
              envEntry =
                if instCfg.envFile != null then
                  let
                    envCandidate = instCfg.envFile;
                    envSource =
                      if builtins.pathExists envCandidate then
                        envCandidate
                      else
                        pkgs.writeText ("docker-compose-env-" + id) "";
                  in
                  {
                    "${id}/.env".source = envSource;
                  }
                else
                  { };
            in
            lib.mkMerge [
              { "${id}/docker-compose.yaml".source = composeSrc; }
              overrideEntry
              envEntry
            ]
          ) config.dockerComposeApp.instances
        )
      );

      sops.secrets = lib.mkMerge (
        lib.attrValues (
          lib.mapAttrs (
            id: instCfg:
            if instCfg.sopsSecretFile != null then
              {
                "${id}-secrets" = {
                  sopsFile = instCfg.sopsSecretFile;
                  path = "/etc/${id}/secrets.env";
                  owner = "root";
                  group = "root";
                  mode = "0600";
                  format = "dotenv";
                };
              }
            else
              { }
          ) config.dockerComposeApp.instances
        )
      );

      systemd.services = lib.mkMerge [
        (lib.mkIf (config.dockerComposeApp.networks != [ ]) {
          docker-compose-networks = {
            description = "Create external Docker networks";
            after = [ "docker.service" ];
            requires = [ "docker.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = "yes";
            script = lib.concatMapStringsSep "\n" (net: ''
              ${pkgs.docker}/bin/docker network inspect ${net} >/dev/null 2>&1 \
                || ${pkgs.docker}/bin/docker network create ${net}
            '') config.dockerComposeApp.networks;
          };
        })
        (lib.mapAttrs' (
        id: instCfg:
        let
          flagsList = lib.filter (x: x != "") [
            (if instCfg.envFile != null then "--env-file /etc/${id}/.env" else "")
            (if instCfg.sopsSecretFile != null then "--env-file /etc/${id}/secrets.env" else "")
          ];
          envFlags = lib.concatStringsSep " " flagsList;
          composeFiles =
            "-f /etc/${id}/docker-compose.yaml"
            + (if instCfg.overrideCompose != null then " -f /etc/${id}/docker-compose.override.yaml" else "");
          composeCmd =
            "${pkgs.docker}/bin/docker compose ${composeFiles} "
            + (if envFlags == "" then "" else envFlags + " ")
            + "up -d";
          composeDownCmd =
            "${pkgs.docker}/bin/docker compose ${composeFiles} "
            + (if envFlags == "" then "" else envFlags + " ")
            + "down";
        in
        lib.nameValuePair ("docker-compose-" + id) {
          description = "Docker Compose " + id + " (up on start, down on stop)";
          after = [
            "network-online.target"
            "docker.service"
          ] ++ lib.optional (config.dockerComposeApp.networks != [ ]) "docker-compose-networks.service";
          requires = [
            "docker.service"
            "network-online.target"
          ] ++ lib.optional (config.dockerComposeApp.networks != [ ]) "docker-compose-networks.service";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = "yes";
            ExecStart = composeCmd;
            ExecStop = composeDownCmd;
            TimeoutStopSec = "120s";
          };
        }
      # ) config.dockerComposeApp.instances
      # //
      # lib.mapAttrs' (id: _:
      #   lib.nameValuePair ("docker-compose-" + id + "-logs") {
      #     description = "Logs for Docker Compose " + id;
      #     after = [ "docker-compose-${id}.service" ];
      #     bindsTo = [ "docker-compose-${id}.service" ];
      #     wantedBy = [ "docker-compose-${id}.service" ];
      #     serviceConfig = {
      #       ExecStart = "${pkgs.docker}/bin/docker compose -f /etc/${id}/docker-compose.yaml logs --follow --no-log-prefix";
      #       Restart = "on-failure";
      #       RestartSec = "3s";
      #       StandardOutput = "journal";
      #       StandardError = "journal";
      #       SyslogIdentifier = "docker-compose-${id}";
      #     };
      #   }
      ) config.dockerComposeApp.instances)
      ];

      virtualisation.docker.enable = true;
    })
  ];
}
