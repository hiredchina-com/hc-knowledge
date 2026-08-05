# hc-knowledge 项目指令

> 本文件是 `hc-knowledge` 仓库的唯一指令源。`CLAUDE.md` 是指向本文件的 symlink。
> 继承自父级 `hc-hw/AGENTS.md` 的通用规则；本文件仅补充本仓库的特定约定。冲突时以本文件为准（仓库内 > 跨仓库）。

## Goal

`hc-knowledge` 是 HiredChina 求职平台的公开多语言知识库，由 `hc-ai-cs` AI 客服系统读取并推荐给用户。仓库内容按语言分目录（`zh/`、`en/`），以 Markdown 为主体，不含应用代码。

## Conventions

### 语言

- **项目指令 / 系统提示 / 设计文档 / openspec 内容**：默认中文编写。
- **代码注释**：中文优先，专有名词保留英文。
- **知识库正文**：按 locale 目录对应语言 —— `zh/` 下中文、`en/` 下英文。同一份知识在多语言目录下应当语义对齐，但不要求逐字翻译。

### 目录

```
hc-knowledge/
├── {locale}/                       # zh | en | 未来其他语言
│   ├── knowledge/
│   │   ├── faq/                    # 常见问题
│   │   ├── guide/                  # 使用指南
│   │   └── product/                # 产品说明
│   └── knowledge-index.json        # 该语言的索引清单
├── openspec/
│   ├── specs/                      # 能力规约（中文）
│   └── changes/                    # 变更归档（中文）
│       └── <date>-<slug>/
│           ├── proposal.md
│           ├── design.md
│           ├── tasks.md
│           └── specs/              # 本次变更涉及的 spec 增量
├── .github/ISSUE_TEMPLATE/
├── README.md
└── CONTRIBUTING.md
```

### openspec

openspec 目录下的所有内容（`specs/` 和 `changes/`）必须使用中文编写，包括：

- `proposal.md` —— 变更提案（背景、目标、非目标）
- `design.md` —— 设计决策（上下文、决策、风险、迁移计划、开放问题）
- `tasks.md` —— 任务拆分
- `specs/**/spec.md` —— 能力规约
- `.openspec.yaml` 的 `title` / `description` 字段

`spec.md` 中的代码示例、命令、URL、字段名等技术标识符保留英文原文。

**规范性优先级**：OpenSpec 的中文正文是唯一规范性真相源。若为了外部沟通另附英文翻译，翻译必须标注为非规范性参考；需求、验收、冲突裁定与归档均以中文正文为准。OpenSpec 解析所需的结构标识（如 `Requirement`、`Scenario`、`ADDED Requirements`）可保留英文。

### 提交

- 沿用父级前缀：`[feat]` / `[fix]` / `[refactor]` / `[harness]` 等。
- 知识库正文变更建议附带影响的 locale 路径，例如 `[feat] zh/faq: 新增面试流程 FAQ`。
- openspec 变更归档建议以日期+slug 命名目录，例如 `2026-08-05-publish-knowledge-site-to-oss/`。

## Do-not

- **不要** 在 `openspec/` 下写入英文正文（技术标识符除外）。
- **不要** 混用语言 —— 一份文件只对应一种语言；跨语言内容放到对应 `locale/` 目录。
- **不要** 把应用代码、CI 脚本、构建产物放到本仓库 —— 这些属于 `hc-hw`。
- **不要** 直接修改 `knowledge-index.json` 而不更新对应的 Markdown 源文件。

## Context

- 本仓库由 `hc-hw` 的 `bin/build-knowledge-site.sh` 读取并构建为静态站点。
- 发布管线（OSS / GitHub Pages）属于 `hc-hw` 的工具链，不在本仓库维护。
- 多语言约定：新增语言时新增顶级目录（如 `ja/`），不要复用现有 locale 目录。
