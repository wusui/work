#!/bin/bash
export FQDN=`hostname -f`
if [ -e /etc/apt/sources.list ]; then
    sudo apt-get install openssl ssl-cert -y
    sudo a2enmod ssl
    sudo mkdir /etc/apache2/ssl
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt << EOF
us
ca
la
redhat
storage
$FQDN
wusui@redhat.com
EOF
    sudo service apache2 restart
    sudo apt-get install radosgw -y
    sudo apt-get install radosgw-agent -y
else
    sudo yum install mod_ssl openssl -y
    openssl genrsa -out ca.key 2048
    openssl req -new -key ca.key -out ca.csr << EOF
us
ca
la
redhat
storage
$FQDN
wusui@redhat.com
redhat
redhat
EOF
    openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
    sudo cp ca.crt /etc/pki/tls/certs
    sudo cp ca.key /etc/pki/tls/private/ca.key
    sudo cp ca.csr /etc/pki/tls/private/ca.csr
    sudo ed /etc/httpd/conf.d/ssl.conf << EOF
g/^SSLCertificateFile .*/s//SSLCertificateFile \/etc\/pki\/tls\/certs\/ca.crt/
g/^SSLCertificateKeyFile .*/s//SSLCertificateKeyFile \/etc\/pki\/tls\/private\/ca.key/
w
q
EOF
    sudo service httpd restart
    sudo yum install ceph-radosgw -y
    sudo yum install radosgw-agent -y
fi
