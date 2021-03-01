docker run -d -d --privileged --name influx0 -h influx0 -p 7076:7076 -it influxdb-relay-nginx:centos7.0.1
docker run -d -d --privileged --name influx1 -h influx1 -it influxdb-relay:centos7.0.1
docker run -d -d --privileged --name influx2 -h influx2 -it influxdb-relay:centos7.0.1

#docker exec -it influx0 hostname influx0
#docker exec -it influx1 hostname influx1
#docker exec -it influx2 hostname influx2

docker cp influx-base/hosts influx0:/root/hosts
docker cp influx-base/hosts influx1:/root/hosts
docker cp influx-base/hosts influx2:/root/hosts
docker cp influx-base/change-hosts.sh influx0:/root/change-hosts.sh
docker cp influx-base/change-hosts.sh influx1:/root/change-hosts.sh
docker cp influx-base/change-hosts.sh influx2:/root/change-hosts.sh
docker exec -it influx0 bash /root/change-hosts.sh
docker exec -it influx1 bash /root/change-hosts.sh
docker exec -it influx2 bash /root/change-hosts.sh

docker exec -it influx1 bash ./start-base.sh 
docker exec -it influx2 bash ./start-base.sh 
docker exec -it influx0 bash ./start-base.sh 

docker exec -it influx0 bash ./start-server.sh
docker exec -it influx0 bash ./start_ha.sh


