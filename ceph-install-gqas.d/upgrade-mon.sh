#! /usr/bin/bash
#
ssh $1 sudo rm -rf /etc/yum.repos.d/ceph*.repo /etc/yum.repos.d/calamari*.repo
ssh $1 sudo /etc/init.d/ceph stop
ssh $1 sudo yum -y erase ceph-osd
ceph-deploy install --repo --release=ceph-mon $1
ceph-deploy install --mon $1
ssh $1 sudo /etc/init.d/ceph start
x=`ssh $1 sudo ceph health`
while [[ $x != HEALTH_OK* ]]; do
    echo $x
    sleep 10
    x=`ssh $1 sudo ceph health`
done
ssh $1 sudo ceph quorum-status --format json-pretty
sleep 20
