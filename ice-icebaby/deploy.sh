#!/bin/bash

#
# Do ceph-deploys for this cluster
#

ceph-deploy new $1
ceph-deploy install $1 $2 $3 $4
ceph-deploy mon create $1
ceph-deploy gatherkeys $1
ceph-deploy disk zap $2:vdd
ceph-deploy osd prepare $2:vdd
ceph-deploy osd activate $2:vdd1
ceph-deploy disk zap $3:vdd
ceph-deploy osd prepare $3:vdd
ceph-deploy osd activate $3:vdd1
ceph-deploy disk zap $4:vdd
ceph-deploy osd prepare $4:vdd
ceph-deploy osd activate $4:vdd1

