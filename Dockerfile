FROM ubuntu:16.04
LABEL description="ubuntu docker with xfce desktop"
LABEL version="1.0"
LABEL maintainer="Feng Song <franksongfeng@yahoo.com>"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
        apt-utils net-tools iputils-ping ufw lsof curl netcat wget bzip2 \
        vim-tiny supervisor
RUN apt-get install -y \
        openssh-server \
        xfce4 xfce4-goodies \
        x11vnc xvfb \
        firefox
RUN apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
ARG ROOT_PWD=admin
RUN mkdir -p /var/run/sshd && \
    echo 'root:'${ROOT_PWD} | chpasswd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
COPY supervisord.conf ./
RUN /usr/bin/supervisord -c /root/supervisord.conf

ARG PORT_VNC=5900
ARG PORT_SSH=22
ARG PORT_HTTP=80

EXPOSE \
    ${PORT_VNC} \
    ${PORT_SSH} \
    ${PORT_HTTP}

CMD ["/bin/bash"]
