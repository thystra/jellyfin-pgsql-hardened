# Hardened Jellyfin images

Security-maintained Jellyfin container variants built from pinned upstream images and qualified in CI.

The repository publishes a small set of explicit, versioned images. Each tag identifies the Jellyfin version, ArgentWolf security patch level, and—where applicable—the PostgreSQL client major version. Only the tags listed below are maintained.

## Which image should I use?

For standard Jellyfin 10.11.11 on `linux/amd64`:

```text
ghcr.io/thystra/jellyfin-hardened:10.11.11-awsec1
```

For Jellyfin 10.11.11 with PostgreSQL 17 client tools:

```text
ghcr.io/thystra/jellyfin-pgsql-hardened:10.11.11-awsec1-pg17
```

For Jellyfin 10.11.11 with PostgreSQL 18 client tools:

```text
ghcr.io/thystra/jellyfin-pgsql-hardened:10.11.11-awsec1-pg18
```

The PostgreSQL variants use the same hardened FFmpeg build as the stock image. Their PostgreSQL client version is selected explicitly so Jellyfin.Pgsql backup and restore subprocesses use the requested `pg_dump`, `pg_restore`, and `psql` major version.

## Security patch levels

### AWSEC1

Jellyfin: 10.11.11  
Jellyfin FFmpeg: 7.1.4-3+awsec1

AWSEC1 mitigates **CVE-2026-8461** by disabling the vulnerable MagicYUV decoder at build time while retaining Jellyfin's expected hardware-acceleration support.

Future security rebuilds will increment the patch level (`awsec2`, `awsec3`, and so on) and document the security changes included in each level. The patch level is cumulative for a given Jellyfin release unless explicitly documented otherwise.

## Upstream bases

The stock image is based on the upstream `ghcr.io/jellyfin/jellyfin` 10.11.11 image pinned by digest.

The PostgreSQL variants are based on the previously qualified `ghcr.io/rogly-net/jellyfin-postgresql` image pinned by digest, with the requested PostgreSQL client major selected in the derivative image.

## Architecture policy

The current AWSEC1 Jellyfin FFmpeg package is qualified for `linux/amd64`, so the current images are published for amd64 only.

Architecture is intentionally not encoded in the image tag. Once the same security patch level is built and qualified for another architecture, the existing release tag can become an OCI multi-platform image and Docker/Podman can select the correct architecture automatically.

`linux/arm64` is the next architecture target. It will not be added to an AWSEC tag until the hardened FFmpeg package and the complete image qualification suite pass for arm64.

There is deliberately no `latest` tag. A moving `latest` tag would imply qualification against Jellyfin releases that this repository has not tested.

## OCI image metadata

Published derivatives override inherited OCI identity labels so consumers can identify this repository as the source of the hardened image. Labels include the source and documentation URLs, image title and description, security-build version, and the exact repository commit used for the build.

## CI qualification

Pull requests build and qualify every image without publishing. Pushes to `main` publish only images that pass the qualification suite to GHCR with SBOM and build provenance attestations.

The current CI verifies:

- Jellyfin reports version 10.11.11;
- the exact `jellyfin-ffmpeg7` 7.1.4-3+awsec1 package is installed;
- FFmpeg reports Jellyfin 7.1.4;
- the MagicYUV decoder is absent;
- CUDA, VAAPI, QSV, DRM, OpenCL, and Vulkan hardware-acceleration interfaces remain present;
- a real libx264 encode succeeds;
- OCI source, documentation, title, description, version, and revision labels match the expected build metadata;
- PostgreSQL variants select the requested `pg_dump`, `pg_restore`, and `psql` major version;
- PostgreSQL variants complete a real dump-and-restore round trip against a matching PostgreSQL server in CI.

## Source layout

```text
images/stock/Dockerfile   stock Jellyfin 10.11.11 + hardened FFmpeg
images/pgsql/Dockerfile   parameterized PostgreSQL 17/18 client variants
Dockerfile                compatibility entry point; defaults to PostgreSQL 18
```

## Scope

These images are security-maintained derivatives for specifically documented fixes. The project does **not** claim that every CVE reported against every package in the upstream image is fixed.
