# install.packages("sf")
library(sf)
# install.packages("dplyr")
library(dplyr)
install.packages("giscoR")
library(giscoR)

year_ref <- 2013

nuts2_IT <- gisco_get_nuts(
  year = year_ref,
  resolution = 20, 
  nuts_level = 2,
  country = "Italy") %>%
  select(NUTS_ID, NAME_LATN)

plot(st_geometry(nuts2_IT)) 

