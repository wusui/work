#!/bin/bash
export FQDN=`hostname -f`
sudo radosgw-admin user create --uid="${1}" --display-name="First User" > /tmp/s3-${1}
sudo radosgw-admin subuser create --uid=${1} --subuser=${1}:swift --access=full
sudo radosgw-admin key create --subuser=${1}:swift --key-type=swift --gen-secret > /tmp/swift-${1}
python getinfo.py /tmp/s3-${1} > /tmp/pyout1-${1}
export ACCESS=`head -1 /tmp/pyout1-${1}`
export SECRET=`tail -1 /tmp/pyout1-${1}`
touch ${2}test.py
ed ${2}test.py <<EOF
a
import boto
import boto.s3.connection
access_key = '$ACCESS'
secret_key = '$SECRET'
conn = boto.connect_s3(
aws_access_key_id = access_key,
aws_secret_access_key = secret_key,
host = '$FQDN',
is_secure=False,
calling_format = boto.s3.connection.OrdinaryCallingFormat(),
)
bucket = conn.create_bucket('${3}-new-bucket')
for bucket in conn.get_all_buckets():
    print "{name}\t{created}".format(
        name = bucket.name,
        created = bucket.creation_date,
)
.
w
q
EOF
python ${2}test.py
export IPADDR=`/sbin/ifconfig | grep "inet addr:" | grep Bcast | sed 's/^ *inet addr://' | sed 's/ .*//'`
export SWIFTP=`python getinfo1.py /tmp/swift-${1}`
echo $IPADDR
echo $SWIFTP
sleep 30
swift -A http://${IPADDR}/auth/1.0 -U ${1}:swift -K '${SWIFTP}' list

