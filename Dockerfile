FROM phusion/baseimage:18.04-1.0.0
MAINTAINER skysider <skysider@163.com>

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Asia/Shanghai

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN wget https://github.com/radareorg/radare2/releases/download/4.4.0/radare2_4.4.0_amd64.deb && \
    dpkg -i radare2_4.4.0_amd64.deb && rm radare2_4.4.0_amd64.deb

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    pwntools \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git /root/Pwngdb && \
    cd /root/Pwngdb && cat /root/Pwngdb/.gdbinit  >> /root/.gdbinit && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" /root/.gdbinit

RUN git clone --depth 1 https://github.com/niklasb/libc-database.git libc-database && \
    cd libc-database && ./get || echo "/libc-database/" > ~/.libcdb_path

WORKDIR /ctf/work/

CMD ["/sbin/my_init"]