#!/bin/sh

# Copyright VPS Rank Inc.

# 停止v2ray服务端
cd /opt/vpsrank/docker/compose/v2ray/ && docker-compose down

unset DOMAIN

# 移除v2ray容器编排目录
rm -rf /opt/vpsrank/docker/
