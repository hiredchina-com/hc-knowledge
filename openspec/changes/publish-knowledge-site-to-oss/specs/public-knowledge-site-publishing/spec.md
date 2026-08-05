## MODIFIED Requirements

### Requirement: 构建并发布知识库网站到 OSS
系统 MUST 通过 `hc-hw` 静态网站构建器构建当前 `hc-knowledge` 多语言 Markdown 源，并将产物发布到专用 OSS 桶 `hc-hw-assets` 根目录。

#### Scenario: 非 preview 发布成功
- **WHEN** 获授权的发布工作流使用有效知识库源并成功完成静态网站构建
- **THEN** 工作流必须将包含 `index.html` 的网站产物上传到 `hc-hw-assets` 桶根目录，并在不暴露凭据的前提下报告已发布对象集合

#### Scenario: 构建输出无效时阻止发布
- **WHEN** 构建输出为空或不包含 `index.html`
- **THEN** 发布工作流必须在上传或删除任何 OSS 对象前失败

#### Scenario: preview 模式不修改远端
- **WHEN** 维护者以 preview 模式启动工作流
- **THEN** 工作流必须构建并保留发布产物，但不得写入、覆盖或删除 OSS 对象

### Requirement: 限制发布身份权限
发布工作流 MUST 使用专用 RAM 发布身份；其 OSS 权限仅限列举 `hc-hw-assets`，以及读取、写入或删除该桶内对象。该身份不得拥有修改桶 ACL、删除桶或管理目标桶外 OSS 资源的权限。

#### Scenario: 发布凭据由 Secret 提供
- **WHEN** 发布工作流认证阿里云
- **THEN** 它必须从 GitHub Actions Secret 或短期角色凭据读取凭据值，且不得提交、打印或将凭据值写入发布产物

#### Scenario: 发布身份被拒绝管理桶
- **WHEN** 发布身份尝试修改目标桶 ACL 或删除目标桶
- **THEN** 阿里云授权必须拒绝该操作

### Requirement: 提供公开静态知识库网站
`hc-hw-assets` 桶 MUST 以 OSS 静态网站方式提供已发布网站，允许匿名读取，并禁止匿名写入、覆盖和删除。

#### Scenario: 公开首页回读
- **WHEN** 未认证访客在成功发布后请求已配置静态网站首页
- **THEN** 服务必须成功返回生成的 `index.html` 内容

#### Scenario: 拒绝匿名对象写入
- **WHEN** 未认证调用者尝试在 `hc-hw-assets` 中上传、覆盖或删除对象
- **THEN** OSS 必须拒绝该请求

### Requirement: 提供知识库自定义域名
已发布网站 MUST 可通过 HTTPS 和 `knowledge-assets.hiredchina.com` 访问；该域名必须绑定为本网站的 OSS 自定义域名。

#### Scenario: DNS 配置后的域名回读
- **WHEN** 自定义域名的 DNS 与证书配置已生效
- **THEN** 对 `knowledge-assets.hiredchina.com` 的未认证 HTTPS 请求必须返回与 OSS 静态网站 endpoint 相同的已发布首页

### Requirement: 保持首版可逆
首版 MUST 不依赖阿里云 CDN、Cloudflare CDN、Cloudflare Worker，也不得修改 `hcapi` 的 Qiniu 集成。在 OSS endpoint 和自定义域名验收通过前，既有 GitHub Pages 发布路径必须保持可用。

#### Scenario: OSS 验收失败
- **WHEN** OSS endpoint 或自定义域名未通过要求的公开回读检查
- **THEN** 维护者必须在不修改知识库 Markdown 源的前提下保留或恢复 GitHub Pages 路径
