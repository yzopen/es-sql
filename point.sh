#!/bin/bash
echo "start es-sql。。。。。。。。。。。"
cd /usr/share/elasticsearch/es-sql/site-server/
node node-server.js &
echo "start es"
/usr/share/elasticsearch/bin/elasticsearch
#nohup sh -c '/usr/share/elasticsearch/bin/elasticsearch && cd /usr/share/elasticsearch/es-sql/site-server/ && node node-server.js &'
