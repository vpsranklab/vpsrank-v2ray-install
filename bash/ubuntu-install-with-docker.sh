#!/bin/sh

# Copyright VPS Rank Inc.


if [ -z "$DOMAIN" ]
then
  echo "V2Ray域名未设置,请设置环境变量: DOMAIN"
  return
fi

apt update

# 安装docker
apt install -y docker.io

# 安装docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 生成UUID
UUID=$(cat /proc/sys/kernel/random/uuid) && echo ${UUID}

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
          "id": "${UUID}",
          "level": 1,
          "alterId": 64
        }
      ]
    },
    "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/"
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
$DOMAIN {
    root * /usr/share/caddy/
    file_server

    route {
        reverse_proxy /chat 127.0.0.1:10000
    }
}
EOF

cat <<EOF > /opt/vpsrank/docker/compose/v2ray/docker-compose.yaml
version: '3'
services:
  v2ray-instance:
    container_name: v2ray-instance
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
      - "./index.html:/usr/share/caddy/index.html:ro"
      - "/etc/localtime:/etc/localtime:ro"
EOF

# 创建Caddy服务器默认的欢迎页面(index.html),用于模拟静态站点
wget -P /opt/vpsrank/docker/compose/v2ray/ https://gitlab.com/vpsrank/vpsrank-v2ray-install/-/raw/master/assets/index.html

# 启动v2ray服务端
cd /opt/vpsrank/docker/compose/v2ray/ && docker-compose up -d

