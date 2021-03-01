FROM influxdb-relay-base:centos7.0.1
RUN yum install -y nginx
COPY influx_ha/deploy_influx_ha.sh $PROJECT_DIR/influx_ha/deploy_influx_ha.sh
COPY conf/influx-loadbalancer.conf $PROJECT_DIR/conf/influx-loadbalancer.conf
COPY start-server.sh $PROJECT_DIR/start-server.sh
COPY start_ha.sh start_ha.sh
COPY conf/relay_1.toml conf/relay_1.toml
COPY conf/relay_2.toml conf/relay_2.toml
RUN systemctl enable nginx
