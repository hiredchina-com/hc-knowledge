# Contributing to hc-knowledge

感谢您对 HiredChina 知识库的贡献！

## 如何贡献

### 1. 提交 Bug 或需求建议

请使用 GitHub Issues：
- 🐛 [Bug 反馈](https://github.com/hiredchina-com/hc-knowledge/issues/new?template=bug_report.yml)
- 💡 [需求建议](https://github.com/hiredchina-com/hc-knowledge/issues/new?template=feature_request.yml)

### 2. 贡献知识库内容

如果您想添加或修改知识库内容：

1. Fork 本仓库
2. 在对应的语言目录下创建或修改文件（`zh/` 或 `en/`）
3. 更新对应语言的 `knowledge-index.json`，添加新条目的元数据
4. 提交 Pull Request

### 3. 多语言翻译

我们欢迎多语言贡献：

- 如果您发现某个内容缺少您的语言版本，可以添加翻译
- 翻译文件应放在对应语言代码的目录下（如 `es/`、`fr/`、`de/`）
- 翻译的结构应与英文版保持一致

## 内容规范

### 文件结构

```
{locale}/
├── faq/              # 常见问题
├── guides/           # 使用指南
├── product-overview/ # 产品说明
├── changelog/        # 更新日志
└── knowledge-index.json
```

> 注意：`category` 字段需要与上述目录名保持一致，分别为 `faq`、`guides`、`product-overview`、`changelog`。

### Markdown 文件格式

- 文件以 `# 标题` 开头（不要使用 YAML frontmatter）
- 内容建议采用「步骤 / 异常分支 / 最佳实践」三段式结构
- 使用列表化表达，便于 AI 客服抽取和用户阅读
- 文件结尾统一添加：
  ```markdown
  ---
  *最后更新：YYYY-MM-DD*
  ```
- 文件名使用小写英文和连字符，例如 `account-register.md`

### knowledge-index.json 格式

```json
{
  "id": "faq-account-001",
  "title": "文章标题",
  "keywords": ["关键词1", "关键词2"],
  "path": "zh/faq/xxx.md",
  "category": "faq",
  "weight": 5
}
```

- `id`: 唯一标识符（格式：{类别}-{主题}-{序号}）
- `keywords`: 用户可能搜索的关键词（用于匹配算法）
- `path`: 文件相对仓库根目录的路径，必须与文件实际位置一致
- `category`: 必须与目录名对齐，可选 `faq` / `guides` / `product-overview` / `changelog`
- `weight`: 权重 1-5，越高越优先推荐

## 提交 Pull Request

1. 确保您的改动符合上述规范
2. 同时更新对应语言的 `knowledge-index.json`
3. PR 描述中请说明改动内容
4. 等待团队审核

---

感谢您的贡献！❤️
