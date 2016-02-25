Ceph install scripts developed for a project with Ben England and Ben Turner

install-admin.sh yum installs ice_setup and runs ice_setup to initialize the admin node and install ceph-deploy

install-1-2-3.sh installs a 1.2.3 cluster

install-upgrade-1-3.sh installs a 1.3 cluster

upgrade-1.3.sh upgrades to 1.3.  It calls upgrade-mon.sh, upgrade-osd.sh, and upgrade-clients.sh

The general workflow here is:
- export CEPH_DEPLOY_MON="list of mon hosts"
- export CEPH_DEPLOY_OSD="list of osd hosts"
- export CEPH_DEPLOY_CLIENTS="list of client nodes"
- export CEPH_DEPLOY_DISKS="list of disks (sdb sdc sdd...)"
- ./install-admin.sh                  # install the 1.2.3 iso
- ./install-1.2.3.sh                # install ceph
- .
- .
- .
- ./install-upgrade-1-3.sh                                   # install the 1.3 iso
- ./upgrade-1.3.sh                                   # upgrade each mon and osd individually.
  
