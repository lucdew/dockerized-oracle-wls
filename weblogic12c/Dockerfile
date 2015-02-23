# LICENSE CDDL 1.0 + GPL 2.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12.1.3 ZIP Distro
#
# REQUIRED BASE IMAGE TO BUILD THIS IMAGE
# ---------------------------------------
# Make sure you have oraclelinux:7.0 Docker image installed.
# Visit for more info: http://public-yum.oracle.com/docker-images/
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) wls1213_dev.zip
# Download from http://www.oracle.com/technetwork/middleware/weblogic/downloads/index.html
#
# (2) jdk-8u31-linux-x64.rpm
# or
# (2) jdk-8u75-linux-x64.rpm
# Download from http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the binaries directory under this Dockerfile
# Run:
# $ sudo docker build -t oracle/weblogic:12.1.3 .
#
# DOCKER SCRIPTS FOR BUILDING/RUNNING WEBLOGIC
# --------------------------------------------
# You can also use the scripts provided in the folder ../scripts to build and run WebLogic on Docker.
# Example building:
# $ ./buildWeblogicImage.sh
#
# Pull base image
# ---------------
FROM centos
# Maintainer
# ----------
MAINTAINER Luc Dew <lucdewinc@gmail.com>

# Environment variables required for this build (do NOT change)
ENV BIN_DIR binaries
#ENV JAVA_RPM jdk-8u31-linux-x64.rpm
ENV JAVA_RPM jdk-7u75-linux-x64.rpm
ENV WLS_PKG wls1213_devzip_update1.zip

# WLS Admin Password (you may change)
# This password is used for:
# (a) 'weblogic' admin user of WebLogic
# (b) 'oracle' Linux user in this image
# -----------------------------------
ENV ADMIN_PASSWORD welcome1

# Install and configure Oracle JDK 
# -------------------------------------
ADD $BIN_DIR/$JAVA_RPM /root/
RUN rpm -i /root/$JAVA_RPM && \
   rm /root/$JAVA_RPM
ENV JAVA_HOME /usr/java/default
ENV MW_HOME /opt/wls12130
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup filesystem and oracle user
# ------------------------------------------------------------
# Enable this if behind proxy
RUN chmod a+xr /opt && \
    useradd oracle && \
    echo oracle:$ADMIN_PASSWORD | chpasswd

#    useradd -m -s /bin/bash oracle && \
# Add files required to build this image
ADD ${BIN_DIR}/${WLS_PKG} /opt/

# Adjust file permissions, go to /opt as user 'oracle' to proceed with WLS installation
RUN chown oracle:oracle -R /opt
WORKDIR /opt
USER oracle

# Installation of Weblogic
RUN jar xf /opt/$WLS_PKG
RUN ln -s /opt/wls12130 /opt/wls && \
    chown oracle:oracle -R /opt && \
    rm /opt/${WLS_PKG} 

WORKDIR /opt/wls
RUN sh configure.sh -silent && \
    find  /opt/wls12130 -name "*.sh" -exec chmod a+x {} \;


