#!/bin/bash

#
# Dan's script to clean up yum.repos for non epel testing.
#
RHELVER=${RHELVER:-6.4}
if [ $# -gt 1 ] ; then RHELVER=$1; fi

rm -vf /etc/yum.repos.d/*.repo
 
cat <<'EOF' > /etc/yum.repos.d/rhel6.repo
[rhel-6-repo]
name=My Red Hat Enterprise Linux $releasever - $basearch
baseurl=http://apt-mirror.front.sepia.ceph.com/rhel6repo/
gpgcheck=0
enabled=1
EOF
 
cat <<EOF > /etc/yum.repos.d/rhel6cd.repo
[rhel-6-cd]
name=My Red Hat Enterprise Linux \$releasever - \$basearch
baseurl=http://apt-mirror.front.sepia.ceph.com/rhel${RHELVER}_x86_64/
gpgcheck=0
enabled=1
EOF

yum clean all
yum makecache

