#!/bin/bash

#
# Insecurely (truck-sized holes, we're talking about) set up a test cluster
# We assume that we have five vms available and locked. These are parameters
# $1 through $5.  The first machine will be a Calamari server, the second
# wil be Ceph monitor, and the rest will become OSD's (After ceph-deploy
# is run independently here).  This gets the calamari server key and
# saves it so that it can be set in the authorized_keys file for the
# Ceph machines.
#
# This also makes sure that yum.repos.d contains no epel configuration
# files for Centos and RHEL.
#

rm -rf auth_key
ssh $1.front.sepia.ceph.com sudo -u ceph ssh-keygen -N '' -f /home/ceph/.ssh/id_rsa
scp $1.front.sepia.ceph.com:.ssh/id_rsa.pub auth_key
scp ed-config.sh $1.front.sepia.ceph.com:ed-config.sh
ssh $1.front.sepia.ceph.com touch .ssh/config;
for x in $2 $3 $4 $5; do
    ssh $1.front.sepia.ceph.com ./ed-config.sh $x;
done
ssh $1.front.sepia.ceph.com chmod 0600 .ssh/config;
for x in $2 $3 $4 $5; do
   scp auth_key $x.front.sepia.ceph.com:auth_key;
   scp cali-ceph.sh $x.front.sepia.ceph.com:cali-ceph.sh;
   ssh $x.front.sepia.ceph.com ./cali-ceph.sh;
done
mver=`ssh $1 lsb_release -is | tr '[:upper:]' '[:lower:]'`
if [ $mver == 'centos' ] || [ $mver == 'redhatenterpriseserver' ] ; then
    rver=`ssh $1 lsb_release -rs`;
    if [[ $rver == 6* ]]; then
        for x in $1 $2 $3 $4 $5; do
            scp cleanrhelvm.sh $x.front.sepia.ceph.com:cleanrhelvm.sh;
            ssh $x.front.sepia.ceph.com sudo ./cleanrhelvm.sh -$rver;
        done;
    fi
    if [[ $rver == 7* ]]; then
        for x in $1 $2 $3 $4 $5; do
            ssh $x.front.sepia.ceph.com sudo rm -rf /etc/yum.repos.d/epel*
        done;
    fi
fi
