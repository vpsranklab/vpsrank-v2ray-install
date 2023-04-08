# vpsrank-v2ray-install

[VPS Rank](https://vpsrank.com) 提供的快速部署V2Ray服务端方案

## 运行环境

1. 操作系统: Ubuntu 22.04 LTS/20.04 LTS/18.04 LTS
2. 容器运行时: Docker 20.10.12
3. 容器编排工具: docker-compose 1.29.2
4. 流量代理工具: v2ray 5.4.0
5. 应用服务器: caddy 2.6.x


## 快速开始

### 必要步骤

1. 一个拥有管理权限的域名: 例如vpsrank.com, 可通过[Namecheap](https://www.namecheap.com/domains/)或[GoDaddy](https://dcc.godaddy.com/domains)购买
2. 一台拥有root账户的国外服务器: VPS或云服务器均可, 可通过[搬瓦工 BandwagonHost](https://bwh81.net/aff.php?aff=66695)或其它厂商购买
3. 可通过ssh工具连接到VPS或云服务器

### 克隆该仓库到服务器指定项目

```
git clone https://gitlab.com/vpsrank/vpsrank-v2ray-install.git
cd vpsrank-v2ray-install
```

### 使用docker容器化部署(推荐)

> 注意: 你需要预先安装docker和docker-compose

```
cd docker-compose
docker-compose up -d
```

### 使用Ubuntu Linux服务器部署

```
cd bash
sh ubuntu-install.sh
```