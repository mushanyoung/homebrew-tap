# Homebrew tap

Homebrew formulae maintained by [mushanyoung](https://github.com/mushanyoung).
This is a community tap, unaffiliated with Cloudflare.

## Cloudflare CLI

```sh
brew install mushanyoung/tap/cloudflare-cli
cloudflare --version
```

`cloudflare-cli` packages Cloudflare's `cf` CLI. The current version is
**1.0.0-rc.0**, a release candidate for cf 1.0. Both upstream command names,
`cf` and `cloudflare`, are installed.

The formula downloads the exact
[official npm tarball](https://registry.npmjs.org/cf/-/cf-1.0.0-rc.0.tgz)
and verifies its SHA-256:

```text
02c74e5bf1cbc528a0cf2c992f8912c392bc44c5a8c9148cc896107129035d6c
```

Homebrew supplies Node.js and installs npm dependencies under the formula's
`libexec` directory. The entry point uses Homebrew's Node.js, independently of
the Node version on the user's `PATH`. The formula keeps Homebrew's default
npm lifecycle-script restrictions and release cooldown.

The upstream package supports Node.js `^22.23.0 || ^24.22.0 || ^26.12.0`.
The formula currently uses Homebrew's `node` formula (Node.js 26).

### Command conflicts

Homebrew already has an unrelated formula named `cf`. Both that package and
`cloudfoundry-cli` install a `cf` executable, so the formula declares conflicts
with both. Check existing installations before switching to this package.

### Validation

```sh
brew install --build-from-source mushanyoung/tap/cloudflare-cli
brew audit --strict --online mushanyoung/tap/cloudflare-cli
brew test --verbose mushanyoung/tap/cloudflare-cli
brew linkage --test mushanyoung/tap/cloudflare-cli
```

The formula test checks both command names and executes a local D1 SQL query
through Miniflare/workerd. It requires no Cloudflare account or API token.
GitHub Actions runs the checks on macOS and Linux.

Freshly published dependencies may be unavailable during Homebrew's default
24-hour npm release cooldown. The dependencies pinned by this RC clear that
window after **2026-11-17 12:04 UTC**.

## Stable release and homebrew/core

The RC stays in this tap. Submit to `homebrew/core` only after Cloudflare
identifies a version as stable. The upstream publishing workflow marks RCs as
GitHub `Latest` and npm `latest`, so those labels alone do not establish stability.

Before opening the core PR:

1. Confirm the upstream release announcement and version have left prerelease
   status, then update the fixed npm tarball URL and SHA-256.
2. Review the supported Node versions, npm dependency resolution, lifecycle
   scripts, and native workerd/sharp components against current core requirements.
3. Run `brew audit --new`, the functional test, and the current core CI and bottle
   checks on supported platforms. Resolve failures without weakening the checks.
4. Open the `Homebrew/homebrew-core` PR as `cloudflare-cli`, carrying over the
   command conflict declarations and validation evidence.

References: [Cloudflare publishing guidance](https://github.com/cloudflare/cf/blob/cf%401.0.0-rc.0/docs/architecture.md#publishing),
[Homebrew stable release requirement](https://docs.brew.sh/Acceptable-Formulae#stable-releases),
and [Homebrew Node.js packaging guidance](https://docs.brew.sh/Language-Specific-Formulae#nodejs).
