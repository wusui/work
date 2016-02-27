#! /usr/bin/bash
if [ -e /tmp/really_clean_up ]; then
    ceph-deploy purge $CEPH_DEPLOY_MONS $CEPH_DEPLOY_OSDS
    ceph-deploy purgedata $CEPH_DEPLOY_MONS $CEPH_DEPLOY_OSDS
fi
sudo rm -rf /etc/yum.repos.d/*alamari*repo /etc/yum.repos.d/ceph-deploy.repo /etc/yum.repos.d/Installer.repo 
sudo yum -y erase ceph-deploy calamari calamari-server ice_setup
sudo yum -y erase openpgm python-jinja2 python-crypto python-msgpack sshpass python-meld python-meld3q
sudo rm -rf /var/cache/yum/x86_64/7Server/calamari
sudo rm -rf /var/cache/yum/x86_64/7Server/ceph_deploy
# sudo rm -rf /var/cache/yum/x86_64/7Server/rhel-lb-for-rhel-7-server-htb-rpms
sudo rm -rf /opt/ICE/Installer/
sudo rm -rf /opt/ICE/Calamari/
if [ -e /tmp/really_clean_up ]; then
    sudo rm -rf ceph.*
    sudo rm -rf cephdeploy.conf
fi
