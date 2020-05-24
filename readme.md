#elasticsearch

1、准备
====
官方配置参考：  
[https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docker.html](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docker.html)  
[https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html)  
Elasticsearch具有三个配置文件：

- elasticsearch.yml 用于配置Elasticsearch
- jvm.options 用于配置Elasticsearch JVM设置
- log4j2.properties 用于配置Elasticsearch日志记录


curl -X GET "localhost:9200/_cat/nodes?v&pretty"

2、运行
====
es.sh 开发者单机模式
× 集群测试暂未成功启动



