# Install necessary packages
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, sf, tmap, RColorBrewer)

source("scripts/r prep2.r")

# Load spatial data (replace with your actual data)
world <- st_read("Data/World_Admin/world-administrative-boundaries.shp") #package="sf")

filtered_world <- world[world$french_shor %in% c("France", "Allemagne", "Espagne", 
                                                "Italie", "Royaume-Uni de Grande-Bretagne et d'Irlande du Nord"), ]

filtered_world
view(filtered_world)
glimpse(filtered_world)

select(filtered_world, french_shor)

# Prepare data for mapping (replace with your actual data)
data <- data.frame(
  country = c("France", "Allemagne", "Espagne", "Italie", "Royaume-Uni de Grande-Bretagne et d'Irlande du Nord"),
  value = c(10, 20, 15, 8, 12)
)

# Join data with spatial data
map_data <- left_join(filtered_world, data, by = c("french_shor" = "country"))

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
#map_save(map, filename = "my_map.png", width = 8, height = 6, units = "in", dpi = 300)

# Display map (optional)
map
