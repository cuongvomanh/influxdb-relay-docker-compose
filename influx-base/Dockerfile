FROM centos:7
RUN yum install epel-release -y && yum clean all
RUN yum update -y && yum clean all
RUN yum install -y systemd* && yum clean all

#Setting up systemd
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

RUN yum install -y yum-utils yum-plugin-ovl tar git curl bind-utils unzip wget && yum clean all
# Setup sshd
RUN yum install -y openssh-server openssh-clients && yum clean all
RUN systemctl enable sshd


RUN yum install ruby ruby-full -y
RUN ruby -v

# Install go
ENV GOPATH /root/go
ENV GO_VERSION 1.6.2
ENV GO_ARCH amd64

RUN yum install wget make zip git -y
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz; \
   tar -C /usr/local/ -xf /go${GO_VERSION}.linux-${GO_ARCH}.tar.gz ; \
   rm /go${GO_VERSION}.linux-${GO_ARCH}.tar.gz
ENV PATH /usr/local/go/bin:$PATH

ENV PROJECT_DIR $GOPATH/src/github.com/influxdata/influxdb-relay
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p $PROJECT_DIR
WORKDIR $PROJECT_DIR

RUN cd /root/go/src/github.com/influxdata/ && git clone https://github.com/influxdata/influxdb-relay.git
RUN cd /root/go/src/github.com/influxdata/ && git clone https://github.com/influxdata/influxdb1-client.git
RUN mkdir /root/go/src/github.com/naoina
RUN cd /root/go/src/github.com/naoina/ && git clone https://github.com/naoina/toml.git
RUN cd /root/go/src/github.com/naoina/ && git clone https://github.com/naoina/go-stringutil.git
RUN /root/go/src/github.com/influxdata/influxdb-relay/build.py
RUN mkdir $GOPATH/bin/ && cp /root/go/src/github.com/influxdata/influxdb-relay/build/influxdb-relay $GOPATH/bin/
RUN cp sample.toml relay.toml
#COPY entrypoint.sh /root/go/src/github.com/influxdata/influxdb-relay/
#RUN chmod +x /root/go/src/github.com/influxdata/influxdb-relay/entrypoint.sh 
RUN yum install sshpass -y
# Setup sshd
RUN yum install -y openssh-server openssh-clients && yum clean all
RUN systemctl enable sshd
RUN yum install vim telnet net-tools -y

#COPY ./start_ha.sh $PROJECT_DIR
#COPY ./start-server.sh $PROJECT_DIR
COPY ./start-base.sh $PROJECT_DIR

RUN yum install initscripts -y
