#!/bin/bash

docker rm -f es
# -p 9200:9200
docker run -d --name es --restart=always \
    --net mybridge --ip=172.1.111.12 \
    -v /home/tools/elasticsearch/single/data/:/usr/share/elasticsearch/data/ \
    -e "discovery.type=single-node" \
    elasticsearch:7.7.0

# 开发模式 -e "discovery.type=single-node"
# -v /home/tools/elasticsearch/single/etc/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \