#!/bin/sh
export MW_HOME=/opt/weblogic

configureOracleUserEnv {
    # Configure environment of oracle user
    echo ". $WLS_DOMAIN_DIR/bin/setDomainEnv.sh" >> /home/oracle/.bashrc 
    echo "export MW_HOME=/opt/wls" >> /home/oracle/.bashrc
    echo "export PATH=\$PATH:/opt/wls/wlserver/common/bin:$WLS_DOMAIN_DIR/bin" >> /home/oracle/.bashrc
}

createDomain {
  # Check if database already exists
  if [ -d ${WLS_DOMAIN_DIR} ]; then
    echo "Database already exists"
    exit 1
  else

    # Create the domain
    /opt/create-wls-domain.sh && configureOracleUserEnv

    exit $?
 fi
}

function startAdmin {
   $WLS_DOMAIN_DIR/bin/startWebLogic.sh
}

case "$COMMAND" in
  createDomain)
    createDomain
    ;;
  startAdmin)
    startAdmin
    ;;
  *)
    echo "Environment variable COMMAND must be {createDomain|startAdmin}, e.g.:"
    echo "  To create the Weblogic domain:"
    echo "  docker run -e COMMAND=createDomain -e WLS_DOMAIN_DIR=/opt/wlsdomains/mydomain --link db1:oradb oracle/weblogic:12.1.3"
    echo ""
    echo "  To start the administration server:"
    echo "  docker run -e COMMAND=startAdmin -e WLS_DOMAIN_DIR=/opt/wlsdomains/mydomain --link db1:oradb --name admin -p 7001 -p 7002 oracle/weblogic:12.1.3"
    echo ""
    exit 1
    ;;
esac

