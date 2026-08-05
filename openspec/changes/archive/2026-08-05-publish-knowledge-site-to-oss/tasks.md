## 1. Alibaba Cloud and DNS prerequisites

- [ ] 1.1 Confirm `hc-hw-assets` is empty and dedicated to the public knowledge site before any root-level delete synchronization is enabled.
- [ ] 1.2 Configure `hc-hw-assets` as an OSS static website with `index.html` and `404.html`, set its ACL to `public-read`, and independently verify anonymous write, overwrite, and delete are denied.
- [ ] 1.3 Create the dedicated `hc-knowledge-publisher` RAM identity with only `oss:ListObjects`, `oss:GetObject`, `oss:PutObject`, and `oss:DeleteObject` permissions on `hc-hw-assets`; verify bucket ACL and deletion operations are denied.
- [ ] 1.4 Store the publisher credential only in GitHub Actions Secrets and confirm no AccessKey values are present in repository files, workflow output, test fixtures, or OpenSpec artifacts.
- [ ] 1.5 Bind `knowledge-assets.hiredchina.com` as the OSS custom domain, configure its HTTPS certificate, and keep any Cloudflare DNS record DNS-only for this first release.

## 2. OSS publishing implementation

- [ ] 2.1 Add an OSS deployment script in `hc-hw` that invokes the existing knowledge-site builder, validates a nonempty output containing `index.html`, and supports an explicit non-mutating preview mode.
- [ ] 2.2 Implement scoped OSS synchronization from the generated output to `oss://hc-hw-assets/`; permit deletion only after the build-output guard passes and never accept credentials as command-line arguments.
- [ ] 2.3 Update the knowledge deployment GitHub Actions workflow to use the dedicated publisher secret, retain build artifacts, and deploy to OSS instead of pushing `gh-pages` when not in preview mode.
- [ ] 2.4 Preserve the existing GitHub Pages workflow path as the rollback route until OSS endpoint and custom-domain acceptance are complete.
- [ ] 2.5 Update `hw` command help and deployment documentation to state the OSS target, public-read boundary, preview behavior, required GitHub Secrets, and the explicit first-release exclusion of CDN and Worker components.

## 3. Automated verification

- [ ] 3.1 Add design or script tests that verify deployment help, preview non-mutation, mandatory `index.html` guard, OSS target scope, and absence of credential values in committed templates.
- [ ] 3.2 Run the affected static-site build and design test suite, then run `openspec validate publish-knowledge-site-to-oss --strict` and `git diff --check`.

## 4. Release acceptance and rollback

- [ ] 4.1 Run a preview build in GitHub Actions and independently verify that no OSS objects were written.
- [ ] 4.2 Run one controlled deployment and read back `index.html` from the OSS static website endpoint as an unauthenticated client.
- [ ] 4.3 Read back the same generated homepage over HTTPS from `knowledge-assets.hiredchina.com`, and verify anonymous OSS write remains denied after release.
- [ ] 4.4 Record OSS and domain readback evidence, traffic/billing alert configuration, the rollback command or workflow choice, and any CDN follow-up decision before submitting `READY_FOR_ACCEPTANCE`.
