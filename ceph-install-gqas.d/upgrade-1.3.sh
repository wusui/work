#! /usr/bin/bash
#
CEPH_DEPLOY_MONS=${CEPH_DEPLOY_MONS:-"gqas005-priv"}
CEPH_DEPLOY_OSDS=${CEPH_DEPLOY_OSDS:-"gqas006-priv gqas007-priv"}
CEPH_DEPLOY_CLIENTS=${CEPH_DEPLOY_CLIENTS:-"gqac015-priv"}
for i in $CEPH_DEPLOY_MONS; do
    ./upgrade-mon.sh $i
done
for i in $CEPH_DEPLOY_OSDS; do
    ./upgrade-osd.sh $i
done
for i in $CEPH_DEPLOY_CLIENTS; do
    ./upgrade-clients.sh $i
done
