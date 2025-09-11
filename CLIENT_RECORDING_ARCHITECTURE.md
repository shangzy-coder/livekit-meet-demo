# LiveKit Meet 客户端录制架构

## 概述

本项目已从服务端录制（Egress）迁移到客户端录制方案，提供更灵活和轻量的录制功能。

## 架构变更

### 移除的服务
- **LiveKit Egress**: 不再需要服务端录制服务
- **Redis**: 原用于 Egress 和 LiveKit Server 通信，现已移除

### 保留的服务
- **LiveKit Server**: 核心信令和媒体服务器
- **MinIO** (可选): S3 兼容的对象存储，可用于集中存储录制文件

## 客户端录制特性

- 使用浏览器原生 MediaRecorder API
- 自动录制当前标签页（Chrome 109+）
- 合并所有参与者的音频流
- 支持本地存储和云端上传

## 部署指南

### 启动服务

```bash
# 启动 LiveKit Server（和可选的 MinIO）
docker-compose up -d

# 如果不需要 MinIO，可以只启动 LiveKit Server
docker-compose up -d livekit-server
```

### 停止服务

```bash
docker-compose down
```

## 配置说明

### LiveKit Server
- WebSocket/HTTP API: 7880 端口
- TCP for WebRTC: 7881 端口
- UDP for WebRTC: 50000-50100 端口范围

### MinIO (可选)
- API 端口: 9000
- Web 控制台: 9001
- 默认凭据: minioadmin/minioadmin

## 录制文件存储

- **本地模式**: 文件保存在 `meet/public/recordings/` 目录
- **MinIO 模式**: 文件上传到 MinIO 的 `livekit-recordings` 存储桶

## 优势

1. **更低的资源消耗**: 不需要运行 Egress 服务和 Redis
2. **更简单的部署**: 减少了服务依赖
3. **更好的用户体验**: 录制用户看到的实际画面
4. **更灵活的控制**: 用户可以自主控制录制
