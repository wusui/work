scp auth_key $1.front.sepia.ceph.com:auth_key
scp cali-ceph.sh $1.front.sepia.ceph.com:cali-ceph.sh
ssh $1.front.sepia.ceph.com ./cali-ceph.sh
