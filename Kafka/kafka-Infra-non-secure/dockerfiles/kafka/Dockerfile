FROM openjdk:11

WORKDIR /opt/

ADD https://archive.apache.org/dist/kafka/2.8.2/kafka-2.8.2-src.tgz /opt/

RUN tar zxvf ./kafka-2.8.2-src.tgz 

WORKDIR /opt/kafka-2.8.2-src

RUN ./gradlew jar

COPY server.properties /opt/
COPY kafka-server-start.sh /opt/kafka-2.8.2-src/bin

RUN apt-get update&& apt-get install -y gettext-base dos2unix mc kafkacat host

RUN dos2unix /opt/kafka-2.8.2-src/config/*
RUN dos2unix /opt/kafka-2.8.2-src/bin/*

WORKDIR /opt/kafka-2.8.2-src/config

#RUN envsubst</opt/server.properties>/opt/kafka-2.4.1-src/config/server.properties

EXPOSE 9092 

CMD ["/opt/kafka-2.8.2-src/bin/kafka-server-start.sh","/opt/kafka-2.8.2-src/config/server.properties"]    