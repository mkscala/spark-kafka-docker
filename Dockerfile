FROM ubuntu:14.10
MAINTAINER Frank Denis

RUN apt-get update && apt-get -y install cowsay zsh silversearcher-ag emacs24-nox jed \
    build-essential autoconf automake libtool git wget curl supervisor
RUN apt-get update && apt-get -y install openjdk-8-jdk maven scala
RUN apt-get update && apt-get -y install zookeeper zookeeper-bin zookeeperd

RUN mkdir -p /opt/el ; cd /opt/el && git clone git://github.com/hvesalai/scala-mode2.git
COPY 99scala-mode2.el /etc/emacs/site-start.d/

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN curl -L http://apache.claz.org/kafka/0.8.2.1/kafka_2.9.2-0.8.2.1.tgz | \
    tar xzv -C /opt -f - && mv /opt/kafka* /opt/kafka
ENV KAFKA_HOME /opt/kafka

RUN curl -L http://www.trieuvan.com/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | \
    tar xzv -C /opt -f - && mv /opt/hadoop* /opt/hadoop
ENV HADOOP_HOME /opt/hadoop

RUN curl -L http://mirrors.gigenet.com/apache/spark/spark-1.3.0/spark-1.3.0-bin-hadoop2.4.tgz | \
    tar xzv -C /opt -f - && mv /opt/spark* /opt/spark
ENV SPARK_HOME /opt/spark

ENV PATH /opt/hadoop/bin:/opt/kafka/bin:/opt/spark/bin:/opt/sbt/bin:$PATH

RUN curl -L https://dl.bintray.com/sbt/native-packages/sbt/0.13.7/sbt-0.13.7.tgz | \
    tar xzv -C /opt -f -

RUN sbt

COPY supervisord-*.conf /etc/supervisor/conf.d/

VOLUME ["/var/log", "/tmp"]

EXPOSE 2181 2888 3888 22 80 8080 8081 4040 4044

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
