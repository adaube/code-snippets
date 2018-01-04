# CentOS 6, Postgres, Python 2.6
FROM centos:6
RUN yum -y update
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# install packages that don't play nice with dependency managers
RUN yum -y install wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git python-pip python-devel freetype-devel \
    libpng-devel hdf5-devel netcdf-devel httpd \
    java-1.8.0-openjdk-devel lapack-devel libpq-fe postgresql-devel \
    postgresql-server grib_api-devel
RUN easy_install -U distribute
RUN yum groupinstall -y "Development tools"
# Copy SQL gz from local to image, expand, replace the user name
COPY ./pgd.gz /var/lib/pgsql/sql.gz
WORKDIR /var/lib/pgsql
# replace the supplied username with actual username (result from testing on-site)
RUN gunzip sql.gz && sed -i '/username/ s//differentuser/g' data.sql
# start postgres, make superuser, make and populate the database
RUN service postgresql initdb && service postgresql start && \
    su - postgres -c "createuser -s differentuser && createdb -O differentuser -T template0 database_name && \
    cat data.sql | psql database_name"
RUN rm data.sql
# install Python packages
RUN pip install pyephem==3.7.3.4 numpy==1.9.2
RUN pip install pandas==0.16.2 matplotlib==1.4.3 netCDF4==1.1.8
RUN pip install geopy==0.99 scipy==0.18.1
RUN service postgresql start && pip install psycopg2==2.0.14
RUN pip install requests==2.7.0
# make basemap package
ADD basemap-1.0.7 /basemap
ENV GEOS_DIR=/usr/lib64
WORKDIR /basemap/geos-3.3.3/
RUN /bin/bash configure
RUN make; make install
WORKDIR /basemap
RUN python setup.py install
RUN cp /usr/local/lib/libgeo* /usr/lib64
RUN rm -rf /basemap
RUN pip install pygrib==2.0.2
# this should make postgres start automatically, but we will also docker exec a restart in start script
RUN chkconfig postgresql on
# trust incoming postgres connections, for dev purposes so this is okay
RUN su - postgres -c "cd data && sed -i 's/ident/trust/' pg_hba.conf"
ENV PYTHONPATH=/work
WORKDIR /work
ENTRYPOINT "/bin/bash"
