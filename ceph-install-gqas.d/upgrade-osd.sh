#! /usr/bin/bash
for i in $CEPH_DEPLOY_MONS; do 
    if [ ! $MON_ONE ];  then
        MON_ONE=$i
    fi
done
ssh $MON_ONE sudo ceph osd set noout
ssh $MON_ONE sudo ceph osd set noscrub
ssh $MON_ONE sudo ceph osd set nodeep-scrub
ssh $1 sudo /etc/init.d/ceph stop
ssh $1 sudo rm -rf /etc/yum.repos.d/ceph*
ssh $1 sudo yum -y erase ceph-mon
ceph-deploy install --repo --release=ceph-osd $1
ceph-deploy install --osd $1
ssh $1 sudo yum -y update
ssh $1 sudo /etc/init.d/ceph start
x=`ssh $MON_ONE sudo ceph health`
while [[ $x != HEALTH_WARN\ no* ]]; do
    echo $x
    sleep 30
    x=`ssh $MON_ONE sudo ceph health`
done
ssh $MON_ONE sudo ceph osd unset noout
ssh $MON_ONE sudo ceph osd unset noscrub
ssh $MON_ONE sudo ceph osd unset nodeep-scrub
sleep 30
ssh $MON_ONE sudo ceph health
