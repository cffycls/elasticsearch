#!/bin/bash

## ERROR: Native controller process has stopped - no new native processes can be started
cat >> /etc/sysctl.conf <<EOF
vm.max_map_count = 655360
EOF
sysctl -p

cat >> /etc/security/limits.conf <<EOF
# cffycls是当前docker用户
cffycls soft nofile 65536
cffycls hard nofile 65536
cffycls soft nproc 4096
cffycls hard nproc 4096
EOF

cat >> /etc/security/limits.d/9200-nproc.conf <<EOF
# cffycls是当前docker用户
cffycls          soft    nproc     4096
root       soft    nproc     unlimited
EOF