#!/bin/sh
#
# Usage:
# -i : execute command in interactive mode
# $ wls.sh {createDomain|startAdmin | stopAdmin | startS <managed_server_name> | stopS <managed_server_name>}
#
# Since: January 2015, 2014
# Author: lucdewinc@gmail.com
# Description: script to start/stop oracle
#
SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*


showUsage() {
     echo "Usage: wls.sh [-h] {createDomain|startAdmin|stopAdmin }"
}

showHelp() {
      echo "Dockerized WebLogic domain command line tool"
      showUsage
      echo ""
      echo "Commands:"
      echo " createDomain : Creates the domain into "
      echo " startAdmin : Start the admin server"
      echo " stopAdmin : Stop the admin server"
}



while getopts ":ih" optname
do
   case "$optname" in
   "h")
      showHelp
      exit 0
   ;;
   "i")
      INTERACTIVE=true
   ;;
   \?)
      echo "error: invalid option $optname !"
      showUsage
      exit 1
   ;;
   esac
done

if [ -n "$INTERACTIVE" ] ; then
  DOCKER_OPTS="-ti"
else 
  DOCKER_OPTS="-d"
fi

shift $((OPTIND-1))

case "$1" in
  createDomain) 
     if [ ! -d "${WLS_DOMAINS_HOST_BASEDIR}" ] ; then
        sudo mkdir -p "${WLS_DOMAINS_HOST_BASEDIR}"
        sudo chown docker:staff "${WLS_DOMAINS_HOST_BASEDIR}"
     fi
     cp -f ../wls-domain/resources/* ${WLS_DOMAINS_HOST_BASEDIR}
     CMD="docker run -ti --rm=true --name mydomain -e WLS_DOMAIN_DIR=${WLS_DOMAIN_DIR} -v ${WLS_DOMAINS_HOST_BASEDIR}:${WLS_DOMAINS_BASEDIR} ${WLS_IMAGE_NAME} ${WLS_DOMAINS_BASEDIR}/create-wls-domain.sh"
     eval "$CMD"
     ;;
  startAdmin)
    shift 
    ADMIN_CONTAINER_RUNNING=$(docker inspect --format="{{ .State.Running }}" $ADMIN_CONTAINER_NAME 2> /dev/null)
    if [ $? -eq 1 ]; then
      CMD="docker run ${DOCKER_OPTS} --name ${ADMIN_CONTAINER_NAME} -e USER_MEM_ARGS=\"${ADMIN_MEM_ARGS}\" -p 7001:7001 -p 7002:7002 --link ${ORADB_CONTAINER_NAME}:oradb  -v ${WLS_DOMAINS_HOST_BASEDIR}:${WLS_DOMAINS_BASEDIR} ${WLS_IMAGE_NAME} ${WLS_DOMAIN_DIR}/startWebLogic.sh"
      echo "Executing $CMD"
      eval "$CMD"
    else
       if [ "$ADMIN_CONTAINER_RUNNING" = "false" ]; then
          echo ""
          docker start -ai $ADMIN_CONTAINER_NAME
       else
         echo "Admin server is already running"
      fi
    fi
    ;;
  stopAdmin)
    docker stop $ADMIN_CONTAINER_NAME 
    shift 
    ;;
  *)
    echo "error: invalid command $1 !"
    showUsage
    exit 1
   ;;
esac

exit 0
