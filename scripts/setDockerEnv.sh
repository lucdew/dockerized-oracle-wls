#!/bin/sh


TIMESTAMP=`date +%s`

#==========================
# ORACLE DB config
#==========================
#ORACLE_IMAGE_DIR=../oracle12c
#ORADB_VERSION="12.1.02"
#ORADB_VERSION_SHORT=`echo $ORADB_VERSION | sed 's/\.//g'`
#ORADB_PKG_VERSION="linuxamd64_${ORADB_VERSION_SHORT}"

ORACLE_IMAGE_DIR=../oracle11g
ORADB_VERSION="11.2.0.1"
ORADB_PKG_VERSION="linux.x64_11gR2"

ORADB_IMAGE_NAME="oracle/database:${ORADB_VERSION}"
ORACLE_SID="ORADB"
ORADB_CONTAINER_NAME=`echo $ORACLE_SID | tr '[:upper:]' '[:lower:]'`

DB_HOST_DIR="/mnt/sda1/${ORACLE_SID}"

#==========================
# WebLogic config
#==========================
#JAVA_VERSION="8u31"
JAVA_VERSION="7u75"
JAVA_PKG="jdk-${JAVA_VERSION}-linux-x64.rpm"

WLS_VERSION="1213"
WLS_PKG="wls${WLS_VERSION}_devzip_update1.zip"
WLS_IMAGE_NAME="oracle/weblogic:12.1.3"

#==========================
# WebLogic domain config
#==========================

WLS_DOMAIN_NAME=mydomain
WLS_DOMAINS_BASEDIR=/opt/wlsdomains
WLS_DOMAIN_DIR=${WLS_DOMAINS_BASEDIR}/${WLS_DOMAIN_NAME}
WLS_DOMAINS_HOST_BASEDIR=/mnt/sda1/wlsdomains


ADMIN_MEM_ARGS="-Xms256m -Xmx512m -XX:MaxPermSize=256m -Djava.security.egd=file:/dev/./urandom -Duser.timezone=CET"
ADMIN_CONTAINER_NAME="${WLS_DOMAIN_NAME}-Admin"

