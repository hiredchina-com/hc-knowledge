## Context

`hc-knowledge` stores the multilingual Markdown source and currently has no OpenSpec workflow. `hc-hw` owns the existing static-site builder (`bin/build-knowledge-site.sh`) and a GitHub Actions workflow that builds the site before publishing it to the `gh-pages` branch. The new OSS bucket `hc-hw-assets` exists in `oss-cn-shenzhen` and is currently private.

The immediate product need is a publicly accessible knowledge-base pages service with the fewest new runtime components. The publishing pipeline spans the `hc-knowledge` source repository, the `hc-hw` build/deploy tooling, GitHub Actions, Alibaba Cloud OSS, and DNS. No application API or user data is involved.

## Goals / Non-Goals

**Goals:**

- Publish the generated multilingual static site from the `hc-knowledge` source to the root of `hc-hw-assets`.
- Expose the published site through `knowledge-assets.hiredchina.com`.
- Keep deployment writes narrowly scoped to this bucket and keep deployment credentials out of Git.
- Retain a reversible GitHub Pages path until OSS deployment and public-domain readback have passed.

**Non-Goals:**

- Alibaba Cloud CDN, Cloudflare proxy/CDN, Cloudflare Workers, signed private-origin requests, or CDN cache-purge automation.
- Migration of `hcapi` Qiniu integration or a general-purpose multi-provider `hw assets` CLI.
- User uploads, authenticated content, dynamic server rendering, search APIs, or changes to knowledge Markdown semantics.

## Decisions

### 1. Use direct OSS static website hosting in the first release

The OSS bucket will be configured as a static website with `index.html` and `404.html`, and its bucket ACL will be `public-read`. The bucket MUST remain non-public-write.

This is the minimal path from generated files to a public site: it avoids a second delivery vendor, private-origin credentials, a Worker, and CDN cache invalidation.

Alternatives considered:

- **Private OSS plus Alibaba Cloud CDN**: stronger source protection but adds a CDN domain, service authorization, separate billing and cache configuration. Defer until real traffic or abuse evidence requires it.
- **Cloudflare CDN plus Worker signing**: keeps OSS private but adds a Worker, an OSS read credential, signing code, and another billable execution path. Rejected for the first release.
- **Continue GitHub Pages**: remains the rollback route but does not establish the requested OSS hosting boundary.

### 2. Treat `hc-hw-assets` as a dedicated knowledge-site bucket

The generated site is synchronized to the bucket root so static website hosting can serve `/index.html` without path rewrites. Before enabling delete synchronization, the bucket owner MUST confirm that no unrelated assets are stored in the bucket.

The deploy command SHALL fail before destructive synchronization when the build output has no `index.html` or is empty. This prevents a failed build from clearing the live site.

Alternative considered: upload to a `knowledge/` prefix. That would isolate content but requires a prefix-aware website origin or rewrite layer, which conflicts with the minimal first-release architecture.

### 3. Use a dedicated GitHub Actions deployment identity

GitHub Actions will authenticate to OSS using a dedicated RAM identity named for knowledge-site publishing. Its permission is limited to listing the bucket and reading, writing, and deleting objects in `hc-hw-assets`; it MUST NOT receive bucket ACL, bucket deletion, or account-wide OSS administration permissions.

The AccessKey ID and AccessKey Secret are stored only as GitHub repository or organization secrets. They are not committed, printed, copied to OpenSpec files, or added to repository `.env` files.

OIDC-to-RAM-role credentials are preferable when already available, but a narrowly scoped GitHub secret is the approved first-release mechanism because it minimizes setup dependencies.

### 4. Bind the public domain directly to OSS

`knowledge-assets.hiredchina.com` is registered as the bucket custom domain and DNS points to the OSS website endpoint. If DNS is hosted by Cloudflare, the record is DNS-only in this release; Cloudflare proxying is explicitly out of scope.

The domain and certificate configuration are external prerequisites. The release is not complete until an unauthenticated HTTPS request through the custom domain returns the expected generated page.

## Risks / Trade-offs

- **Public objects can be downloaded directly from the OSS endpoint and may incur traffic/request charges** → Use a dedicated bucket, enable billing and traffic anomaly alerts, and revisit private OSS plus Alibaba Cloud CDN if usage exceeds the agreed budget.
- **A broad deploy identity could overwrite unrelated content** → Limit the RAM policy to the bucket and do not enable root delete synchronization until dedicated-bucket ownership is confirmed.
- **A failed build could remove the live site during sync** → Require a nonempty build output with `index.html` before upload or deletion.
- **DNS/certificate propagation can make a valid deployment appear unavailable** → Validate the bucket object endpoint before switching the custom domain, then use public HTTPS readback as the domain acceptance gate.
- **OSS release fails after GitHub Pages has been changed** → Do not disable or delete the GitHub Pages workflow until the OSS deployment has passed independent acceptance.

## Migration Plan

1. Confirm `hc-hw-assets` is dedicated to the public knowledge site, configure static website hosting, and set ACL to `public-read` only.
2. Create the dedicated RAM publisher identity and store its credentials as GitHub Secrets.
3. Add an OSS deploy script and replace the GitHub Actions `gh-pages` publish step while retaining the existing build and artifact-upload steps.
4. Run preview/build validation without writing to OSS, then run a controlled deployment and read back the generated `index.html` from the OSS endpoint.
5. Bind `knowledge-assets.hiredchina.com`, configure HTTPS, and verify the same public page through the custom domain.
6. Keep GitHub Pages available as rollback until acceptance; rollback consists of restoring the previous Pages deployment step and DNS target without modifying the Markdown source.

## Open Questions

- Who owns the DNS zone and certificate issuance for `knowledge-assets.hiredchina.com`?
- Is `hc-hw-assets` confirmed empty and dedicated, so root-level delete synchronization is safe?
- What monthly traffic and cost threshold should trigger the follow-up private OSS plus Alibaba Cloud CDN design?
