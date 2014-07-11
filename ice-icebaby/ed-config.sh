#!/bin/bash

#
# Add an entry to the .ssh/config file on the Calamari server
# This script is copied to the server and run there.
#

x=$1
tee -a .ssh/config << EOF
Host $x
   Hostname $x
   User ceph
EOF
