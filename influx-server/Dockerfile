FROM influxdb-relay-base:centos7.0.1
COPY ./influxdb.repo /etc/yum.repos.d/influxdb.repo
RUN yum install influxdb -y
RUN yum install -y golang-go
COPY ./influxdb.conf $PROJECT_DIR/conf/influxdb.conf

