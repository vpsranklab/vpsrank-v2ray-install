# vpsrank-v2ray-install

[VPS Rank](https://vpsrank.com) 提供的快速部署V2Ray服务端方案，基于Docker和Docker Compose编排，达到分钟级部署。

## 运行环境

1. 已验证的操作系统：Ubuntu 22.04/20.04/18.04 LTS
2. 容器运行时：Docker Stable Latest
3. 容器编排工具：docker-compose
4. 流量代理工具：v2ray
5. 应用服务器：caddy
6. 安装目录：/opt/vpsrank/
7. 端口占用：
   - 80：应用服务器caddy占用
   - 443：应用服务器caddy占用

## 前置条件

1. 主机或VPS：非中国大陆地区，拥有主机root权限，可以通过[搬瓦工 BandwagonHost](https://bwh81.net/aff.php?aff=66695)或其它厂商购买
2. 一个域名(一级或二级域名)，并成功解析到你的**国外服务器**IP地址. 域名可通过[Namecheap](https://www.namecheap.com/domains/)或[GoDaddy](https://dcc.godaddy.com/domains)购买，示例:
   - www.vpsrank.com
   - v2.vpsrank.com
3. 域名解析A记录：将v2.vpsrank.com解析到100.101.102.103的IPv4地址
4. SSH连接：可以通过ssh工具(Xshell/MobaXterm)连接到VPS或云服务器

## 快速开始

### 自动部署
适用于全新安装Docker并运行V2Ray服务端

#### 安装

这个命令仅接收2个**必要**的参数：
- domain_name，V2Ray服务端使用的域名，并同时用于Caddy申请SSL证书，示例值：v2.vpsrank.com
- v2ray_version，V2Ray服务端运行的版本，示例值：5.4.0，其它版本可以在 **[这里](https://hub.docker.com/r/teddysun/v2ray/tags)** 浏览

命令运行格式为 `ubuntu-install-with-docker DOMAIN_NAME V2RAY_VERSION`

```
wget https://vpsrank.com/ubuntu-install-with-docker
chmod +x ubuntu-install-with-docker
./ubuntu-install-with-docker your.domain.com 5.7.0
```
   
#### 卸载

coming soon...

### 手动部署

> 注意：你需要预先安装**docker**并且支持**docker compose/docker-compose的两种形式**

1. 克隆这个仓库到你的服务器目录
   ```
   git clone https://gitlab.com/vpsrank/vpsrank-v2ray-install.git /opt/vpsrank/vpsrank-v2ray-install
   cd /opt/vpsrank/vpsrank-v2ray-install/docker-compose
   ```
2. 修改`conf/Caddyfile`文件中的`YOUR_DOMAIN`为你的V2Ray域名
3. 修改`conf/config-first.json`文件中的`YOUR_UUID`为你的UUID，UUID可以在 https://www.uuidtools.com/v4 获取，或通过以下命令生成
   ```
   cat /proc/sys/kernel/random/uuid
   ```
4. 启动V2Ray服务端
   ```
   docker-compose up -d
   ```
