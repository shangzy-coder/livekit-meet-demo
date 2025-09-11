#!/bin/bash

# LiveKit 开发环境启动脚本
# 只启动LiveKit Server相关服务，前端本地运行

echo "🚀 启动LiveKit开发环境"
echo "=========================="

# 停止现有服务
echo "🛑 停止现有服务..."
docker-compose down

# 启动LiveKit相关服务
echo "🚀 启动LiveKit服务..."
docker-compose up -d redis livekit-server livekit-egress

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 5

# 检查服务状态
echo "📊 服务状态检查..."
docker-compose ps

echo ""
echo "🔍 检查LiveKit Server连接..."
# 等待LiveKit Server完全启动
for i in {1..10}; do
    if curl -s http://127.0.0.1:7880 > /dev/null 2>&1; then
        echo "✅ LiveKit Server 启动成功！"
        break
    else
        echo "⏳ 等待LiveKit Server启动... ($i/10)"
        sleep 2
    fi
done

echo ""
echo "✅ 开发环境启动完成！"
echo "=========================="
echo "🔧 服务信息:"
echo "   LiveKit Server: ws://127.0.0.1:7880"
echo "   LiveKit HTTP: http://127.0.0.1:7880"
echo "   Redis: 127.0.0.1:6379"
echo "   Egress: 127.0.0.1:8080"
echo ""
echo "📋 下一步:"
echo "   1. 进入meet目录: cd meet"
echo "   2. 安装依赖: npm install 或 pnpm install"
echo "   3. 启动前端: npm run dev 或 pnpm dev"
echo ""
echo "🔧 管理命令:"
echo "   查看日志: docker-compose logs -f livekit-server"
echo "   停止服务: docker-compose down"
echo "=========================="
