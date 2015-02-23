# dockerized-oracle-wls

WebLogic and Oracle DB on docker
=======================


## Disclaimer

* WebLogic Docker file has been inspired by the WebLogic community docker : https://github.com/weblogic-community/weblogic-docker
* Oracle DB docker files have been inspired by the following Oracle Docker file : https://github.com/rhopman/docker-oracle-12c

## Description
 

 This repo provides:
 * Oracle DB (11g and 12c) Docker files to build Oracle DB image (CentOS based)
 * WebLogic 12c Docker file with only the binaries (CentOS based)
 * Some scripts to create a database and execute sqlplus. The Oracle DB instance runs in a container but the
   Oracle DB instance files are created on the host not in a container
 * Some scriptsto create a WebLogic domain (on the host) and start the admin server in a container. 
 
 It is meant to set up quickly a dev environment with WebLogic and Oracle DB in a boot2docker virtualbox vm.
 No support is given, I committed it just as a basis to do more advanced stuff

 Note that the scripts are meant for boot2docker since they create some directories on the host using sudo and assigning them to the docker user
 of group staff. A boot2docker profile is provided.



## Building

### boot2docker (not required)


* Once installed execute the Windows command file boot2docker/boot2docker.cmd. It will install a profile in your home directory and download the 1.5.0 iso 
* Create the vm:
```
boot2docker init
```
* Start it
```
boot2docker start
```
* SSH into it
```
boot2docker ssh
```

Then use the shared directory with your Windows host (/c/Users) to navigate to the directory where you checked out this repository


### Oracle 11G
* Create a `<SRC_DIR>`/oracle11g/binaries folder
* Download from OTN the Oracle 11.2.0.1 zip files (linux.x64_11gR2_database_1of2.zip and linux.x64_11gR2_database_2of2.zip) for Linux x64 and copy them into the oracle11g/binaries

* In boot2docker terminal, go to scripts directory and execute
```
$ ./buildOracleImage.sh
```

### WebLogic 12c
* Create the `<SRC_DIR>`/weblogic12c/binaries folder
* Download the java7 jdk for Linux x64 jdk-7u75-linux-x64.rpm and copy it in the just created binaries folder (or java8 but you need to update the weblogic12c/Dockerfile & scripts/setDockerEnv.sh)
* Download the weblogic 12.1.3 dev zip file wls1213_devzip_update1.zip and copy it in the just created binaries folder

* In boot2docker terminal, go to scripts directory and execute
```
$ ./buildWebLogic.sh
```

## Operations

* In boot2docker terminal, go to scripts directory 

### Oracle DB creation
```
$ ./oracle.sh initdb
```
### Oracle DB start
```
$ ./oracle.sh start
```
* Port 1521 is exposed (on ip `boot2docker ip`)

### Oracle DB sqlplus as sysdba
```
$ ./oracle.sh sqlplus
```
### Weblogic domain creation
```
$ ./wls.sh createDomain
```
An Oracle DB datasource is created in the domain 
### Weblogic start administration server
```
$ ./wls.sh startAdmin
```
* Port 7001 is exposed (on ip `boot2docker ip`)

## Misc

Configuration parameters are in the scripts/**setDockerEnv.sh** file
