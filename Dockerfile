# PostgreSQL container for test databases from FMI master databases
# Adapted from official PostgreSQL Dockerfile:
# https://github.com/docker-library/postgres/
#
# https://hub.docker.com/_/centos/

FROM docker.weatherproof.fi:5000/baseimage:latest
ENV http_proxy=http://wwwcache.fmi.fi:8080 https_proxy=http://wwwcache.fmi.fi:8080 no_proxy=weatherproof.fi

MAINTAINER "fmi"
USER root

# Ability to override PGDATA from command line or docker-compose.yml
ENV PGDATA=/var/lib/pgsql/data/12

# Explicitly set user/group IDs
# Note that we reinstall glibc-common to get all locales
RUN groupadd -r postgres && useradd -r -g postgres postgres && \
   # Inject excludes into YUM config files.
   # https://wiki.postgresql.org/wiki/YUM_Installation
   sed -i '/\[base\]/,/gpgkey=/{/gpgkey=/s/$/\'$'\n''exclude = postgres*/;}' /etc/yum.repos.d/CentOS-Base.repo && \
   sed -i '/\[updates\]/,/gpgkey=/{/gpgkey=/s/$/\'$'\n''exclude = postgres*/;}' /etc/yum.repos.d/CentOS-Base.repo && \

   # Install newest PostgreSQL major version repo.
   # http://yum.postgresql.org/repopackages.php
   echo "ip_resolve=IPv4" >> /etc/yum.conf && \

   yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
   yum-config-manager --disable "pgdg*" --save && \
   yum -y update  && \
   yum -y reinstall --setopt=override_install_langs='' --setopt=tsflags='' glibc-common && \
   yum-config-manager --enable pgdg12 pgdg-common --save && \
   yum -y install postgresql12 postgresql12-server postgresql12-contrib postgresql12-libs postgis2_12 pv && \
   yum clean all && rm -rf /tmp/* && \
   yum -y install lsof bzip2

# The database dumps
COPY db-dump.bz2 /tmp/

RUN mkdir -p ${PGDATA} && \
    mkdir -p /etc/provision /var/run/postgresql && \
    chown -R postgres ${PGDATA} /var/run/postgresql /tmp /etc/provision

USER postgres

# The first command (only needed once) is to initialize the database in PGDATA.
# -E UTF-8 is needed here because the fminames schema is also UTF-8.
RUN /usr/pgsql-12/bin/initdb -E 'UTF-8' -D ${PGDATA}

COPY etc/postgresql.conf ${PGDATA}
COPY etc/pg_hba.conf ${PGDATA}

# Start the server and create database users.
# -w is needed because otherwise createuser would run before the database is up.
# The server is stopped gracefully in the last step to avoid an error in the next
# layer, where the server is required to be running again.
RUN cd /tmp && \
    /usr/pgsql-12/bin/pg_ctl -w -s -D ${PGDATA} -o "-p 5432" start && \
    bzcat db-dump.bz2 | sed -e 's/^CREATE ROLE postgres;//' > db.sql && \
    /usr/pgsql-12/bin/psql -f db.sql --set ON_ERROR_STOP=on && \
    /usr/pgsql-12/bin/pg_ctl -w -s -D ${PGDATA} -o "-p 5432" stop && \
    chmod 0700 ${PGDATA} && \
    rm -rf /tmp/*

# PostgreSQL is set to listen on TCP port 5444.
EXPOSE 5444

#Launch the daemon
ENTRYPOINT exec /usr/pgsql-12/bin/postgres -o "-p 5444" -D ${PGDATA}
