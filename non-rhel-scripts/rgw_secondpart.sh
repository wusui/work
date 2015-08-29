#! /bin/bash
if [ -e /etc/apt/sources.list ]; then
    sudo mkdir /var/www/html
    sudo touch /var/www/html/s3gw.fcgi
    sudo cp s3gw.fcgi /var/www/html/s3gw.fcgi
    sudo chmod +x /var/www/html/s3gw.fcgi
    sudo mkdir -p /var/lib/ceph/radosgw/ceph-radosgw.gateway
    sudo /etc/init.d/radosgw start
    sudo touch /etc/apache2/sites-available/rgw.conf
    sudo cp rgw.ubuntu.conf /etc/apache2/sites-available/rgw.conf
    sudo a2dissite 000-default
    sudo a2ensite rgw.conf
    sudo service apache2 restart
    sudo apt-get install python-boto -y
    sudo apt-get install python-setuptools -y
else
    sudo mkdir -p /var/lib/ceph/radosgw/ceph-radosgw.gateway
    sudo chown apache:apache /var/run/ceph
    sudo service ceph-radosgw start
    sudo chkconfig ceph-radosgw on
    sudo chown apache:apache /var/log/radosgw/client.radosgw.gateway.log
    sudo touch /etc/httpd/conf.d/rgw.conf
    sudo cp rgw.centos.conf /etc/httpd/conf.d/rgw.conf
    sudo service httpd restart
    sudo chkconfig httpd on
    sudo yum install python-boto -y
    sudo yum install python-setuptools -y
fi
sudo easy_install pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade python-swiftclient
./rgw_creates3.sh testuser s3 my
