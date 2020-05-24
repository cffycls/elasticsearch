#elasticsearch

官方配置参考：  
[https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docker.html](https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docker.html)  
[https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html)  
Elasticsearch具有三个配置文件：

- elasticsearch.yml 用于配置Elasticsearch
- jvm.options 用于配置Elasticsearch JVM设置
- log4j2.properties 用于配置Elasticsearch日志记录


```
sed -i "s/node1/es01/g" `grep node1 -rl ./`
:%s/es_master/es01/g
```

curl -X GET "localhost:9200/_cat/nodes?v&pretty"

bug fix1:
----
```
Could not register mbeans java.security.AccessControlException: access denied ("javax.management.MBeanTrustPermission" "register")
```
网络搜索是权限问题，docker环境docker:cffycls 1000，进入容器：
```
root@83996a979893:/usr/share/elasticsearch/data# id elasticsearch
uid=101(elasticsearch) gid=101(elasticsearch) groups=101(elasticsearch)
```
寻求以root权限下运行



