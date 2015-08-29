#!/bin/bash
export SNAME=`hostname -s`
if [ -e /etc/apt/sources.list ]; then
    sudo ed /etc/ceph/ceph.conf << EOF
$
a
[client.radosgw.gateway]
host = $SNAME
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw socket path = /var/run/ceph/ceph.radosgw.gateway.fastcgi.sock
log file = /var/log/radosgw/client.radosgw.gateway.log
.
w
q
EOF
else
    sudo ed /etc/ceph/ceph.conf << EOF
$
a
[client.radosgw.gateway]
host = $SNAME
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw socket path = ""
log file = /var/log/radosgw/client.radosgw.gateway.log
rgw frontends = fastcgi socket_port=9000 socket_host=0.0.0.0
rgw print continue = false
.
w
q
EOF
fi
