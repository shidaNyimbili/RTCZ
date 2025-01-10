# Install necessary packages
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, sf, tmap, RColorBrewer)

source("scripts/r prep2.r")

# Load spatial data (replace with your actual data)
world <- st_read(system.file("Data/world-administrative-boundaries.shp", package="sf")) 

# Prepare data for mapping (replace with your actual data)
data <- data.frame(
  country = c("France", "Germany", "Spain", "Italy", "UK"),
  value = c(10, 20, 15, 8, 12)
)

# Join data with spatial data
map_data <- left_join(world, data, by = c("name" = "country"))

# Define color palette
palette <- brewer.pal(9, "YlOrRd")

# Create choropleth map
map <- tm_shape(map_data) +
  tm_polygons("value", 
              palette = palette, 
              style = "quantile", 
              title = "Value") +
  tm_layout(legend.position = c("right", "bottom"))

# Save map as an image
tmap_save(map, filename = "my_map.png", width = 8, height = 6, units = "in", dpi = 300)

# Display map (optional)
map