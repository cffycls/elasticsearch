#!/bin/bash

#工具类
docker rm -f kibana
docker run -d --name kibana --restart=always \
    --net mybridge --ip=172.1.112.12 -p 5601:5601 \
    --log-driver json-file --log-opt max-size=100m --log-opt max-file=2 \
    -v /home/tools/elasticsearch/single/kibana.yml:/usr/share/kibana/config/kibana.yml \
    kibana:7.7.0
