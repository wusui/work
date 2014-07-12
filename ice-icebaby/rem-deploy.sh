#!/bin/bash
scp deploy.sh $1.front.sepia.ceph.com:deploy.sh
ssh $1.front.sepia.ceph.com ./deploy.sh $2 $3 $4 $5
echo "=== DONE ==="
