#!/bin/bash

# LiveKit Meet 智能启动脚本
# 自动检测主机IP并启动服务

echo "🚀 LiveKit Meet 启动脚本"
echo "=========================="

# 函数：获取主机IP
get_host_ip() {
    # 方法1：尝试获取默认路由的IP
    local ip=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' | head -1)
    
    # 方法2：如果方法1失败，尝试hostname -I
    if [ -z "$ip" ]; then
        ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    fi
    
    # 方法3：如果还是失败，尝试ifconfig
    if [ -z "$ip" ]; then
        ip=$(ifconfig 2>/dev/null | grep -E "inet.*broadcast" | awk '{print $2}' | head -1)
    fi
    
    # 方法4：最后尝试ip addr
    if [ -z "$ip" ]; then
        ip=$(ip addr show 2>/dev/null | grep -E "inet.*scope global" | awk '{print $2}' | cut -d'/' -f1 | head -1)
    fi
    
    echo "$ip"
}

# 检测主机IP
echo "🔍 检测主机IP地址..."
HOST_IP=$(get_host_ip)

if [ -z "$HOST_IP" ]; then
    echo "⚠️  无法自动检测IP地址，使用localhost"
    HOST_IP="localhost"
else
    echo "✅ 检测到主机IP: $HOST_IP"
fi

# 询问用户是否使用检测到的IP
echo ""
echo "检测到的IP地址: $HOST_IP"
read -p "是否使用此IP？(y/n，默认y): " confirm
confirm=${confirm:-y}

if [[ $confirm != [yY] ]]; then
    read -p "请输入您的IP地址: " custom_ip
    if [ -n "$custom_ip" ]; then
        HOST_IP="$custom_ip"
    fi
fi

# 更新.env文件
echo "📝 更新配置文件..."
echo "HOST_IP=$HOST_IP" > .env
echo "✅ 已设置 HOST_IP=$HOST_IP"

# 停止现有服务
echo ""
echo "🛑 停止现有服务..."
docker-compose down

# 启动服务
echo ""
echo "🚀 启动LiveKit Meet服务..."
docker-compose up -d --build

# 等待服务启动
echo ""
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo ""
echo "📊 服务状态检查..."
docker-compose ps

echo ""
echo "✅ 启动完成！"
echo "=========================="
echo "📱 访问地址:"
echo "   Meet应用: http://$HOST_IP:3000"
echo "   LiveKit Server: ws://$HOST_IP:7880"
echo ""
echo "🔧 服务端口:"
echo "   Meet Web UI: 3000"
echo "   LiveKit Server: 7880"
echo "   Redis: 6379"
echo "   Egress: 8080"
echo ""
echo "📋 管理命令:"
echo "   查看日志: docker-compose logs -f"
echo "   停止服务: docker-compose down"
echo "   重启服务: docker-compose restart"
echo "=========================="
