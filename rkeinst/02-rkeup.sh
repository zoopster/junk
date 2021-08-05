#!/bin/bash
set -x

cd /home/ec2-user/

# create cluster.yml
cat << EOF > cluster.yml
nodes:
  - address:
    internal_address:
    user: ec2-user
    role: [controlplane,etcd,worker]
addon_job_timeout: 120
EOF

# bring up rke
rke up --config cluster.yml
