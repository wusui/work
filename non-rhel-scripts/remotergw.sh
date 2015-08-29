#!/bin/bash
tar cvf tarfile ./rgw_* ./getinfo* ./rgw.*.conf ./s3gw.fcgi
scp tarfile $2.front.sepia.ceph.com:.
scp rgw_part1.sh $2.front.sepia.ceph.com:.
ssh $2.front.sepia.ceph.com ./rgw_part1.sh
rm -rf tarfile
ssh $1.front.sepia.ceph.com ceph-deploy --overwrite-conf config pull $2
ssh $1.front.sepia.ceph.com ceph-deploy --overwrite-conf config push $2
ssh $2.front.sepia.ceph.com ./rgw_secondpart.sh
