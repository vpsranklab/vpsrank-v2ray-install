#!/bin/sh

# Copyright VPS Rank Inc.


if [ -z "$DOMAIN" ]
then
  echo "V2Ray域名未设置,请设置环境变量: DOMAIN"
  echo "就像这样: export DOMAIN=v2.vpsrank.com"
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
export UUID

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
${DOMAIN}:1443 {
    file_server
    route {
        reverse_proxy 127.0.0.1:10000
    }
}
EOF

cat <<EOF > /opt/vpsrank/docker/compose/v2ray/docker-compose.yaml
version: '3'
services:
  v2ray-instance:
    container_name: vpsrank-v2ray-instance
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
    container_name: vpsrank-caddy
    image: caddy:2.6
    restart: always
    network_mode: "host"
    volumes:
      - "./conf/Caddyfile:/etc/caddy/Caddyfile:ro"
      - "/etc/localtime:/etc/localtime:ro"
EOF

# 启动v2ray服务端
cd /opt/vpsrank/docker/compose/v2ray/ && docker-compose up -d

# 终端打印vmess协议串
vmessConfig="{\"v\":\"2\",\"ps\":\"${DOMAIN}\",\"add\":\"${DOMAIN}\",\"port\":\"1443\",\"id\":\"${UUID}\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"${DOMAIN}\",\"path\":\"/\",\"tls\":\"tls\",\"sni\":\"\",\"alpn\":\"\"}"
vmessString=$(echo -n "vmess://$(echo -n $vmessConfig | base64 --wrap=0)")

echo "====================================="
echo "V2ray Server配置信息"
echo "地址(address): ${DOMAIN}"
echo "端口(port): 1443"
echo "用户id(UUID): ${UUID}"
echo "额外id(alterId): 0"
echo "加密方式(security): auto"
echo "传输协议(network): ws"
echo "伪装类型(type): none"
echo "伪装域名(host): ${DOMAIN}"
echo "路径(path): /"
echo "底层传输安全: tls"
echo "====================================="
echo "=======导入以下vmess链接到V2RayN========"
echo $vmessString
