## 背景

上一版 OSS 发布 proposal 在发布管线、桶配置、DNS 绑定和验收证据均未完成前被归档。现重新激活该 change，使已经确认的公开知识库网站需求具备可执行的实现计划。

## 变更内容

- 在 `hc-knowledge` 与 `hc-hw` 交付链路中实现既有 `public-knowledge-site-publishing` 规格。
- 将 `hc-knowledge` 构建为静态网站，并发布到专用 OSS 桶 `hc-hw-assets` 根目录。
- 将桶配置为仅公共读的 OSS 静态网站，并通过 `knowledge-assets.hiredchina.com` 对外访问。
- 将 GitHub Actions 的 `gh-pages` 发布步骤替换为由 Secret 支撑、最小权限的 OSS 发布步骤，同时保留 GitHub Pages 回滚能力。
- 本次发布不引入阿里云 CDN、Cloudflare、Worker，也不迁移 Qiniu 业务资源。

## 能力范围

### 新增能力

- 无。

### 修改能力

- `public-knowledge-site-publishing`：补充实现已确认发布行为所需的发布管线、OSS 桶边界、自定义域名发布闸门和可逆发布要求。

## 影响范围

- `hc-knowledge`：活动 OpenSpec change 与内容源侧发布验收。
- `hc-hw`：OSS 发布脚本、GitHub Actions 工作流、命令文档和设计测试。
- 阿里云 OSS/DNS：需要配置 `hc-hw-assets` 与 `knowledge-assets.hiredchina.com`，并做独立回读。
- 凭据：专用 RAM 发布身份仅保存在 GitHub Actions Secrets。
