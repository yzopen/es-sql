## 准备好所有的资源文件
[../images/]

## es-sql的容器构造过程1.0
-----
# base image
FROM elasticsearch:6.6.2
# MAINTAINER
MAINTAINER sunnywalden@gmail.com
ENV ES_HOME /usr/share/elasticsearch

RUN mkdir -p ${ES_HOME}/node
ADD node-v10.15.3-linux-x64 ${ES_HOME}/node
RUN ls -la ./node
ENV NODE_HOME ${ES_HOME}/node
ENV PATH ${NODE_HOME}/bin:$PATH:${ES_HOME}

RUN mkdir -p ${ES_HOME}/es-sql
COPY es-sql ${ES_HOME}/es-sql/

ADD elasticsearch-sql-6.6.2.0.zip /tmp
RUN ./bin/elasticsearch-plugin install file:///tmp/elasticsearch-sql-6.6.2.0.zip
USER root
WORKDIR ${ES_HOME}/es-sql/site-server
RUN npm install express --save
ADD elasticsearch.yml ${ES_HOME}/config/
ADD point.sh ${ES_HOME}/
RUN chown -R elasticsearch:elasticsearch ${ES_HOME}
RUN chmod u+x ${ES_HOME}/point.sh

USER elasticsearch
WORKDIR ${ES_HOME}
ENTRYPOINT ["point.sh"]
EXPOSE 9200
EXPOSE 9300
EXPOSE 8080
-----
## es-sql的容器构造过程1.1
在 Dockerfile 文件所在目录执行：
[root@hbase-phoenix es-sqly]# docker build -t elasticsearch-sql:6.6.2 .
命令最后有一个. 表示当前目录，，或者docker build  --no-cache -t elasticsearch-sql:6.6.2 .
构建完成之后，使用 docker images 命令查看所有镜像，如果存在 REPOSITORY 为 nginx 和 TAG 是 v1 的信息，就表示构建成功。
[root@hbase-phoenix es-sqly]# docker images
REPOSITORY                                    TAG                          IMAGE ID            CREATED             SIZE
elasticsearch-sql                             6.6.2                        829a51b69bea        15 seconds ago      1.23 GB
接下来使用 docker run 命令来启动容器
docker run  --name es-sql  -d -p 8080:8080 -p 9300:9300 -p 9200:9200 elasticsearch-sql:6.6.2
这条命令会用 nginx 镜像启动一个容器，命名为docker_nginx_v1，并且映射了 80 端口，这样我们可以用浏览器去访问这个 nginx 服务器：http://192.168.0.54/，页面返回信息：
docker run  --name es-sql  -p 8080:8080 -p 9300:9300 -p 9200:9200 elasticsearch-sql:6.6.2
## 查看本地镜像1.2
[root@hbase-phoenix es-sqly]# docker images
REPOSITORY                                    TAG                          IMAGE ID            CREATED             SIZE
elasticsearch-sql                             6.6.2                        829a51b69bea        14 minutes ago      1.23 GB
## 打tag镜像为851279676/es-sql:6.6.2
[root@hbase-phoenix es-sqly]# docker tag 829a51b69bea 851279676/es-sql:6.6.2
[root@hbase-phoenix es-sqly]# docker images
REPOSITORY                                    TAG                          IMAGE ID            CREATED             SIZE
elasticsearch-sql                             6.6.2                        829a51b69bea        36 minutes ago      1.23 GB
851279676/es-sql                              6.6.2                        829a51b69bea        36 minutes ago      1.23 GB
## 登陆远程仓库1.3
[root@hbase-phoenix es-sqly]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username (851279676): 851279676
Password: 
Login Succeeded
## 提交到远程仓库1.4
[root@hbase-phoenix es-sqly]# docker push 851279676/es-sql:6.6.2
The push refers to a repository [docker.io/851279676/es-sql]
d4f8ef7cc6d3: Pushed 
bcf825b7f6e5: Pushed 
7d60f76f493e: Pushed 
efafd6784b55: Pushed 
dd78f7c2e950: Pushed 
5b0e7b2d3e3f: Pushed 
86e2de0c9b9e: Pushed 
c2f6b1be338a: Pushed 
b941ae49a529: Pushed 
fca7d79bfc72: Pushed 
620859d5f93d: Pushed 
ed95fd8006d7: Mounted from library/elasticsearch 
893043adafbe: Mounted from library/elasticsearch 
d49eb1b97d3c: Mounted from library/elasticsearch 
4e46fe2301ba: Mounted from library/elasticsearch 
eba581f49a5d: Mounted from library/elasticsearch 
f82bc681981a: Mounted from library/elasticsearch 
071d8bd76517: Mounted from library/elasticsearch 
6.6.2: digest: sha256:5bd18563da2a2e5f67bfebcdcbe70b502caffd2033119d5a90978b5634253962 size: 4096
[root@hbase-phoenix es-sqly]# 

