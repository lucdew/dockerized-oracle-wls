#!/bin/sh
#
# Usage:
# $ oracle.sh oracle.sh [-h] {initdb|start|sqlplus|runsql|sqlplusremote <oracle_user> <oracle_password>}
#
# Since: January 2015, 2014
# Author: lucdewinc@gmail.com
# Description: control script of a dockerized Oracle DB instance
#
SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*


showUsage() {
     echo "Usage: oracle.sh [-h] {initdb|start|sqlplus|runsql|sqlplusremote <oracle_user> <oracle_password>}"
}

showHelp() {
      echo "Dockerized Oracle DB command line tool"
      showUsage
      echo ""
      echo "Commands:"
      echo " initdb : Creates the database into ${DB_HOST_DIR}"
      echo " start : Start the database ${ORACLE_SID} with listener export on port 1521"
      echo " sqlplus : Start interactive sqlplus session as sysdba"
      echo " runsql : Execute all *.sql scripts of /tmp/sql "
}

while getopts ":h" optname
do
   case "$optname" in
   "h")
      showHelp
      exit 0
   ;;
   \?)
      echo "error: unsupported option !"
      showUsage
      exit 1
   ;;
   esac
done

shift $((OPTIND-1))

case "$1" in
  initdb)
    if [ ! -d "$DB_HOST_DIR" ] ; then
       sudo mkdir $DB_HOST_DIR
       sudo chown docker:staff $DB_HOST_DIR
    fi
    CMD="docker run --rm=true -e COMMAND=initdb -e ORACLE_SID=${ORACLE_SID} -v $DB_HOST_DIR:/mnt/database ${ORADB_IMAGE_NAME}"
    shift 
    ;;
  sqlplus)
    shift 
    if [ "$#" -eq 2 ] ; then
       ORACLE_USER=$1
       ORACLE_PWD=$2
       shift 2
    else
       ORACLE_USER="system"
       ORACLE_PWD="password"
    fi
    CMD="docker run --rm=true -it -e COMMAND=sqlplusremote -e ORACLE_SID=${ORACLE_SID} -e ORACLE_USER=\"${ORACLE_USER}\" -e ORACLE_PASSWORD=\"${ORACLE_PWD}\" --link ${ORADB_CONTAINER_NAME}:remotedb -P ${ORADB_IMAGE_NAME}"
    ;;
  start)
    CMD="docker run -d -e COMMAND=rundb -e ORACLE_SID=${ORACLE_SID} -v ${DB_HOST_DIR}:/mnt/database -p 1521:1521 --name ${ORADB_CONTAINER_NAME} ${ORADB_IMAGE_NAME}"
    shift 
    ;;
  runsql)
    shift 
    if [ "$#" -eq 2 ] ; then
       ORACLE_USER=$1
       ORACLE_PWD=$2
       shift 2
    else
       ORACLE_USER="system"
       ORACLE_PWD="password"
    fi
    CMD="docker run --rm=true -it -e COMMAND=runsqlremote -e ORACLE_SID=${ORACLE_SID} -e ORACLE_USER=\"${ORACLE_USER}\" -e ORACLE_PASSWORD=\"${ORACLE_PWD}\" -v /tmp/sql:/mnt/sql  --link ${ORADB_CONTAINER_NAME}:remotedb -P ${ORADB_IMAGE_NAME}"
    ;;
  *)
    echo "error: command not specified !"
    showUsage
    exit 1
   ;;
esac

echo "Executing $CMD"
eval "$CMD"

