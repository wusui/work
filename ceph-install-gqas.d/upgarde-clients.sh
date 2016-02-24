#! /usr/bin/bash
#
sudo yum -y erase librados2
CEPH_ISO=${CEPH_ISO:-"rhceph-1.3-rhel-7-x86_64-dvd.iso"}
CEPH_HOSTNAME=`hostname`
sudo umount /mnt
sudo mount -o loop $CEPH_ISO /mnt
sudo yum -y install /mnt/OSD/ceph-common*.rpm
