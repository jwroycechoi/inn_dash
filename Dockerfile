FROM rocker/shiny-verse:latest

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libv8-dev \
    shiny-server
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
WORKDIR /dashapp

# packages needed for basic shiny functionality
RUN R -e "install.packages('pals', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('plotly', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('flexdashboard', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('DT', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('highcharter', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('tigris', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('qs', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('sf', repos='https://cloud.r-project.org', dependencies = TRUE)"
RUN R -e "install.packages('leaflet', repos='https://cloud.r-project.org', dependencies = TRUE)"

EXPOSE 3838

# run flexdashboard as localhost and on exposed port in Docker container
CMD ["R", "-e", "rmarkdown::run('/dashapp/inn_dashboard.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]