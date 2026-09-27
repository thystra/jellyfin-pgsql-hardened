# syntax=docker/dockerfile:1

FROM ghcr.io/rogly-net/jellyfin-postgresql@sha256:944e277c10b4f0a5fc9748736a9e170cf28b9fba81f148a20fc6414f2eda1013

USER root

ARG FFMPEG_URL="https://github.com/thystra/jellyfin-ffmpeg/releases/download/v7.1.4-3-awsec1/jellyfin-ffmpeg7_7.1.4-3%2Bawsec1-trixie_amd64.deb"
ARG FFMPEG_SHA256="625065a539e3209717a977e9aede107bf61c4e0fc16ba78b54dea12f8ac0329b"
ARG GIT_REVISION="unknown"
ARG PG_MAJOR="18"
ARG OCI_VERSION="10.11.11-awsec1-pg18"

RUN set -eux; \
    case "${PG_MAJOR}" in 17|18) ;; *) echo "Unsupported PostgreSQL major: ${PG_MAJOR}" >&2; exit 1 ;; esac; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl "postgresql-client-${PG_MAJOR}"; \
    curl -fL "${FFMPEG_URL}" -o /tmp/jellyfin-ffmpeg.deb; \
    echo "${FFMPEG_SHA256}  /tmp/jellyfin-ffmpeg.deb" | sha256sum -c -; \
    apt-get install -y --no-install-recommends /tmp/jellyfin-ffmpeg.deb; \
    rm -f /tmp/jellyfin-ffmpeg.deb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Select the requested PostgreSQL client for Jellyfin.Pgsql backup/restore
# subprocesses. The upstream image may carry another client major as well.
ENV PATH="/usr/lib/postgresql/${PG_MAJOR}/bin:${PATH}"

LABEL org.opencontainers.image.source="https://github.com/thystra/jellyfin-security-images" \
      org.opencontainers.image.url="https://github.com/thystra/jellyfin-security-images" \
      org.opencontainers.image.documentation="https://github.com/thystra/jellyfin-security-images/blob/main/README.md" \
      org.opencontainers.image.title="Hardened Jellyfin PostgreSQL" \
      org.opencontainers.image.description="Jellyfin 10.11.11 PostgreSQL derivative with the awsec1 FFmpeg security fix for CVE-2026-8461 and PostgreSQL ${PG_MAJOR} client tools" \
      org.opencontainers.image.version="${OCI_VERSION}" \
      org.opencontainers.image.revision="${GIT_REVISION}"
