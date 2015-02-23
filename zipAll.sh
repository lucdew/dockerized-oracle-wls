#!/bin/sh
tar -cvf - . --exclude="./docker-install.exe" --exclude="./oracle11g/binaries" --exclude="./oracle12c/binaries" --exclude="weblogic12c/binaries" | gzip > dockerizing.tar.gz
