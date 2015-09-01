#!/bin/bash
export IPADDR=`/sbin/ifconfig | grep "inet addr:" | grep Bcast | sed 's/^ *inet addr://' | sed 's/ .*//'`
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
    sudo chmod 0777 ${CONFFILE}
    ed ${CONFFILE} << EOF
/^Listen 
.d
.i
Listen ${IPADDR}:80
.
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
    sudo chmod 0644 ${CONFFILE}
    sudo service httpd start
fi
