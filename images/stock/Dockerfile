# syntax=docker/dockerfile:1

# Jellyfin 10.11.11 linux/amd64, pinned to the upstream platform manifest.
FROM ghcr.io/jellyfin/jellyfin@sha256:ddf59965ae63fccc66dfe72384495df355c67ea5abd9cc04eb65988f9a6010d1

USER root

ARG FFMPEG_URL="https://github.com/thystra/jellyfin-ffmpeg/releases/download/v7.1.4-3-awsec1/jellyfin-ffmpeg7_7.1.4-3%2Bawsec1-trixie_amd64.deb"
ARG FFMPEG_SHA256="625065a539e3209717a977e9aede107bf61c4e0fc16ba78b54dea12f8ac0329b"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    curl -fL "${FFMPEG_URL}" -o /tmp/jellyfin-ffmpeg.deb; \
    echo "${FFMPEG_SHA256}  /tmp/jellyfin-ffmpeg.deb" | sha256sum -c -; \
    apt-get install -y --no-install-recommends /tmp/jellyfin-ffmpeg.deb; \
    rm -f /tmp/jellyfin-ffmpeg.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
