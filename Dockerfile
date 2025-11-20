# Base image
ARG PG_MAJOR=17
FROM postgres:${PG_MAJOR}

# Install dependencies and build pgaudit
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        wget \
        git \
        postgresql-server-dev-${PG_MAJOR} \
        libkrb5-dev \
        postgresql-${PG_MAJOR}-cron && \
    \
    # Clone the correct pgaudit branch
    git clone --branch REL_${PG_MAJOR}_STABLE https://github.com/pgaudit/pgaudit.git /tmp/pgaudit && \
    cd /tmp/pgaudit && \
    make USE_PGXS=1 && make USE_PGXS=1 install && \
    \
    # Cleanup
    rm -rf /tmp/pgaudit && \
    apt-get remove -y build-essential git wget libkrb5-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable pgaudit + pg_cron by default
RUN echo "shared_preload_libraries='pgaudit,pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "cron.database_name='postgres'" >> /usr/share/postgresql/postgresql.conf.sample
