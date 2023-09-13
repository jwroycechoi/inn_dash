FROM rocker/shiny

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    sudo \
    pandoc \
    pandoc-citeproc \
    libxml2-dev \
    libcurl4-openssl-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl-dev \
    libudunits2-dev \
    libsasl2-dev \
    libv8-dev
## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# packages needed for basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'plotly', 'sf', 'pals', 'RColorBrewer', 'DT', 'highcharter', 'tigris'), repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('rspatial/terra')"
RUN R -e "install.packages('leaflet')"
RUN R -e "install.packages('flexdashboard')"
RUN R -e "install.packages('tidyverse')"

# Make directory and copy Rmd and data files
RUN mkdir -p /data
COPY inn_dashboard.Rmd inn_dashboard.Rmd
COPY /data/mapdat.qs /data/mapdat.qs
COPY /data/mbi_summary.qs /data/mbi_summary.qs
COPY /data/msa.qs /data/msa.qs

EXPOSE 3838

# run flexdashboard as localhost and on exposed port in Docker container
CMD ["R", "-e", "rmarkdown::run('inn_dashboard.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]