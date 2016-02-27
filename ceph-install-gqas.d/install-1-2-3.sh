#! /usr/bin/bash
#
# CEPH_DEPLOY defaults to the ceph-deploy command.
# CEPH_DEPLOY_MONS is the list of osd nodes.
# CEPH_DEPLOY_OSDS is the list of osd nodes.
# CEPH_DEPLOY_DISKS is the list of disks on each osd.
#
# Assumption: All OSDs have the same number of disks and these disks have
# the same dev names.
#
# export CEPH_XXX='<What you want>' can be used to change any of the these
# values.
#
CEPH_DEPLOY=${CEPH_DEPLOY:-"ceph-deploy"}
CEPH_DEPLOY_MONS=${CEPH_DEPLOY_MONS:-"gqas005-priv"}
CEPH_DEPLOY_OSDS=${CEPH_DEPLOY_OSDS:-"gqas006-priv gqas007-priv"}
CEPH_DEPLOY_DISKS=${CEPH_DEPLOY_DISKS:-"sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm"}
$CEPH_DEPLOY new $CEPH_DEPLOY_MONS
if [ $? -ne 0 ]; then echo 'Error deploy new mons'; fi
# These next two lines are needed if you want to fix chooseleaf in ceph.conf
#echo "edit ceph.conf now:"
#read text
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
for i in $CEPH_DEPLOY_MONS; do 
    if [ ! $MON_ONE ];  then
        MON_ONE=$i
    fi
done
for i in $CEPH_DEPLOY_OSDS; do
    ssh $i sudo /etc/init.d/ceph stop
    sleep 2
    ssh $i sudo /etc/init.d/ceph start
done
x=`ssh $MON_ONE sudo ceph health`
while [[ $x != HEALTH_OK* ]]; do
    echo $x
    sleep 10
    x=`ssh $MON_ONE sudo ceph health`
done
