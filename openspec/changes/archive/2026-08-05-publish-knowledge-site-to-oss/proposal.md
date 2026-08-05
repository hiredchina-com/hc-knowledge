## Why

`hc-knowledge` 目前只能通过 GitHub Pages 发布，公开知识库没有独立的对象存储发布边界，也无法使用已创建的阿里云 OSS 桶作为统一静态站点承载。需要以最小架构把 Markdown 知识库构建并发布为可通过 `knowledge-assets.hiredchina.com` 访问的公开页面服务。

第一阶段优先验证稳定、可回滚的 OSS 站点发布链路；不引入 CDN、Cloudflare Worker 或私有桶回源鉴权等额外运行组件。

## What Changes

- 新增将 `hc-knowledge` 内容构建为静态 HTML 并发布到阿里云 OSS `hc-hw-assets` 的发布能力。
- 使用 `knowledge-assets.hiredchina.com` 作为公开站点域名，并为 OSS 配置静态网站入口和错误页。
- 将 GitHub Actions 的部署目标从 `gh-pages` 改为受限 RAM 身份写入 OSS；部署身份仅能操作该桶中的知识库站点对象。
- 桶 ACL 设为 `public-read`，只允许匿名读取公开站点产物；匿名写入、覆盖和删除必须保持禁止。
- 为发布链路增加构建、上传、公开域名读取和回滚到 GitHub Pages 的可验证验收步骤。
- 明确第一阶段不配置阿里云 CDN、Cloudflare CDN/Worker、CDN 缓存刷新或迁移 `hcapi` 现有七牛业务资源。

## Capabilities

### New Capabilities

- `public-knowledge-site-publishing`: 将 `hc-knowledge` 的多语言 Markdown 构建产物以最小权限发布到 OSS，并通过公开自定义域名提供静态页面服务。

### Modified Capabilities

- 无。

## Impact

- `hc-knowledge`：新增 OpenSpec、发布工作流与部署说明；保留知识库内容和构建输入格式不变。
- `hc-hw`：现有 `bin/build-knowledge-site.sh` 继续作为构建入口；需要新增或替换 GitHub Actions 的 OSS 部署步骤，以及对应的部署脚本和设计回归测试。
- 阿里云 OSS：使用已创建的 `hc-hw-assets`（`oss-cn-shenzhen`）作为专用公开知识库站点桶。
- DNS：需要将 `knowledge-assets.hiredchina.com` 绑定为该 OSS 站点的自定义域名。
- 凭据：新增专用 RAM 发布身份；AccessKey 仅存放于 GitHub Actions Secrets，不进入 Git、构建日志、OpenSpec 或本地模板。
