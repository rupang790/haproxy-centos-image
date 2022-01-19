# haproxy-centos-image
This is the HaProxy based on centos7:latest image for haproxy-centos helm chart.

## Description
This image was considered mounting `haproxy.cfg` config file through the kubernetes configmap, in order to use a flexible config file for various sites. Dockerfile and entrypoint file were referenced by https://github.com/CentOS/CentOS-Dockerfiles.
+ Configuration file for `haproxy` daemon, which is `haproxy.cfg`, should be mounted at `/tmp/haproxy` on container.
+ By `entrypoint` file, under `/tmp/*` directory files will be copied to `/haproxy/*` directory.
+ `haproxy` will be started with config file path as `/haproxy/haproxy.cfg`.
+ Also logging with rsyslog was configured, so it needs a PV/PVC for it.
