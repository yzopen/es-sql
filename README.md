


## 准备好所有的资源文件
![Image](https://github.com/yzopen/es-sql/blob/master/images/file.bmp)

## es-sql的容器构造过程
```shell
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
```
## 1.0.es-sql的容器构造过程1.1
```shell
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
```
## 1.1.查看本地镜像
```shell
[root@hbase-phoenix es-sqly]# docker images
REPOSITORY                                    TAG                          IMAGE ID            CREATED             SIZE
elasticsearch-sql                             6.6.2                        829a51b69bea        14 minutes ago      1.23 GB
```
## 1.2.打tag镜像为851279676/es-sql:6.6.2
```shell
[root@hbase-phoenix es-sqly]# docker tag 829a51b69bea 851279676/es-sql:6.6.2
[root@hbase-phoenix es-sqly]# docker images
REPOSITORY                                    TAG                          IMAGE ID            CREATED             SIZE
elasticsearch-sql                             6.6.2                        829a51b69bea        36 minutes ago      1.23 GB
851279676/es-sql                              6.6.2                        829a51b69bea        36 minutes ago      1.23 GB
```
## 1.3.登陆远程仓库
```shell
[root@hbase-phoenix es-sqly]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username (851279676): 851279676
Password: 
Login Succeeded
```
## 1.4.提交到远程仓库
```shell
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
```

## 1.5.从远程仓库下载该镜像
```shell
[root@hbase-phoenix es-sqly]# docker pull 851279676/es-sql:6.6.2
Trying to pull repository docker.io/851279676/es-sql ... 
6.6.2: Pulling from docker.io/851279676/es-sql
a02a4930cb5d: Already exists 
1c0c2b94f1aa: Already exists 
e7ba1c987917: Already exists 
8a5898116619: Already exists 
fa49d069f225: Already exists 
0dee6ce7977c: Already exists 
77ecd20c6308: Already exists 
959a5b064eb1: Pull complete 
16e96ca5402d: Pull complete 
3a23c1d3c3cb: Pull complete 
d5354ec81c26: Pull complete 
f7851c8f8b5c: Pull complete 
53d537559025: Pull complete 
8082545762e5: Pull complete 
02e013c5b4b6: Pull complete 
4dfd8f2f39a5: Pull complete 
94c3b7c63041: Downloading [==================================================>] 174.2 MB/174.2 MB
c371754f6946: Download complete 
6.6.2: Pulling from docker.io/851279676/es-sql
a02a4930cb5d: Already exists 
1c0c2b94f1aa: Already exists 
e7ba1c987917: Already exists 
8a5898116619: Already exists 
fa49d069f225: Already exists 
0dee6ce7977c: Already exists 
77ecd20c6308: Already exists 
959a5b064eb1: Pull complete 
16e96ca5402d: Pull complete 
3a23c1d3c3cb: Pull complete 
d5354ec81c26: Pull complete 
f7851c8f8b5c: Pull complete 
53d537559025: Pull complete 
8082545762e5: Pull complete 
02e013c5b4b6: Pull complete 
4dfd8f2f39a5: Pull complete 
94c3b7c63041: Pull complete 
c371754f6946: Pull complete 
Digest: sha256:5bd18563da2a2e5f67bfebcdcbe70b502caffd2033119d5a90978b5634253962
Status: Downloaded newer image for docker.io/851279676/es-sql:6.6.2
[root@hbase-phoenix es-sqly]# docker images
REPOSITORY                                    TAG                          IMAGE ID            CREATED             SIZE
docker.io/851279676/es-sql                    6.6.2                        829a51b69bea        About an hour ago   1.23 GB
```
## 1.6.启动es-sql容器

```shell
[root@hbase-phoenix es-sqly]# docker run  --name es-sql  -d -p 8080:8080 -p 9300:9300 -p 9200:9200 829a51b69bea
f35552f797437902bbba9f6dd357e728555f12d3a31c313d95a54efcf7c68608
[root@hbase-phoenix es-sqly]# docker ps -a
CONTAINER ID        IMAGE                                             COMMAND                  CREATED             STATUS                      PORTS                                                                    NAMES
f35552f79743        829a51b69bea                                      "point.sh"               5 seconds ago       Up 4 seconds                0.0.0.0:8080->8080/tcp, 0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp   es-sql
```
## 1.7.登陆es-sql界面
![Image](https://github.com/yzopen/es-sql/blob/master/images/es-sql.bmp)

![Image](https://github.com/yzopen/es-sql/blob/master/images/es.bmp)

