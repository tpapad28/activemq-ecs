FROM amazoncorretto:11

RUN yum update -y && yum install -y tar gzip procps

RUN yum clean all && rm -rf /var/cache/yum

ENV AMQ_VERSION=5.18.1
ENV ACTIVEMQ_DATA=/efs/data
ENV ACTIVEMQ_OPTS_MEMORY="-Xms64M -Xmx512M"
ENV ACTIVEMQ_SSL_OPTS="-Djavax.net.ssl.keyStore=/opt/apache-activemq/conf/amq-server.pfx -Djavax.net.ssl.keyStorePassword=password"
ENV activemq.brokername=MyBrokerName

WORKDIR /opt

RUN curl -L -J -s --output apache-activemq-${AMQ_VERSION}-bin.tar.gz "https://www.apache.org/dyn/closer.cgi?filename=/activemq/${AMQ_VERSION}/apache-activemq-${AMQ_VERSION}-bin.tar.gz&action=download"

RUN tar -xzf apache-activemq-${AMQ_VERSION}-bin.tar.gz && rm -f apache-activemq-${AMQ_VERSION}-bin.tar.gz && ln -s apache-activemq-${AMQ_VERSION} apache-activemq

RUN mkdir -p /efs/data/kahadb

COPY conf/activemq.xml /opt/apache-activemq/conf/activemq.xml
COPY conf/jetty.xml /opt/apache-activemq/conf/jetty.xml
COPY conf/amq-server.pfx /opt/apache-activemq/conf/amq-server.pfx

EXPOSE 8161 8162 61616

ENTRYPOINT [ "./apache-activemq/bin/activemq", "console" ]
