#!/bin/sh

SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"


configureUserEnv() {
    # Configure environment  user
    echo ". $WLS_DOMAIN_DIR/bin/setDomainEnv.sh" >> $HOME/.bashrc 
    echo "export MW_HOME=/opt/wls" >> $HOME/.bashrc
    echo "export PATH=\$PATH:/opt/wls/wlserver/common/bin:$WLS_DOMAIN_DIR/bin" >> $HOME/.bashrc
}


if [ ! -d ${WLS_DOMAIN_DIR} ]; then
  mkdir -p ${WLS_DOMAIN_DIR}
  configureUserEnv
fi

echo "Creating domain in $WLS_DOMAIN_DIR"

/opt/wls/wlserver/common/bin/wlst.sh -skipWLSModuleScanning ${SCRIPTS_DIR}/create-wls-domain.py

if [ $? -ne 0 ] ; then
   echo "WLST domain creation failed"
   exit 1
fi

mkdir -p $WLS_DOMAIN_DIR/servers/AdminServer/security

echo "username=weblogic" > $WLS_DOMAIN_DIR/servers/AdminServer/security/boot.properties
echo "password=$ADMIN_PASSWORD" >> $WLS_DOMAIN_DIR/servers/AdminServer/security/boot.properties 
