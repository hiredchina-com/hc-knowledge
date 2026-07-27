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

## 贡献

请查看 [CONTRIBUTING.md](./CONTRIBUTING.md)

## 反馈

- 🐛 Bug 反馈：[提交 Issue](https://github.com/hiredchina-com/hc-knowledge/issues/new?template=bug_report.yml)
- 💡 需求建议：[提交 Issue](https://github.com/hiredchina-com/hc-knowledge/issues/new?template=feature_request.yml)
