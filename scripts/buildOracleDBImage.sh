#!/bin/sh

SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*

DOCKER_DIR=${SCRIPTS_DIR}/${ORACLE_IMAGE_DIR}
BIN_DIR=${DOCKER_DIR}/binaries

# Validate Oracle Package
if [ ! -e "$BIN_DIR/${ORADB_PKG_VERSION}_database_1of2.zip " ]
then
  echo "====================="
  echo "Download the Oracle DB zip files"
  echo "drop the file ${ORADB_PKG_VERSION}_database_1of2.zip in the folder ${BIN_DIR}"
  echo "before building this Oracle Docker image!"
  exit
fi
if [ ! -e "$BIN_DIR/${ORADB_PKG_VERSION}_database_2of2.zip " ]
then
  echo "====================="
  echo "Download the Oracle DB zip files"
  echo "drop the file ${ORADB_PKG_VERSION}_database_2of2.zip in the folder ${BIN_DIR}"
  echo "before building this Oracle Docker image!"
  exit
fi
echo "====================="


# BUILD THE IMAGE
docker build --force-rm=true --no-cache=true --rm=true -t $ORADB_IMAGE_NAME ${DOCKER_DIR}
