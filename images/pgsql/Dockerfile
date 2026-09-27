# syntax=docker/dockerfile:1

FROM ghcr.io/rogly-net/jellyfin-postgresql@sha256:944e277c10b4f0a5fc9748736a9e170cf28b9fba81f148a20fc6414f2eda1013

USER root

ARG FFMPEG_URL="https://github.com/thystra/jellyfin-ffmpeg/releases/download/v7.1.4-3-awsec1/jellyfin-ffmpeg7_7.1.4-3%2Bawsec1-trixie_amd64.deb"
ARG FFMPEG_SHA256="625065a539e3209717a977e9aede107bf61c4e0fc16ba78b54dea12f8ac0329b"
ARG GIT_REVISION="unknown"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl postgresql-client-18; \
    curl -fL "${FFMPEG_URL}" -o /tmp/jellyfin-ffmpeg.deb; \
    echo "${FFMPEG_SHA256}  /tmp/jellyfin-ffmpeg.deb" | sha256sum -c -; \
    apt-get install -y --no-install-recommends /tmp/jellyfin-ffmpeg.deb; \
    rm -f /tmp/jellyfin-ffmpeg.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Ensure Jellyfin.Pgsql backup/restore subprocesses select PG18 tools rather
# than the PG17 client also present in the upstream image.
ENV PATH="/usr/lib/postgresql/18/bin:${PATH}"

LABEL org.opencontainers.image.source="https://github.com/thystra/jellyfin-security-images" \
      org.opencontainers.image.url="https://github.com/thystra/jellyfin-security-images" \
      org.opencontainers.image.documentation="https://github.com/thystra/jellyfin-security-images/blob/main/README.md" \
      org.opencontainers.image.title="Hardened Jellyfin PostgreSQL" \
      org.opencontainers.image.description="Jellyfin PostgreSQL derivative with the awsec1 FFmpeg security fix for CVE-2026-8461 and PostgreSQL 18 client tools" \
      org.opencontainers.image.version="awsec1-pg18" \
      org.opencontainers.image.revision="${GIT_REVISION}"
