FROM alpine:3.8
LABEL MAINTAINER="wnxd <imiku@wnxd.me>"

ARG SS_VER=3.2.0
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SS_VER}/shadowsocks-libev-${SS_VER}.tar.gz
ARG KCP_VER=20180316
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v${KCP_VER}/kcptun-linux-amd64-${KCP_VER}.tar.gz

RUN echo "root:alpine" | chpasswd && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk --no-cache upgrade && \
    apk --no-cache add \
        openssh-server \
        autoconf \
        build-base \
        curl \
        libev-dev \
        linux-headers \
        libsodium-dev \
        mbedtls-dev \
        pcre-dev \
        tar \
        tzdata \
        c-ares-dev \
        git \
        gcc \
        make \
        libtool \
        zlib-dev \
        automake \
        openssl \
        asciidoc \
        xmlto \
        libpcre32 \
        g++

# 搭建SSH服务器
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

# 清理环境
RUN rm -rf /var/cache/apk/* /tmp/*

# 开放端口
EXPOSE 22

# 启动命令
ADD entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT [ "bash", "/usr/bin/entrypoint.sh" ]