ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
sshpass -p '123456a@' ssh-copy-id -o "StrictHostKeyChecking no" localhost
sshpass -p '123456a@' ssh-copy-id -o "StrictHostKeyChecking no" influx0 
sshpass -p '123456a@' ssh-copy-id -o "StrictHostKeyChecking no" influx1
sshpass -p '123456a@' ssh-copy-id -o "StrictHostKeyChecking no" influx2

