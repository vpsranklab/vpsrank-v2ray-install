#!/usr/bin/env bash

apt update

# 安装docker
apt install -y docker.io

# 安装docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 写入v2ray配置文件
mkdir -p /opt/vpsrank/docker/compose/v2ray/conf

cat <<EOF > /opt/vpsrank/docker/compose/v2ray/conf/config-first.json
{
  "log" : {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [{
    "port": 10000,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "d90eb412-1e6f-4ed0-aa10-4d92abcd52a2",
          "level": 1,
          "alterId": 64
        }
      ]
    },
    "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/index"
        }
    },
    "listen": "0.0.0.0"
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

cat <<EOF > /opt/vpsrank/docker/compose/v2ray/conf/Caddyfile
v2.vpsrank.com {
    reverse_proxy 127.0.0.1:10000
}
EOF

cat <<EOF > /opt/vpsrank/docker/compose/v2ray/docker-compose.yaml
version: '3'
services:
  v2ray-instance:
    image: teddysun/v2ray:5.4.0
    command: /usr/bin/v2ray run -config /etc/v2ray/config-first.json
    restart: always
    environment:
      LANG: en_US.utf8
      LC_ALL: en_US.utf8
    ports:
      - "127.0.0.1:10000:10000"
    volumes:
      - "./conf:/etc/v2ray"
      - "/etc/localtime:/etc/localtime:ro"
  caddy:
    container_name: caddy
    image: caddy:2.6
    restart: always
    network_mode: "host"
    volumes:
      - "./conf/Caddyfile:/etc/caddy/Caddyfile:ro"
      - "/etc/localtime:/etc/localtime:ro"
EOF

# 启动v2ray服务端
cd /opt/vpsrank/docker/compose/v2ray/ && docker-compose up -d

# 安装caddy
#apt install -y debian-keyring debian-archive-keyring apt-transport-https
#curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
#curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
#apt update
#apt install caddy

#验证caddy版本
# caddy version
