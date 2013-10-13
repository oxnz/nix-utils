#!/bin/bash

# ==============
# Config:
JRE_INSTALL_DIR=/usr/local/jdk1.7.0_09
MOZILLA_PLUGIN_DIR=/usr/lib/mozilla/plugins

echo '========================================================'
echo 'Downloading...'
#wget http://javadl.sun.com/webapps/download/AutoDL?BundleId=67387
#mv jre-1.7u0.jre jre.tar.gz
echo '--------------------------------------------------------'
echo 'Installing...'
tar -zxvf JRE_TGZ -C $JRE_INSTALL_DIR
echo '--------------------------------------------------------'
echo 'Configuring...'
sudo ln -s $MOZILLA_PLUGIN_DIR/ $JRE_INSTALL_DIR/jre/lib/i386/libnpjp2.so 
echo 'Success'
echo '========================================================'
