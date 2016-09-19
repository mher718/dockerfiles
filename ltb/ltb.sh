#!/usr/bin/env bash
CONFIG_DIR=/var/container_data/ltb/conf

if [ -f ~/.docker_containers ]; then
    . ~/.docker_containers
fi


function initial {

if [ ! -d "$CONFIG_DIR" ]
 then
  mkdir -p $CONFIG_DIR
fi


ms_container_exists=$(docker ps -a | grep otlabs_ssp)
if [ ! -z "$ms_container_exists" ]; then
  RUNNING=$(docker inspect --format="{{ .State.Running }}" otlabs_ssp)
  [ $RUNNING = "true" ] && docker stop otlabs_ssp
  docker rm otlabs_ssp
fi

ltb_id=`docker run -d -h ssp.otlabs.fr -p 80:80 -v $CONFIG_DIR:/usr/share/self-service-password/conf --name otlabs_ssp registry.otlabs.fr/platform/ltb-ssp /usr/sbin/apache2ctl -D FOREGROUND`

grep -sv ' ltb=' ~/.docker_containers > 1; mv 1 ~/.docker_containers
echo "export ltb='$ltb_id'" >> ~/.docker_containers
. ~/.docker_containers

echo $ltb_id
}


case $1 in
   start)
      docker start $ltb
      ;;
   stop)
      docker stop $ltb
      ;;
   restart)
      docker restart $ltb
      ;;
   init)
     initial
     ;;
   *)
     echo "$0 [init|start|stop|restart]"
    ;;
esac

