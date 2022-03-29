FROM centos:7
MAINTAINER Ahmet Demir <ahmet2mir+github@gmail.com>

ENV SHELL /bin/bash

# install gcc
RUN yum install -y gcc

RUN curl https://raw.githubusercontent.com/daleobrien/start-stop-daemon/master/start-stop-daemon.c > start-stop-daemon.c \
    &&  gcc start-stop-daemon.c -o start-stop-daemon \
    &&  mv start-stop-daemon /usr/bin/start-stop-daemon

ADD systemctl /usr/bin/systemctl-fake
RUN mv /usr/bin/systemctl /usr/bin/systemctl.real \
    && ln -s /usr/bin/systemctl-fake /usr/bin/systemctl

RUN yum clean all
run yum update
run yum install openssh-server -y
run yum -i 's/#\?\(PermitRootLogin\s*\).*$/\1 yes/' /etc/ssh/sshd_config
run systemctl restart ssh
run yum install tar unzip -y
run sh -c 'echo root:password | chpasswd'
run wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
run unzip ngrok-stable-linux-amd64.zip
run ./ngrok authtoken 1gSmdSM67EqAIQ6im0SrFdKJqzm_7qjPw3Co76B94F7i63Yzc
run ./ngrok tcp 22
