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
