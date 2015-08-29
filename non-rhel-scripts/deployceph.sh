#!/bin/bash
ceph-deploy new $1
ed ceph.conf <<EOF
$
.d
a
osd crush chooseleaf type = 0

.
w
q
EOF
ceph-deploy install $1
ceph-deploy mon create-initial $1
ceph-deploy disk zap $1:vdb
ceph-deploy disk zap $1:vdc
ceph-deploy disk zap $1:vdd
ceph-deploy osd create $1:vdb
ceph-deploy osd create $1:vdc
ceph-deploy osd create $1:vdd

