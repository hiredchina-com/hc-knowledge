## 上下文

已归档 change 创建了规范性 `public-knowledge-site-publishing` 规格，但尚未实现 OSS 发布管线，也没有任何线上验收证据。`hc-knowledge` 负责内容，`hc-hw` 负责既有静态网站构建器与 GitHub Actions 发布工作流。`hc-hw-assets` 位于 `oss-cn-shenzhen`，当前为私有桶。

## 目标与非目标

**目标：**

- 以最小发布链路实现已确认的 OSS 发布行为。
- 将构建产物发布到专用桶根目录，通过指定自定义域名公开访问，并保留 GitHub Pages 回滚。
- 使用无法管理桶或其他 OSS 资源、由 Secret 提供凭据的 RAM 发布身份。

**非目标：**

- CDN、Worker、Cloudflare 代理、私有源站签名、Qiniu 迁移、动态页面、搜索 API 和用户上传。

## 决策

### 直接使用仅公共读的 OSS 静态网站

将 `hc-hw-assets` 配置为 OSS 静态网站和仅公共读，避免首版引入 CDN 与签名层。匿名调用者仍不得写入、覆盖或删除对象。

私有 OSS 加阿里云 CDN，以及 Cloudflare Worker 签名均延期处理，因为两者都增加了第二套内容分发/鉴权组件及独立运维验收。

### 专用桶根目录同步

构建产物发布到桶根目录，使 OSS 无需路径重写即可返回 `index.html`。仅当桶 owner 确认其中没有无关资源后，才允许根目录删除同步。发布脚本在任何写入或删除前必须拒绝空输出或缺少 `index.html` 的输出。

### 专用发布身份与 GitHub Secrets

使用 `hc-knowledge-publisher` RAM 身份：桶级仅 `ListObjects`，对象级仅 `GetObject`、`PutObject`、`DeleteObject`。AccessKey 只保存在 GitHub Actions Secrets。后续可替换为 OIDC，但不是本次前置条件。

### DNS-only 的自定义域名发布

将 `knowledge-assets.hiredchina.com` 绑定为 OSS 自定义域名，并独立验证 HTTPS。若 DNS 托管在 Cloudflare，本次仅使用 DNS-only。公开域名的实际响应是发布边界，OSS 控制台配置本身不构成验收。

## 风险与取舍

- [公开源站可被直接下载并产生费用] → 使用专用桶、配置账单/流量告警；达到实际使用阈值后再设计私有 OSS 加阿里云 CDN。
- [错误构建可能清空网站] → 同步/删除前强制检查输出非空且包含 `index.html`。
- [DNS/证书延迟] → 先验证 OSS endpoint，再验证自定义域名 HTTPS，最后才切换面向用户的入口。
- [OSS 切换失败] → 在独立 endpoint 与域名回读通过前保留 GitHub Pages 发布路径。

## 迁移计划

1. 确认桶专用性；配置静态网站、`public-read`、RAM 发布身份、GitHub Secrets、自定义域名和证书。
2. 在 `hc-hw` 实现并测试 preview 与带防护的 OSS 发布。
3. 运行一次受控发布，以匿名客户端回读 OSS endpoint 和自定义域名。
4. 在独立验收前保留 GitHub Pages；若任一回读失败，恢复其发布路径与 DNS 指向。

## 开放问题

- 谁负责配置 `knowledge-assets.hiredchina.com` 的 DNS 记录和证书？
- `hc-hw-assets` 是否已确认为空且专用于该站点？
- 哪个每月流量/费用阈值会触发后续“私有 OSS 加阿里云 CDN”设计？
