{ config, pkgs, ... }:

{
  home-manager = {
    users = {
      michael = {
        home.file."bin/zabbix-up" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash

            pushd ~/zabbix-docker
            docker-compose -f docker-compose_v3_alpine_mysql_latest.yaml pull
            docker-compose -f docker-compose_v3_alpine_mysql_latest.yaml up -d
            pushd  
          '';
        };

        home.file."bin/zabbix-down" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash

            pushd ~/zabbix-docker
            docker-compose -f docker-compose_v3_alpine_mysql_latest.yaml down
            pushd  
          '';
        };
      };
    };
  };
}
