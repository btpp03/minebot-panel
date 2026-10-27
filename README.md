# minebot-panel（纯净版）

Minecraft 挂机机器人面板 —— 从 [`guanxi660-crypto/minebot-standalone`](https://github.com/guanxi660-crypto/minebot-standalone)（MIT）裁剪而来的**纯面板版**。

## 和上游的区别（只做了删减，没改业务逻辑）

上游仓库带两个与本面板无关的模块，本仓库**完全不含**：

| 模块 | 上游行为 | 本仓库 |
|---|---|---|
| `core` | 从外部 CDN 下载 45MB `sbx.so` + 30MB `bot.so`（无校验和/签名），改名伪装后用 FFI 在 Node 进程内加载，起 sing-box / cloudflared | 已删除，文件不存在 |
| `status` | 类似哪吒 agent 的 gRPC 指标上报（CPU/内存/磁盘/网络/负载） | 已删除，文件不存在 |

同时从 `package.json` 去掉了只有这两个模块才用到的依赖（`koffi`、`@grpc/grpc-js`、`@grpc/proto-loader`、`systeminformation`），
`node_modules` 从 700MB+ 降到约 480MB（其中 433MB 是 `minecraft-data` 的版本数据，跑机器人必需）。

> `index.js` 里仍保留"扩展模块未安装则跳过"的容错逻辑，`/api/core` 只是返回未启用的空壳接口，不会下载或执行任何东西。

## 功能

- 多 bot 挂机、崩溃自动重连、定时重启
- 拟人巡逻 / 定时喊话
- AI 视角开关
- 翼龙（Pterodactyl）文件管理与电源控制
- 单页网页控制台

## 部署方式（三种，按需选）

### A. Node 直接跑（推荐 VPS / 有 Node 的容器）

```bash
npm install --omit=dev
ADMIN_USER=admin ADMIN_PASSWORD='改成你的强密码' PORT=4681 node index.js
```

### B. Docker

```bash
docker build -t minebot-panel .
docker run -d --name minebot -p 4681:4681 \
  -e ADMIN_PASSWORD='改成你的强密码' \
  -v "$PWD/data:/app/data" \
  minebot-panel
```

### C. 云平台（Dockerfile 构建）

仓库根目录自带 `Dockerfile`，直接把本仓库地址交给平台（如 blitz.cloud / Railway / Zeabur）：

- 构建方式：Dockerfile
- 容器端口：`4681`
- 环境变量：至少设 `ADMIN_PASSWORD`；若平台注入 `PORT`，已自动兼容

## ⚠️ 部署后必做

1. **立刻改掉默认口令**（默认 `admin/admin123`，登录接口没有限速）。
2. 不要裸暴露端口 —— 前面加一层 Nginx / Cloudflare Access，或只放在内网。
3. `bots_config.json` 里的翼龙 API key 是**明文**存的，面板一旦被登录等于游戏服被接管。
4. 平台的免费实例常有"闲置自动休眠"（如 blitz.cloud 30 分钟无访问就睡），需要外部定时 ping 保活，否则 bot 会掉线。

## 许可证

MIT，随上游。原版权声明见 `LICENSE`（Copyright (c) 2025 guanxi660-crypto）。
