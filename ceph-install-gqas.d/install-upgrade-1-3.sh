#! /usr/bin/bash
rm -rf /tmp/really_clean_up
./cleanup.sh
export CEPH_ISO=rhceph-1.3-rhel-7-x86_64-dvd.iso
./install-admin.sh 
