#!/bin/bash
if [ -e /etc/apt/sources.list ]; then
    export VERS=`lsb_release -cs`
    sudo  sed -i "/$VERS multiverse/s/^# //g" /etc/apt/sources.list
    sudo  sed -i "/$VERS-updates multiverse/s/^# //g" /etc/apt/sources.list
    sudo apt-get update -y
    sudo apt-get install apache2 libapache2-mod-fastcgi -y
else
    sudo yum install httpd -y
    sudo yum install mod_proxy_fcgi -y
fi
