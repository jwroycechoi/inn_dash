FROM rocker/shiny

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    sudo \
    pandoc \
    pandoc-citeproc \
    libxml2-dev \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl-dev 
## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# packages needed for basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'plotly', 'tidyverse', 'sf', 'pals', 'RColorBrewer', 'DT', 'highcharter', 'tigris'), repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('rspatial/terra')"
RUN R -e "install.packages('leaflet')"
RUN R -e "install.packages('flexdashboard')"

# Make directory and copy Rmd and data files
RUN mkdir -p /bin
RUN mkdir -p /bin/data
COPY inn_dashboard.Rmd /bin/inn_dashboard.Rmd
COPY /data/mapdat.qs /bin/data/mapdat.qs
COPY /data/mbi_summary.qs /bin/data/mbi_summary.qs
COPY /data/msa.qs /bin/data/msa.qs

# make all app files readable (solves issue when dev in Windows, but building in Ubuntu)
RUN chmod -R 755 /bin

EXPOSE 3838

# run flexdashboard as localhost and on exposed port in Docker container
CMD ["R", "-e", "rmarkdown::run('/bin/inn_dashboard.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]