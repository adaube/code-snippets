# Interesting things to do with Postgres in the context of a Dockerfile

``` docker
# Copy SQL gz from local to image, expand, replace the user name
COPY ./pgdump-name.pgd.gz /var/lib/pgsql/pgdump-name.sql.gz
WORKDIR /var/lib/pgsql
# replace the supplied not-username with actual-username (useful if it changed)
RUN gunzip pgdump-name.sql.gz && sed -i '/not-username/ s//actual-username/g' pgdump-name.sql
# start postgres, make superuser, make and populate the database
RUN service postgresql initdb && service postgresql start && \
    su - postgres -c "/usr/local/pgsql/bin/pg_ctl start -l logfile -D /usr/local/pgsql/data" && \
    su - postgres -c "createuser -s actual-username && createdb -O actual-username -T template0 database-name && \
    cat pgdump-name.sql | psql database-name"
RUN rm pgdump-name.sql
RUN service postgresql start
# this should make postgres start automatically, but we will also docker exec a restart in start script
RUN chkconfig postgresql on
# trust incoming postgres connections, for dev purposes so this is okay (kinda!)
RUN su - postgres -c "cd data && sed -i 's/ident/trust/' pg_hba.conf"
```
