FROM golang:1.14.6-alpine

ENV ENV="/root/.ashrc"

RUN set -ex \
    && echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    apache2-utils \
    bash \
    bind-tools \
    bird \
    bridge-utils \
    build-base \
    busybox-extras \
    conntrack-tools \
    curl \
    dhcping \
    drill \
    ethtool \
    file\
    fping \
    git \
    iftop \
    iperf \
    iproute2 \
    ipset \
    iptables \
    iptraf-ng \
    iputils \
    ipvsadm \
    libc6-compat \
    liboping \
    libressl-dev \
    mtr \
    net-snmp-tools \
    netcat-openbsd \
    nftables \
    ngrep \
    nmap \
    nmap-nping \
    openssl \
    py-crypto \
    py2-virtualenv \
    python2 \
    scapy \
    socat \
    strace \
    tcpdump \
    tcptraceroute \
    tzdata \
    util-linux \
    vim

# apparmor issue #14140
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Installing ctop - top-like container monitor
RUN wget https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64 -O /usr/local/bin/ctop && chmod +x /usr/local/bin/ctop

# Installing cockroach
ARG COCKROACH_VERSION=v19.1.3
RUN wget https://binaries.cockroachdb.com/cockroach-${COCKROACH_VERSION}.linux-musl-amd64.tgz -O - | tar -xz -O > /usr/local/bin/cockroach && chmod +x /usr/local/bin/cockroach

# Installing etcdctl
ARG ETCD_VERSION=v3.3.12
RUN GO111MODULE=on go get -v go.etcd.io/etcd/etcdctl@${ETCD_VERSION}

# Installing minio
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && chmod +x /usr/local/bin/mc

# Installing grpcurl
ARG GRPCURL_VERSION=1.4.0
RUN wget https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz -O - | tar -xvz -O > /usr/local/bin/grpcurl && chmod +x /usr/local/bin/grpcurl

# Installing tile38
ARG TILE38_VERSION=1.17.5
RUN wget https://github.com/tidwall/tile38/releases/download/${TILE38_VERSION}/tile38-${TILE38_VERSION}-linux-amd64.tar.gz -O - | tar xvzf - -C /usr/local \
    && mv /usr/local/tile38-${TILE38_VERSION}-linux-amd64 /usr/local/tile38

# Support private repos
ARG GITHUB_TOKEN
ARG GOPRIVATE=github.com/rocaccion/*
RUN git config --global url."https://${GITHUB_TOKEN}:@github.com/".insteadOf "https://github.com/"

# Installing seabolt
ARG SEABOLT_VERSION=1.7.4
RUN wget https://github.com/neo4j-drivers/seabolt/releases/download/v${SEABOLT_VERSION}/seabolt-${SEABOLT_VERSION}-Linux-alpine-3.9.3.tar.gz -O - | tar xvzf - --strip-components=1 -C /

# Installing outsafe-testing
RUN go get -v github.com/rocaccion/outsafe-testing

# Settings
ADD motd /etc/motd
ADD profile  /etc/profile

CMD ["/bin/bash","-l"]
