## ADDED Requirements

### Requirement: Build and publish the knowledge site to OSS
The system SHALL build the current `hc-knowledge` multilingual Markdown source using the existing static-site builder and publish the resulting site to the root of the `hc-hw-assets` OSS bucket.

#### Scenario: Successful non-preview deployment
- **WHEN** an authorized deployment workflow runs with a valid knowledge source and a successful static-site build
- **THEN** the workflow SHALL upload the generated site, including `index.html`, to the `hc-hw-assets` bucket root and report the deployed object set without exposing credentials

#### Scenario: Invalid build output blocks deployment
- **WHEN** the generated output is empty or does not contain `index.html`
- **THEN** the deployment workflow SHALL fail before uploading or deleting any OSS objects

#### Scenario: Preview mode remains non-mutating
- **WHEN** a maintainer starts the workflow in preview mode
- **THEN** the workflow SHALL build and retain the deploy artifact but SHALL NOT write, overwrite, or delete OSS objects

### Requirement: Restrict the publishing identity
The deployment workflow SHALL use a dedicated RAM publishing identity whose OSS permissions are limited to listing `hc-hw-assets` and reading, writing, or deleting objects within that bucket. The identity MUST NOT be granted permission to alter bucket ACLs, delete the bucket, or administer OSS resources outside the target bucket.

#### Scenario: Deployment credentials are secret-backed
- **WHEN** the deployment workflow authenticates to Alibaba Cloud
- **THEN** it SHALL read its credentials from GitHub Actions secrets or short-lived role credentials and SHALL NOT commit, print, or place the credential values in deployment artifacts

#### Scenario: Bucket management is denied to the publisher
- **WHEN** the publishing identity attempts to change the target bucket ACL or delete the target bucket
- **THEN** Alibaba Cloud authorization SHALL deny the operation

### Requirement: Serve a public static knowledge site
The `hc-hw-assets` bucket SHALL serve the published site as an OSS static website, with anonymous read access enabled and anonymous write, overwrite, and delete access disabled.

#### Scenario: Public homepage readback
- **WHEN** an unauthenticated visitor requests the configured static website homepage after a successful deployment
- **THEN** the service SHALL return the generated `index.html` content successfully

#### Scenario: Anonymous object write is rejected
- **WHEN** an unauthenticated caller attempts to upload, overwrite, or delete an object in `hc-hw-assets`
- **THEN** OSS SHALL reject the request

### Requirement: Provide the knowledge custom domain
The published website SHALL be reachable over HTTPS through `knowledge-assets.hiredchina.com`, which is bound as the OSS custom domain for this site.

#### Scenario: Domain readback after DNS configuration
- **WHEN** the custom-domain DNS and certificate configuration are active
- **THEN** an unauthenticated HTTPS request to `knowledge-assets.hiredchina.com` SHALL return the same published homepage as the OSS static website endpoint

### Requirement: Preserve a reversible first release
The first release SHALL not require Alibaba Cloud CDN, Cloudflare CDN, Cloudflare Workers, or changes to `hcapi` Qiniu integrations. The existing GitHub Pages deployment route SHALL remain available until OSS endpoint and custom-domain acceptance checks pass.

#### Scenario: OSS acceptance failure
- **WHEN** the OSS endpoint or custom domain fails the required public readback check
- **THEN** maintainers SHALL retain or restore the GitHub Pages route without changing the knowledge Markdown source
