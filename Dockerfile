FROM ghcr.io/rogly-net/jellyfin-postgresql@sha256:944e277c10b4f0a5fc9748736a9e170cf28b9fba81f148a20fc6414f2eda1013

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client-18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ensure Jellyfin.Pgsql's backup/restore subprocesses select PG18 tools,
# rather than the PG17 client also present in the upstream image.
ENV PATH="/usr/lib/postgresql/18/bin:${PATH}"
