#!/bin/bash

# es-head前端显示
docker rm -f es-m
docker run -d --name es-m \
    -p 9100:9100 \
    --network=mybridge \
    docker.io/mobz/elasticsearch-head:5-alpine
