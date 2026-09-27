# Hardened Jellyfin images

Security-maintained Jellyfin container variants built from pinned upstream images and qualified in CI.

The repository began as `jellyfin-pgsql-hardened` and was renamed to `jellyfin-security-images` as its scope expanded to include both a stock Jellyfin variant and the PostgreSQL variant. The published GHCR image names remain separate by variant.

## Current security fix

The current `awsec1` images use the qualified `jellyfin-ffmpeg7` 7.1.4-3+awsec1 package from [`thystra/jellyfin-ffmpeg`](https://github.com/thystra/jellyfin-ffmpeg/releases/tag/v7.1.4-3-awsec1).

That build disables the MagicYUV decoder at build time to mitigate CVE-2026-8461 while retaining Jellyfin's expected hardware-acceleration support.

## Images

### Stock Jellyfin 10.11.11

Base: upstream `ghcr.io/jellyfin/jellyfin` 10.11.11 amd64 image, pinned by digest.

```text
ghcr.io/thystra/jellyfin-hardened:10.11.11-awsec1
ghcr.io/thystra/jellyfin-hardened:10.11-awsec1
ghcr.io/thystra/jellyfin-hardened:cve-2026-8461
```

### Jellyfin PostgreSQL + PG18 client

Base: the previously qualified `ghcr.io/rogly-net/jellyfin-postgresql` image, pinned by digest.

Adds the same hardened FFmpeg package and PostgreSQL client 18, with `PATH` set so Jellyfin.Pgsql backup/restore subprocesses select the PG18 tools.

```text
ghcr.io/thystra/jellyfin-pgsql-hardened:awsec1-pg18
ghcr.io/thystra/jellyfin-pgsql-hardened:cve-2026-8461-pg18
```

## Architecture and version policy

The current hardened FFmpeg package is qualified for `linux/amd64` and Jellyfin 10.11.x. The image workflow therefore publishes amd64 images only.

There is deliberately no `latest` tag. Upstream Jellyfin has moved beyond 10.11.x, and a moving `latest` tag would incorrectly imply that the current hardened FFmpeg package had been qualified against newer Jellyfin major versions.

## OCI image metadata

Published derivatives override inherited OCI identity labels so consumers can identify this repository as the source of the hardened image. Labels include the source and documentation URLs, image title and description, security-build version, and the exact repository commit used for the build.

## CI qualification

Every image build must verify that:

- the exact `jellyfin-ffmpeg7` 7.1.4-3+awsec1 package is installed;
- FFmpeg reports Jellyfin 7.1.4;
- the MagicYUV decoder is absent;
- CUDA, VAAPI, QSV, DRM, OpenCL, and Vulkan hardware-acceleration interfaces remain present;
- a real libx264 encode succeeds;
- OCI source, documentation, title, description, version, and revision labels match the expected build metadata;
- for the PostgreSQL variant, `pg_dump` resolves to the PostgreSQL 18 client.

Pull requests build and qualify without publishing. Pushes to `main` publish qualified images to GHCR with SBOM and build provenance attestations.

## Source layout

```text
images/stock/Dockerfile   stock Jellyfin 10.11.11 + hardened FFmpeg
images/pgsql/Dockerfile   Jellyfin PostgreSQL + hardened FFmpeg + PG18 client
Dockerfile                compatibility entry point for the PostgreSQL variant
```

## Scope

These images are security-maintained derivatives for specifically documented fixes. The project does **not** claim that every CVE reported against every package in the upstream image is fixed.
