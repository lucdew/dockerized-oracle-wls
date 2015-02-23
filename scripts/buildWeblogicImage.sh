#!/bin/sh

SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"
. $SCRIPTS_DIR/setDockerEnv.sh $*

DOCKER_DIR=${SCRIPTS_DIR}/../weblogic12c
BIN_DIR=${DOCKER_DIR}/binaries

# Validate WLS Package
if [ ! -e "$BIN_DIR/${JAVA_PKG}" ]
then
  echo "====================="
  echo "Download the Java JDK rpm"
  echo "drop the file ${JAVA_PKG} in the folder ${BIN_DIR}"
  echo "before building this WebLogic Docker image!"
  exit
fi
if [ ! -e "$BIN_DIR/${WLS_PKG} " ]
then
  echo "====================="
  echo "Download the WebLogic developer zip file"
  echo "drop the file ${WLS_PKG} in the folder ${BIN_DIR}"
  echo "before building this WebLogic Docker image!"
  exit
fi
echo "====================="


# BUILD THE IMAGE
docker build --force-rm=true --no-cache=true --rm=true -t $WLS_IMAGE_NAME ${DOCKER_DIR}
