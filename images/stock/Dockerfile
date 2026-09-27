# syntax=docker/dockerfile:1

# Jellyfin 10.11.11 multi-platform image index, pinned by digest.
FROM ghcr.io/jellyfin/jellyfin@sha256:45f648c382a0c8b552582fcea40e95cb17c5d475473a891cba0eb7523fb92112

USER root

ARG TARGETARCH
ARG FFMPEG_SHA256_AMD64="625065a539e3209717a977e9aede107bf61c4e0fc16ba78b54dea12f8ac0329b"
ARG FFMPEG_SHA256_ARM64="7d64e9d56b7679a0c928306574382e4b97fe4b861c7ab44b03dceda0cb23341a"
ARG GIT_REVISION="unknown"

RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) FFMPEG_SHA256="${FFMPEG_SHA256_AMD64}" ;; \
      arm64) FFMPEG_SHA256="${FFMPEG_SHA256_ARM64}" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    FFMPEG_URL="https://github.com/thystra/jellyfin-ffmpeg/releases/download/v7.1.4-3-awsec1/jellyfin-ffmpeg7_7.1.4-3%2Bawsec1-trixie_${TARGETARCH}.deb"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    curl -fL "${FFMPEG_URL}" -o /tmp/jellyfin-ffmpeg.deb; \
    echo "${FFMPEG_SHA256}  /tmp/jellyfin-ffmpeg.deb" | sha256sum -c -; \
    apt-get install -y --no-install-recommends /tmp/jellyfin-ffmpeg.deb; \
    rm -f /tmp/jellyfin-ffmpeg.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/thystra/jellyfin-security-images" \
      org.opencontainers.image.url="https://github.com/thystra/jellyfin-security-images" \
      org.opencontainers.image.documentation="https://github.com/thystra/jellyfin-security-images/blob/main/README.md" \
      org.opencontainers.image.title="Hardened Jellyfin" \
      org.opencontainers.image.description="Jellyfin 10.11.11 with the awsec1 FFmpeg security fix for CVE-2026-8461" \
      org.opencontainers.image.version="10.11.11-awsec1" \
      org.opencontainers.image.revision="${GIT_REVISION}"
