# vpsrank-v2ray-install

[VPS Rank](https://vpsrank.com) 提供的快速部署V2Ray服务端方案

## 运行环境

1. 操作系统: Ubuntu 22.04 LTS/20.04 LTS/18.04 LTS
2. 容器运行时: Docker 20.10.12
3. 容器编排工具: docker-compose 1.29.2
4. 流量代理工具: v2ray 5.4.0
5. 应用服务器: caddy 2.6.x
6. 安装目录: /opt/vpsrank/

## 前置条件

1. 一个域名(一级或二级域名), 可通过[Namecheap](https://www.namecheap.com/domains/)或[GoDaddy](https://dcc.godaddy.com/domains)购买, 示例:
   - www.vpsrank.com
   - v2.vpsrank.com
2. 一台拥有root账户的**国外服务器**: VPS或云服务器均可, 可以通过[搬瓦工 BandwagonHost](https://bwh81.net/aff.php?aff=66695)或其它厂商购买
3. 可以通过ssh工具(Xshell/MobaXterm)连接到VPS或云服务器

## 快速开始

### 自动安装

#### 安装V2Ray(包含Docker)

```
curl -L https://vpsrank.com/ubuntu-install-with-docker | sh -
```

#### 安装V2Ray(不包含Docker)

```
curl -L https://vpsrank.com/ubuntu-install-without-docker | sh -
```

### 手动安装

#### 使用docker-compose部署

> 注意: 你需要预先安装**docker**和**docker-compose**

1. 克隆这个仓库到你的服务器目录
   ```
   git clone https://gitlab.com/vpsrank/vpsrank-v2ray-install.git /opt/vpsrank/vpsrank-v2ray-install
   cd /opt/vpsrank/vpsrank-v2ray-install/docker-compose
   ```
2. 修改`conf/Caddyfile`文件中的`YOUR_DOMAIN`为你的V2Ray域名
3. 修改`conf/config-first.json`文件中的`YOUR_UUID`为你的UUID, UUID可以在 https://www.uuidtools.com/v4 获取
4. 启动V2Ray服务端
   ```
   docker-compose up -d
   ```