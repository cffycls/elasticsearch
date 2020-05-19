#!/bin/bash

docker rm -f es_test
docker run -d --name es_test \
	--net mybridge -p 9200:9200 \
	-e "discovery.type=single-node" elasticsearch


/etc/init.d/elasticsearch
