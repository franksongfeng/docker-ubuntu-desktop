FROM ubuntu:16.04
LABEL description="ubuntu docker with xfce desktop"
LABEL version="1.0"
LABEL maintainer="Feng Song <franksongfeng@yahoo.com>"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV TIME_ZONE Asia/Shanghai

RUN apt-get update
RUN apt-get install -y \
        apt-utils tzdata net-tools iputils-ping lsof curl netcat wget bzip2 vim-tiny \
        supervisor \
        openssh-server \
        xfce4 xfce4-goodies \
        x11vnc xvfb \
        firefox
RUN apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN echo "${TIME_ZONE}" > /etc/timezone && \ 
    ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

ARG ROOT_PWD=admin
RUN mkdir -p /var/run/sshd && \
    echo 'root:'${ROOT_PWD} | chpasswd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

WORKDIR /root

COPY startup.sh ./
COPY supervisord.conf ./

ARG PORT_VNC=5900
ARG PORT_SSH=22

EXPOSE \
    ${PORT_VNC} \
    ${PORT_SSH}

RUN chmod +x ./startup.sh
ENTRYPOINT ["./startup.sh"]
