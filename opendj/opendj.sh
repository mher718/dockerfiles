#!/usr/bin/env bash
CONFIG_DIR=/var/container_data/ldap/config
DATA_DIR=/var/container_data/ldap/data

if [ -f ~/.docker_containers ]; then
    . ~/.docker_containers
fi


function initial {
if [ ! -d "$DATA_DIR" ]
 then
  mkdir -p $DATA_DIR
fi

if [ ! -d "$CONFIG_DIR" ]
 then
  mkdir -p $CONFIG_DIR
fi

ms_container_exists=$(docker ps -a | grep otlabs_ldap1)
if [ ! -z "$ms_container_exists" ]; then
  RUNNING=$(docker inspect --format="{{ .State.Running }}" otlabs_ldap1)
  [ $RUNNING = "true" ] && docker stop otlabs_ldap1
  docker rm otlabs_ldap1
fi

opendj_id=`docker run -d -h ld1.otlabs.fr -p 389:389 -p 636:636 -p 4444:4444 -p 8989:8989 -v $DATA_DIR:/data -v $CONFIG_DIR:/config --name otlabs_ldap1 registry.otlabs.fr/platform/opendj`

grep -sv ' opendj=' ~/.docker_containers > 1; mv 1 ~/.docker_containers
echo "export opendj='$opendj_id'" >> ~/.docker_containers
. ~/.docker_containers

echo $opendj_id
}


case $1 in
   start)
      docker start $opendj
      ;;
   stop)
      docker stop $opendj
      ;;
   restart)
      docker restart $opendj
      ;;
   init)
     initial
     ;;
   *)
     echo "$0 [init|start|stop|restart]"
    ;;
esac

