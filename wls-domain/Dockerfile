# ----------------------
# !!!!!!!!!!!!!!!!!!!!!
# I AM OF NO USAGE CURRENTLY
# !!!!!!!!!!!!!!!!!!!!!
# ----------------------
#
# Pull base image
# ---------------
FROM oracle/weblogic:12.1.3

# Maintainer
# ----------
MAINTAINER Luc Dew <lucdewinc@gmail.com>

ENV WLS_DOMAIN_DIR /opt/wlsdomains/mydomain
ENV COMMAND createDomain


USER root
ADD resources/* /opt/

RUN chown oracle:oracle /opt/*

USER oracle
WORKDIR /opt/wls

# For JAXRS2 support
RUN mv /opt/commEnv.sh /opt/wls/wlserver/common/bin/commEnv.sh
   
RUN find /opt/wls12130 -name "*.sh" -exec chmod a+x {} \;  && \
   /opt/start.sh

# Expose Node Manager default port, and also default http/https ports for admin console
EXPOSE 5556 7001 7002

# Make sure root has also right PATH and WLS environment variables configured
#USER root
#RUN echo ". $WLS_DOMAIN_DIR/bin/setDomainEnv.sh" >> /root/.bashrc && \
#    echo "export PATH=$PATH:/opt/wls/wlserver/common/bin:$WLS_DOMAIN_DIR/bin" >> /root/.bashrc

# Define default command to start bash.
#CMD ["$WLS_DOMAIN_DIR/bin/startWebLogic.sh"]
