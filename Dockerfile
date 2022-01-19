# This is HaProxy container image dockerfile
# it is IPv4 only

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

# Labels consumed by OpenShift
LABEL io.k8s.description="ISC BIND is open source software that implements the Domain Name System (DNS) protocols for the Internet" \
      io.k8s.display-name="HaProxy with CentOS7" \
      io.openshift.tags="haproxy"

# install main packages:
RUN yum -y install rsyslog* telnet net-tools dmidecode tcpdump \
 && yum -y install wget gcc pcre-devel make \
 && yum clean all

# Set ENV for HAProxy Specific Version
ENV HAPROXY_VERSIOM 1.8.27
ENV HAPROXY_URL http://www.haproxy.org/download/1.8/src/haproxy-1.8.27.tar.gz
ENV HAPROXY_SHA256 56ba6a21e13215fae56472ad37d5d68c3f19bde9da94c59e70b869eecf48bf50

# Download and Install Specific Version of HAProxy
RUN wget -O haproxy.tar.gz "$HAPROXY_URL"; \
    echo "$HAPROXY_SHA256 *haproxy.tar.gz" | sha256sum -c; \
    tar -zxvf haproxy.tar.gz -C ~/; \
    sleep 5; \
    rm -rf haproxy.tar.gz; \
    cd ~/haproxy-1.8.27; \
    make TARGET=linux-glibc; \
    make install; \
    ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy; \
    sleep 5; \
    /usr/sbin/haproxy -v;


ENV LANG=ko_KR.utf8 TZ=Asia/Seoul

ADD container-image-root /

# set up the BIND env and gen rndc key
RUN chmod 755 /entrypoint

# Labels consumed by Nulecule Specification
# Volumes:
#  * /named   - this is where all the named data lives
LABEL io.projectatomic.nulecule.volume.data="/haproxy,128Mi"
VOLUME [ "/haproxy" ]

# start services:
ENTRYPOINT [ "/entrypoint"]
CMD [ "/usr/sbin/haproxy" ]
