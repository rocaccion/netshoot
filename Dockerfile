FROM golang:1.12.9-alpine

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
RUN wget https://binaries.cockroachdb.com/cockroach-v${COCKROACH_VERSION}.linux-musl-amd64.tgz -O - | | tar -xz -O > /usr/local/bin/cockroach && chmod +x /usr/local/bin/cockroach

# Installing etcdctl
ARG ETCD_VERSION=v3.3.12
RUN GO111MODULE=on go get -v go.etcd.io/etcd/etcdctl@${ETCD_VERSION}

# Installing grpcurl
ARG GRPCURL_VERSION=1.3.1
RUN wget https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz -O - | tar -xz -O > /usr/local/bin/grpcurl && chmod +x /usr/local/bin/grpcurl

# Settings
ADD motd /etc/motd
ADD profile  /etc/profile

CMD ["/bin/bash","-l"]
