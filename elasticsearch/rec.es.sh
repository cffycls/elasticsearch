#!/bin/bash

docker rm -f es01 es02 es03  
docker run -d --name es01 \
	--net mybridge -p 9200:9200 --ip=172.1.13.11 \
	-v /opt/centos8/elasticsearch/es01/etc/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
	-v /opt/centos8/elasticsearch/es01/data/:/usr/share/elasticsearch/data/ \
	elasticsearch 
        #/docker-entrypoint.sh


docker run -d --name es02 \
        --net mybridge --ip=172.1.13.12 \
        -v /opt/centos8/elasticsearch/es02/etc/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
        -v /opt/centos8/elasticsearch/es02/data/:/usr/share/elasticsearch/data/ \
        elasticsearch 
        #/docker-entrypoint.sh


docker run -d --name es03 \
        --net mybridge --ip=172.1.13.13 \
        -v /opt/centos8/elasticsearch/es03/etc/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
        -v /opt/centos8/elasticsearch/es03/data/:/usr/share/elasticsearch/data/ \
        elasticsearch 
        #/docker-entrypoint.sh
