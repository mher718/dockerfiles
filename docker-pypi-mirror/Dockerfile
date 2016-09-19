# large parts cribbed from mboersma/pypi-mirror  

FROM centos:latest
MAINTAINER Mark Swinson <mark@mswinson.com>

RUN yum -y update 
RUN yum install -y epel-release
RUN yum install -y gcc gcc-c++ make openssl-devel
RUN yum install -y libffi-devel libssl-devel python-devel
RUN yum install -y vim
RUN yum install -y wget
RUN yum install -y nginx

ADD files/app /app
COPY files/etc /etc
RUN /app/setup

EXPOSE 80
WORKDIR /app
VOLUME /var/packages

CMD [ "/app/start" ]
