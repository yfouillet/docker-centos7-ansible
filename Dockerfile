FROM centos:7
LABEL maintainer="Yoann Fouillet"

ENV container docker
ENV ansible_version "2.9.2"

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install requirements.
RUN yum -y install deltarpm \
    ca-certificates \
    epel-release \
    sudo 

RUN yum install -y  python3 python3-pip

# Upgrade pip & install Python3 venv.
RUN pip3 install --upgrade pip \
    virtualenv

# Use virtual env for Python3 & install Ansible.
RUN python3 -m virtualenv $VIRTUAL_ENV
RUN pip install ansible==$ansible_version

# Install systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y update
RUN yum clean all

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/lib/systemd/systemd"]
