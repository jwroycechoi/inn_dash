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

EXPOSE 3838