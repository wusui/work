#!/bin/bash
./getiso.sh $1.front.sepia.ceph.com
scp ./deployceph.sh $1.front.sepia.ceph.com:.
ssh $1.front.sepia.ceph.com ./deployceph.sh $2
