cd influx-base && docker build -t influxdb-relay-base:centos7.0.1 ./ && cd ..  
cd influx-server && docker build -t influxdb-relay:centos7.0.1 ./ && cd ..
cd influx-nginx && docker build -t influxdb-relay-nginx:centos7.0.1 ./ && cd ..


