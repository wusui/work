#!/bin/bash
tar xvf tarfile
./rgw_getapache.sh
./rgw_configapache.sh
./rgw_enablessl.sh
./rgw_createkeyring.sh
./rgw_addgateway.sh
