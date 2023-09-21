FROM rocker/shiny-verse

MAINTAINER Jaewon R. Choi "jwroycechoi@gmail.com"

# Use this in R to check required system libraries
# pak::pkg_sysreqs(c("leaflet","sf","pals","flexdashboard","DT","highcharter","tigris","qs"), sysreqs_platform = "ubuntu-22.04")

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    make \
    pandoc \
    libpng-dev \
    libicu-dev \
    libgdal-dev \
    gdal-bin \
    libgeos-dev \
    libproj-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    zlib1g-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libglpk-dev \
    libgmp3-dev 
## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Make directory and copy Rmd and data files
RUN mkdir -p /dashapp
RUN mkdir -p /dashapp/data
COPY inn_dashboard.Rmd /dashapp/inn_dashboard.Rmd
COPY /data/mapdat.qs /dashapp/data/mapdat.qs
COPY /data/mbi_summary.qs /dashapp/data/mbi_summary.qs
COPY /data/msa.qs /dashapp/data/msa.qs

# packages needed for basic shiny functionality

RUN install2.r -e -s \
    pals \
    flexdashboard \
    DT \
    highcharter \
    tigris \
    qs \
    sf \
    leaflet \
    && rm -rf /tmp/downloaded_packages

# RUN R -e "install.packages('pals', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('flexdashboard', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('DT', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('highcharter', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('tigris', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('qs', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('sf', repos='https://cloud.r-project.org', dependencies = TRUE)"
# RUN R -e "install.packages('leaflet', repos='https://cloud.r-project.org', dependencies = TRUE)"

WORKDIR /dashapp

# make all app files readable (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /dashapp

EXPOSE 3838

# run flexdashboard as localhost and on exposed port in Docker container
CMD ["R", "-e", "rmarkdown::run('/dashapp/inn_dashboard.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]