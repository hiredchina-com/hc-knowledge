# hc-knowledge

HiredChina 业务知识库（公开仓库）

## 关于

本仓库是 HiredChina 求职平台的公开知识库，包含：
- 多语言 FAQ（常见问题）
- 使用指南
- 产品说明
- Bug 反馈和需求建议（GitHub Issues）

所有内容由 [hc-ai-cs](https://github.com/hiredchina-com/hc-ai-cs) AI 客服系统读取并推荐给用户。

## 多语言支持

| 语言 | 目录 | 状态 |
| ---- | ---- | ---- |
| 简体中文 | [zh/](./zh/) | ✅ |
| English | [en/](./en/) | ✅ |

## 结构

```
hc-knowledge/
├── {locale}/
│   ├── knowledge/
│   │   ├── faq/        # 常见问题
│   │   ├── guide/      # 使用指南
│   │   └── product/    # 产品说明
│   └── knowledge-index.json
├── .github/ISSUE_TEMPLATE/
├── README.md
└── CONTRIBUTING.md
```

## 公开站点与自动发布

本仓库的内容发布为公开帮助中心：
[`https://wiki.hiredchina.com`](https://wiki.hiredchina.com)。站点由 Cloudflare Pages 承载，
但本仓库**不直接持有 Cloudflare 凭据，也不直接部署**；构建与发布统一由
[`hiredchina-com/hc-hw`](https://github.com/hiredchina-com/hc-hw) 执行。

### 哪些变更会自动发布

当变更合并到 `main`，且涉及以下任一路径时，GitHub Actions 会通知 `hc-hw` 发布：

- `zh/knowledge/**/*.md`
- `en/knowledge/**/*.md`
- `zh/knowledge-index.json`
- `en/knowledge-index.json`

索引文件决定文章导航和分类，因此它与文章 Markdown 一样属于内容发布范围。README、
Issue 模板、贡献指南或其他非内容文件的更新不会触发站点发布。

### 跨仓触发链路

工作流文件为
[`.github/workflows/trigger-hc-hw-pages.yml`](./.github/workflows/trigger-hc-hw-pages.yml)：

1. `main` 上的文章或索引变更触发该工作流；
2. 工作流向 `hiredchina-com/hc-hw` 发送 `repository_dispatch` 事件
   `knowledge-content-updated`，并附带来源仓库和 commit SHA；
3. `hc-hw` 拉取最新 `hc-knowledge/main`，生成静态 HTML 并发布到 Cloudflare Pages；
4. Cloudflare Pages 将新版本提供给 `wiki.hiredchina.com`。

此设计让文章仓只负责内容，让 `hc-hw` 集中管理站点模板、构建校验和 Cloudflare 权限。

### 必需的 GitHub Secret

在 `hiredchina-com/hc-knowledge` 设置 Actions Secret：`HC_HW_DISPATCH_TOKEN`。
它应是一个 fine-grained GitHub PAT，资源所有者为 `hiredchina-com`，仅授权目标仓库
`hc-hw`，并授予 `Contents: Read and write`。该权限仅用于创建 repository dispatch 事件，
不应使用 Cloudflare Token 或广泛的组织级 Token 替代。

Secret 缺失时，文章提交本身不受影响，但触发工作流会在开始时失败并明确提示缺少
`HC_HW_DISPATCH_TOKEN`。配置或轮换 Token 后，下一次符合路径规则的内容合并会自动发布。

### 内容作者的发布检查

合并文章后，在本仓库 Actions 中确认 `Trigger hc-hw knowledge Pages publish` 成功；随后到
`hc-hw` 的 `Deploy hc-knowledge to Cloudflare Pages` 运行记录确认构建与 Cloudflare 发布成功。
最后访问 `https://wiki.hiredchina.com/knowledge/...` 验证公开页面。

## 贡献

请查看 [CONTRIBUTING.md](./CONTRIBUTING.md)

## 反馈

- 🐛 Bug 反馈：[提交 Issue](https://github.com/hiredchina-com/hc-knowledge/issues/new?template=bug_report.yml)
- 💡 需求建议：[提交 Issue](https://github.com/hiredchina-com/hc-knowledge/issues/new?template=feature_request.yml)
