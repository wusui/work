#! /usr/bin/bash
CEPH_DEPLOY=${CEPH_DEPLOY:-"ceph-deploy"}
CEPH_DEPLOY_MONS=${CEPH_DEPLOY_MONS:-"gqas005-priv"}
CEPH_DEPLOY_OSDS=${CEPH_DEPLOY_OSDS:-"gqas006-priv gqas007-priv"}
CEPH_DEPLOY_DISKS=${CEPH_DEPLOY_DISKS:-"sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm"}
$CEPH_DEPLOY new $CEPH_DEPLOY_MONS
if [ $? -ne 0 ]; then echo 'Error deploy new mons'; fi
read text
$CEPH_DEPLOY install $CEPH_DEPLOY_MONS $CEPH_DEPLOY_OSDS
if [ $? -ne 0 ]; then echo 'Error installing mons or osds'; fi
$CEPH_DEPLOY mon create-initial
if [ $? -ne 0 ]; then echo 'Error creating initial mons'; fi
for i in $CEPH_DEPLOY_OSDS; do
    for dsk in $CEPH_DEPLOY_DISKS; do
        $CEPH_DEPLOY disk zap $i:$dsk
        if [ $? -ne 0 ]; then echo 'Error zapping disks'; fi
        sleep 2
        $CEPH_DEPLOY osd create $i:$dsk
        if [ $? -ne 0 ]; then echo 'Error creating disks'; fi
    done
done
x=`sudo ceph health`
while [[ $x == HEALTH_OK* ]]; do
    sleep 10
    x=`sudo ceph health`
done
