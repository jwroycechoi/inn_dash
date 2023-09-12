FROM openanalytics/r-base

LABEL maintainer="daan.seynaeve@openanalytics.eu"

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
RUN R -e "options(internet.info = 0, warn = 2); install.packages(c('shiny', 'rmarkdown', 'plotly', 'tidyverse', 'sf', 'leaflet', 'pals', 'RColorBrewer', 'DT', 'highcharter', 'tigris'), repos='https://cloud.r-project.org')"


EXPOSE 3838