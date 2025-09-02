#!/bin/bash

# LiveKit Meet 部署脚本

set -e

echo "=== LiveKit Meet 部署开始 ==="

# 检查 Docker 和 Docker Compose
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "错误: Docker Compose 未安装"
    exit 1
fi

# 获取服务器 IP
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "检测到服务器 IP: $SERVER_IP"

# 停止现有服务
echo "停止现有服务..."
docker-compose down 2>/dev/null || true

# 清理旧镜像
echo "清理旧镜像..."
docker rmi livekit-meet-demo_meet 2>/dev/null || true

# 构建并启动服务
echo "构建并启动服务..."
docker-compose up -d --build

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 检查服务状态
echo "检查服务状态..."
docker-compose ps

# 检查 LiveKit Server
echo "检查 LiveKit Server..."
if curl -f http://localhost:7880 >/dev/null 2>&1; then
    echo "✅ LiveKit Server 运行正常"
else
    echo "❌ LiveKit Server 启动失败"
fi

# 检查 Meet 应用
echo "检查 Meet 应用..."
if curl -f http://localhost:3000 >/dev/null 2>&1; then
    echo "✅ Meet 应用运行正常"
else
    echo "❌ Meet 应用启动失败"
fi

echo ""
echo "=== 部署完成 ==="
echo "访问地址: http://$SERVER_IP:3000"
echo "LiveKit Server: ws://$SERVER_IP:7880"
echo ""
echo "如果无法访问，请检查防火墙设置："
echo "sudo ufw allow 3000"
echo "sudo ufw allow 7880"
echo "sudo ufw allow 7881"
echo "sudo ufw allow 50000:60000/udp"
echo ""
echo "查看日志："
echo "docker-compose logs -f"
