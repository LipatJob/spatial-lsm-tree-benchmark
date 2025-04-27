# Start from an OpenJDK base image
FROM openjdk:21-slim

# Set environment variables
ENV ASTERIXDB_VERSION=0.9.9

# Install wget and unzip
RUN apt-get update && apt-get install -y wget unzip && apt-get install -y iotop && rm -rf /var/lib/apt/lists/*

# Download AsterixDB binary release
# http://www.apache.org/dyn/closer.lua/asterixdb/asterixdb-0.9.9/asterix-server-0.9.9-binary-assembly.zip
# https://dlcdn.apache.org/asterixdb/asterixdb-0.9.9/asterix-server-0.9.9-binary-assembly.zip
# RUN wget http://www.apache.org/dyn/closer.lua/asterixdb/asterixdb-${ASTERIXDB_VERSION}/asterix-server-${ASTERIXDB_VERSION}-binary-assembly.zip \
RUN wget https://dlcdn.apache.org/asterixdb/asterixdb-${ASTERIXDB_VERSION}/asterix-server-${ASTERIXDB_VERSION}-binary-assembly.zip \
    && unzip asterix-server-${ASTERIXDB_VERSION}-binary-assembly.zip \
    && mv apache-asterixdb-${ASTERIXDB_VERSION} /opt/asterixdb \
    && rm asterix-server-${ASTERIXDB_VERSION}-binary-assembly.zip

# Expose necessary ports
EXPOSE 19001 19002 19006 20000-20005

COPY ./config/cc.conf /opt/asterixdb/config/cc.conf
COPY ./config/nc.conf /opt/asterixdb/config/nc.conf

COPY ./config/start.sh /opt/asterixdb/start.sh

# Set working directory
WORKDIR /opt/asterixdb

ENTRYPOINT ["./start.sh"]