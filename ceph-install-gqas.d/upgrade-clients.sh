#! /usr/bin/bash
#
sudo yum -y erase librados2
CEPH_ISO=${CEPH_ISO:-"rhceph-1.3-rhel-7-x86_64-dvd.iso"}
sudo umount /mnt
sudo mount -o loop $CEPH_ISO /mnt
sudo yum -y update
sudo yum -y install /mnt/OSD/librados2* /mnt/OSD/librbd1* /mnt/OSD/python-rados* /mnt/OSD/python-rbd* /mnt/OSD/ceph-common*.rpm
