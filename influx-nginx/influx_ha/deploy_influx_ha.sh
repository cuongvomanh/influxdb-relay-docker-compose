#!/bin/bash -xe

INFLUX1=${INFLUX1:-172.20.9.29}
INFLUX2=${INFLUX2:-172.20.9.19}
BALANCER=${BALANCER:-172.20.9.27}
SSH_PASSWORD=${SSH_PASSWORD:-"r00tme"}
SSH_USER="root"
SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

type sshpass || (echo "sshpass is not installed" && exit 1)

ssh_exec() {
    node=$1
    shift
    sshpass -p ${SSH_PASSWORD} ssh ${SSH_OPTIONS} ${SSH_USER}@${node} "$@"
}

scp_exec() {
    node=$1
    src=$2
    dst=$3
    sshpass -p ${SSH_PASSWORD} scp ${SSH_OPTIONS} ${2} ${SSH_USER}@${node}:${3}
}

# prepare influx1:
##ssh_exec $INFLUX1 "echo 'deb https://repos.influxdata.com/ubuntu xenial stable' > /etc/apt/sources.list.d/influxdb.list"
#scp_exec $INFLUX1 /etc/yum.repos.d/influxdb.repo /etc/yum.repos.d/influxdb.repo
ssh_exec $INFLUX1 "yum install -y influxdb"
#scp_exec $INFLUX1 conf/influxdb.conf /etc/influxdb/influxdb.conf
ssh_exec $INFLUX1 "service influxdb restart"
ssh_exec $INFLUX1 "echo 'GOPATH=/root/gocode' >> /etc/environment"
ssh_exec $INFLUX1 "echo 'PATH=$PATH:/root/go/bin' >> /etc/environment"
ssh_exec $INFLUX1 "yum install -y golang-go"
ssh_exec $INFLUX1 "source /etc/environment && go get -u github.com/influxdata/influxdb-relay"
scp_exec $INFLUX1 conf/relay_1.toml /root/relay.toml
ssh_exec $INFLUX1 "sed -i -e 's/influx1_ip/${INFLUX1}/g' -e 's/influx2_ip/${INFLUX2}/g' /root/relay.toml"
ssh_exec $INFLUX1 "influxdb-relay -config  relay.toml > /dev/null 2>&1 &"

#scp_exec $INFLUX2 /etc/yum.repos.d/influxdb.repo /etc/yum.repos.d/influxdb.repo
ssh_exec $INFLUX2 "yum install -y influxdb"
#scp_exec $INFLUX2 conf/influxdb.conf /etc/influxdb/influxdb.conf
ssh_exec $INFLUX2 "service influxdb restart"
ssh_exec $INFLUX2 "echo 'GOPATH=/root/gocode' >> /etc/environment"
ssh_exec $INFLUX2 "echo 'PATH=$PATH:/root/go/bin' >> /etc/environment"
ssh_exec $INFLUX2 "yum install -y golang-go"
ssh_exec $INFLUX2 "source /etc/environment && go get -u github.com/influxdata/influxdb-relay"
scp_exec $INFLUX2 conf/relay_2.toml /root/relay.toml
ssh_exec $INFLUX2 "sed -i -e 's/influx1_ip/${INFLUX1}/g' -e 's/influx2_ip/${INFLUX2}/g' /root/relay.toml"
ssh_exec $INFLUX2 "influxdb-relay -config  relay.toml > /dev/null 2>&1 &"

# prepare balancer:
ssh_exec $BALANCER "yum install -y nginx"
ssh_exec $BALANCER "service nginx start"
scp_exec $BALANCER conf/influx-loadbalancer.conf /etc/nginx/conf.d/influx-loadbalancer.conf
ssh_exec $BALANCER "sed -i -e 's/influx1_ip/${INFLUX1}/g' -e 's/influx2_ip/${INFLUX2}/g' /etc/nginx/conf.d/influx-loadbalancer.conf"
ssh_exec $BALANCER "service nginx reload"

echo "INFLUX HA SERVICE IS AVAILABLE AT http://${BALANCER}:7076"

