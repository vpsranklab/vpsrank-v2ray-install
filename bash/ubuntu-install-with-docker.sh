#!/bin/bash

# Check if there are exactly two arguments provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 domain_name v2ray_version"
    exit 1
fi

# Assign arguments to variables
domain_name=$1
v2ray_version=$2

# Install Docker
sudo apt update
sudo apt install -y docker.io docker-compose

# Generate UUID
uuid=$(cat /proc/sys/kernel/random/uuid) && echo ${UUID}

# Create and populate /etc/v2ray/config.json
sudo mkdir -p /etc/v2ray
sudo bash -c "cat > /etc/v2ray/config.json" <<EOL
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
          "id": "$uuid",
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
EOL

# Create and populate /opt/vpsrank/v2ray/docker-compose.yaml
sudo mkdir -p /opt/vpsrank/v2ray
sudo bash -c "cat > /opt/vpsrank/v2ray/docker-compose.yaml" <<EOL
version: '3'
services:
  v2ray:
    container_name: v2ray
    image: teddysun/v2ray:$v2ray_version
    restart: always
    environment:
      LANG: en_US.utf8
      LC_ALL: en_US.utf8
    ports:
      - "127.0.0.1:10000:10000"
    volumes:
      - "/etc/v2ray:/etc/v2ray"
      - "/etc/localtime:/etc/localtime:ro"
EOL

# Start V2Ray
cd /opt/vpsrank/v2ray && docker-compose up -d

# Install Caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy

# Create and populate docker-compose.yaml for Caddy
sudo bash -c "cat > /opt/vpsrank/v2ray/docker-compose.yaml" <<EOL
$domain_name {
    file_server
    reverse_proxy 127.0.0.1:10000 {
        header_up Host
        header_up REMOTE-HOST
        header_up -X-Forwarded-For
        header_up -X-Forwarded-Proto
        header_up -X-Forwarded-Host
        header_up -X-Real-IP
    }
    log {
        output file /var/log/caddy/access.log
    }
}
EOL

# Restart Caddy
sudo systemctl restart caddy

# Print Vmess in Terminal
vmessConfig="{\"v\":\"2\",\"ps\":\"${domain_name}\",\"add\":\"${domain_name}\",\"port\":\"443\",\"id\":\"${uuid}\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"${domain_name}\",\"path\":\"/\",\"tls\":\"tls\",\"sni\":\"\",\"alpn\":\"\"}"
vmessString=$(echo -n "vmess://$(echo -n $vmessConfig | base64 --wrap=0)")

# Save Vmess address to file

sudo bash -c "cat > /opt/vpsrank/v2ray/vmess_info.txt" <<EOL
=====================================
V2ray Server配置信息
地址(address): ${domain_name}
端口(port): 443
用户id(UUID): ${uuid}
额外id(alterId): 0
加密方式(security): auto
传输协议(network): ws
伪装类型(type): none
伪装域名(host): ${domain_name}
路径(path): /
底层传输安全: tls
=====================================
=====你可以通过以下vmess链接进行导入======
$vmessString
EOL

cat /opt/vpsrank/v2ray/vmess_info.txt

