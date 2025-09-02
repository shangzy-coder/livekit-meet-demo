#!/bin/bash

# LiveKit Meet with Recording 启动脚本

echo "🚀 启动 LiveKit Meet 与录制功能..."

# 创建录制文件目录
echo "📁 创建录制文件目录..."
mkdir -p recordings
mkdir -p recordings/backup

# 设置录制目录权限（确保容器可以写入）
chmod 777 recordings
chmod 777 recordings/backup

# 检查Docker和Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 停止现有容器（如果存在）
echo "🛑 停止现有容器..."
docker-compose down

# 拉取最新镜像
echo "📥 拉取最新镜像..."
docker-compose pull

# 启动服务
echo "🔄 启动服务..."
docker-compose up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "🔍 检查服务状态..."
docker-compose ps

echo ""
echo "✅ 服务启动完成！"
echo ""
echo "📋 访问地址："
echo "  🌐 Meet 应用: http://localhost:3000"
echo "  🔧 LiveKit Server: http://localhost:7880"
echo "  📊 Egress 健康检查: http://localhost:8080"
echo "  📈 Prometheus 指标: http://localhost:9090"
echo ""
echo "📹 录制功能："
echo "  📁 录制文件保存在: ./recordings/"
echo "  🔧 配置文件: ./egress-config.yaml"
echo ""
echo "🛠️ 管理命令："
echo "  查看日志: docker-compose logs -f"
echo "  停止服务: docker-compose down"
echo "  重启服务: docker-compose restart"
echo ""
echo "📖 录制使用说明："
echo "  1. 在 Meet 应用中创建或加入房间"
echo "  2. 使用 LiveKit CLI 或 API 启动录制"
echo "  3. 录制文件将自动保存到 ./recordings/ 目录"
echo ""
echo "🔗 LiveKit CLI 安装："
echo "  curl -sSL https://get.livekit.io | bash"
echo ""
echo "📝 录制示例命令："
echo "  lk egress start room-composite \\"
echo "    --room-name your-room-name \\"
echo "    --layout speaker \\"
echo "    --output ./recordings/recording.mp4"
