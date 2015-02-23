FROM centos
MAINTAINER MAINTAINER Luc Dew <lucdewinc@gmail.com>


# Environment variables required for this build (do NOT change)
ENV ORADB_VERSION 11.2.0.1
ENV ORADB_PKG_VERSION linux.x64_11gR2
ENV BIN_DIR binaries

# Groups
RUN groupadd oracle && \
    groupadd dba && \
    groupadd oinstall

# User oracle
RUN adduser -g oracle -G dba,oinstall oracle && \
    mkdir -p /opt/oracle/admin/orcl/adump && \
    mkdir -p /opt/oracle/fast_recovery_area && \
    chown -R oracle:oracle /opt/oracle

# Inventory directory
RUN mkdir /opt/oraInventory && \
    chown oracle:oinstall /opt/oraInventory

# Required packages
RUN yum install -y compat-libcap1 compat-libstdc++-33 libstdc++-devel gcc-c++ ksh make libaio-devel unzip 
# This one gives errors
RUN yum install -y sysstat; true


# Add install-time resources
ADD resources/install /home/oracle/
RUN chmod +x /home/oracle/bin/*
ADD ${BIN_DIR}/${ORADB_PKG_VERSION}_*.zip /home/oracle/


RUN cd /home/oracle && unzip ${ORADB_PKG_VERSION}_database_1of2.zip && unzip ${ORADB_PKG_VERSION}_database_2of2.zip && rm *.zip \
 && echo "ORACLE_BASE=/opt/oracle" >> /home/oracle/.bash_profile \
 && echo "ORACLE_HOME=\$ORACLE_BASE/product/${ORADB_VERSION}/dbhome_1" >> /home/oracle/.bash_profile  \
 && echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bash_profile


# Oracle uses /usr/bin/who -r to check runlevel. Because Docker doesn't have a runlevel,
# we need to fake it.
RUN mv /usr/bin/who /usr/bin/who.orig
RUN ln -s /home/oracle/bin/who /usr/bin/who

# Install Oracle database
USER oracle
RUN /home/oracle/bin/install.sh

# Post-installation scripts
USER root
RUN /home/oracle/bin/postinstall.sh

# Add run-time resources
ADD resources/run /home/oracle/
RUN chmod +x /home/oracle/bin/*

USER oracle
VOLUME /mnt/database
EXPOSE 1521
CMD ["/home/oracle/bin/start.sh"]
