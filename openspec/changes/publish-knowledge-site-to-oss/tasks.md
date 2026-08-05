## 归属说明

本 change 跨两个仓库执行：

- **本仓库（hc-knowledge）**：§3.2 中内容源侧验证 + §3.4 内容验收记录。
- **hc-hw**：§1 云资源、§2 发布脚本与工作流、§3.1/3.3 自动化检查。
- **阿里云控制台**：§1 中 OSS/RAM/DNS 配置。

跨仓任务由 `hc-hw` 在其 `local/<req-id>/worktrees/...` 中落地；本仓库不包含发布脚本、CI 配置或构建产物。

## 1. OSS 与域名前置条件（归属：阿里云 + hc-hw）

- [ ] 1.1 在允许根目录删除同步前，确认 `hc-hw-assets` 为空且专用于公开知识库网站。
- [ ] 1.2 配置 OSS 静态网站托管（`index.html`、`404.html`）并将桶 ACL 设为 `public-read`；独立验证匿名上传、覆盖和删除均被拒绝。
- [ ] 1.3 创建最小权限的 `hc-knowledge-publisher` RAM 身份，仅将凭据保存到 GitHub Actions Secrets，并验证其变更桶 ACL 或删除桶的操作被拒绝。
- [ ] 1.4 将 `knowledge-assets.hiredchina.com` 绑定为 OSS 自定义域名，配置 HTTPS；本次若有 Cloudflare DNS 记录则保持 DNS-only。

## 2. 发布实现（归属：hc-hw）

- [ ] 2.1 在 `hc-hw` 新增带防护的 OSS 发布脚本：构建网站、要求输出非空且存在 `index.html`，并支持不产生写操作的 preview 模式。
- [ ] 2.2 在不通过命令行参数接收凭据的前提下，实现到 `oss://hc-hw-assets/` 的桶根目录同步；仅在构建防护通过后执行删除。
- [ ] 2.3 更新知识库 GitHub Actions 工作流：保留构建产物，并在非 preview 运行中使用专用发布 Secret 部署到 OSS，而非推送 `gh-pages`。
- [ ] 2.4 在 OSS endpoint 和自定义域名验收完成前，保留 GitHub Pages 发布路径并记录回滚选择。

## 3. 验证与发布验收

### 3.1 自动化检查（归属：hc-hw）

- [ ] 3.1.1 发布帮助、preview 不写入、`index.html` 防护、桶范围以及已提交模板中不存在凭据值。

### 3.2 内容源侧验证（归属：hc-knowledge）

- [x] 3.2.1 `knowledge-index.json` 中声明的所有 `path` 在磁盘上均存在且非空。
- [x] 3.2.2 中英文内容在条目集合上对齐（相同 id 集合，相同 category/weight 结构）。
- [x] 3.2.3 所有 Markdown 文件以一级标题开头，与 `knowledge-index.json` 的 `title` 字段语义一致。

### 3.3 端到端运行（归属：hc-hw）

- [ ] 3.3.1 运行静态网站构建、受影响的设计测试、`openspec validate publish-knowledge-site-to-oss --strict` 与 `git diff --check`。
- [ ] 3.3.2 运行一次 preview 和一次受控发布；独立回读 OSS endpoint 与 `https://knowledge-assets.hiredchina.com` 的首页。

### 3.4 验收记录（归属：shared）

- [ ] 3.4.1 hc-hw 侧：在提交 `READY_FOR_ACCEPTANCE` 前，记录 endpoint/域名回读、匿名写入拒绝、流量/账单告警、回滚说明和任何 CDN 后续决策。
- [ ] 3.4.2 hc-knowledge 侧：在 hc-hw 完成受控发布且域名回读通过后，更新本文件的验收状态并补充回读 URL 与时间戳。
