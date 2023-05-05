#-----------------------------------------------------------------------------#
#### Dataset Prep ####
#-----------------------------------------------------------------------------#
library(tidyverse)
library(tigris)
options(tigris_use_cache = T)
library(haven)

## Read in data
demo_zcta <- read_csv("data/demo_zip5.csv")
clus2dat <- read_csv("data/zip_cluster_04132023.csv")
msa <- read_csv("data/msa.csv")
cbsa_ref <- read_csv("data/cbsa_ref.csv")
mbi <- read_sav("data/MBI2022.sav")

# Merge
demo_zcta <- left_join(demo_zcta, select(clus2dat, c(zcta, 61:72)), by = "zcta")

# Get shapefile for zip and msa
zipmap <- zctas(cb = T)
cb <- core_based_statistical_areas(cb = T)
# Merge with demo variables and make it an sf object
zipmap <- left_join(demo_zcta, select(zipmap, c(ZCTA5CE20, geometry)), by = c("zcta" = "ZCTA5CE20")) %>% st_as_sf()

alphabet_pal <- alphabet()  # Color - Generates colors for 26 categories
newPalette <- grDevices::colorRampPalette(colors = alphabet_pal)(25)  # Create a manual color palette with 24 categories from alphabet_pal
names(newPalette) <- levels(factor(zipmap$myclus))  # Assign names for each color for color consistency
cluscolScale <- scale_fill_manual(name = "myclus", values = newPalette)  # Save the manual fill as an object

zipmap_new_clus <- zipmap %>% filter(!is.na(myclus))  # Filter missing zipcodes

