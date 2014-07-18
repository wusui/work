#!/bin/bash

#
# Create ceph user, and then create an authorized_keys entry using the
# Calamari server key.
#
# This script is copied (along with the calamari server key) to the remote
# machines on which ceph will run.
#
# This is just a test script.  Only to be used on test systems.  It's
# insecure as all get-out.
#

#echo ',s/requiretty/\!requiretty/; w' | tr \; '\012' | sudo ed -s /etc/sudoers
sudo useradd -d /home/ceph -m ceph
sudo passwd ceph
#echo -e "admin\nadmin" | (sudo passwd --stdin ceph)
echo "ceph ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph
sudo chmod 0440 /etc/sudoers.d/ceph
xvers=`lsb_release -is | tr '[:upper:]' '[:lower:]'`
if [ $xvers == 'centos' ] || [ $xvers == 'redhatenterpriseserver' ] ; then
    sudo yum -y install openssh-server;
else
    sudo apt-get -y install openssh-server;
fi
sudo -u ceph ssh-keygen -N '' -f /home/ceph/.ssh/id_rsa
cat auth_key | sudo -u ceph tee /home/ceph/.ssh/authorized_keys
sudo chmod 0600 /home/ceph/.ssh/authorized_keys
