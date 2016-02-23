#! /usr/bin/bash
#
# Install an iso and a ceph-deploy command using ice_setup
#
# CEPH_ISO is the iso to install.  Can be overridden with an
# export CEPH_ISO=foo.iso command.
#
CEPH_ISO=${CEPH_ISO:-"rhceph-1.2.3-rhel-7-x86_64.iso"}
CEPH_HOSTNAME=`hostname`
mount -o loop $CEPH_ISO /mnt
CEPH_ICE_SETUP=/mnt
if [ -e /mnt/Installer ]; then
    CEPH_ICE_SETUP=/mnt/Installer
fi
yum -y install $CEPH_ICE_SETUP/ice_setup*
ice_setup -d /mnt << EOF
yes
/mnt
$CEPH_HOSTNAME
http
EOF
