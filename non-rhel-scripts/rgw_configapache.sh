#!/bin/bash
export IPADDR=`ifconfig | grep "inet addr:" | grep Bcast | sed 's/^ *inet addr://' | sed 's/ .*//'`
if [ -e /etc/apt/sources.list ]; then
    export CONFFILE="/etc/apache2/apache2.conf"
else
    export CONFFILE="/etc/httpd/conf/httpd.conf"
fi
export FQDN=`hostname -f`
sudo ed ${CONFFILE} << EOF
$
a
ServerName $FQDN
.
w
q
EOF
if [ -e /etc/apt/sources.list ]; then
    sudo a2enmod rewrite
    sudo a2enmod fastcgi
    sudo service apache2 start
else
    sudo ed ${CONFFILE} << EOF
g/^Listen 80/s//Listen ${IPADDR}:80/
w
$
a
<IfModule !proxy_fcgi_module>
  LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
</IfModule>
.
w
q
EOF
    sudo service httpd start
fi
