#!/bin/bash
rel=`ssh $1 lsb_release -rs`
iso=`~/test-isos/selector.sh $rel`
fulliso=`echo ~/test-isos/$iso`
scp $fulliso $1:.
ssh $1 sudo mount -o loop ./rhceph* /mnt
vers=`ssh $1 lsb_release -is`
cmd=dpkg
if [ $vers == 'CentOS' ]; then
    cmd=rpm
fi
ssh $1 sudo $cmd -i /mnt/ice*
ssh $1 sudo ice_setup -d /mnt <<EOF
y
/mnt
$1
http
EOF
