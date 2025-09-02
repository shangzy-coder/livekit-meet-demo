# LiveKit Meet Demo

基于 LiveKit 官方示例的简单视频会议应用。

## 项目特点

- 基于 Next.js + LiveKit Components
- 无需复杂认证配置
- 开箱即用的视频会议功能
- Docker 容器化部署

## 快速部署

1. 上传整个文件夹到服务器
2. 进入项目目录
3. 运行：`docker-compose up -d --build`
4. 访问：`http://你的服务器IP:3000`

## 配置说明

- LiveKit Server 端口：7880 (WebSocket), 7881 (TCP), 50000-60000 (UDP)
- Meet 应用端口：3000
- API Key: devkey
- API Secret: secret

## 功能

- 创建/加入会议室
- 音视频通话
- 屏幕共享
- 聊天功能
- 设备设置

## 注意事项

- 确保防火墙开放相关端口
- UDP 端口范围 50000-60000 用于 WebRTC 媒体传输
- 生产环境建议使用 HTTPS 和真实的 API 密钥