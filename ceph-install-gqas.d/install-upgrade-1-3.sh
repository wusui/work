#! /usr/bin/bash
sudo rm -rf /etc/yum.repos.d/*alamari*repo /etc/yum.repos.d/ceph-deploy.repo /etc/yum.repos.d/Installer.repo 
sudo yum -y erase ceph-deploy calamari calamari-server erase ice_setup
sudo yum -y erase openpgm python-jinja2 python-crypto python-msgpack sshpass python-meld python-meld3q
export CEPH_ISO=rhceph-1.3-rhel-7-x86_64-dvd.iso
./install-admin.sh 
