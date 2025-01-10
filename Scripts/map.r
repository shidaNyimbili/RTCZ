source("scripts/r prep2.r")

# # Load necessary libraries
# library(ggplot2)
# library(dplyr)
# library(sf)        # For reading shapefiles
# library(ggspatial) # For spatial layers and map scales
# library(readxl)    # For reading Excel files

# Load the shapefile for Zambia's provincial boundaries
# Replace 'zambia_shapefile.shp' with the actual path to your shapefile
zambia_boundaries <- st_read("Data/Updated Shapefiles/Updated_Province.shp")

zambia_boundaries

#zambia_boundaries <- st_read("zambia_shapefile.shp")

# Load the data from Excel
# Replace 'datamaps.xlsx' with the path to your actual Excel file
#facility_data <- read_excel("datamaps.xlsx")
facility_data <- read_xlsx("C:/Users/SNyimbili/Downloads/datamaps.xlsx")

# Convert the facility data to spatial points using the latitude and longitude columns
facilities_sf <- st_as_sf(facility_data, coords = c("Longitude", "Latitude"), crs = 4326)

# Plot the map with boundaries and facilities
ggplot() +
  # Add provincial boundaries
  geom_sf(data = zambia_boundaries, fill = "lightgray", color = "black") +
  # Add facilities, color by transition status, shape points
  geom_sf(data = facilities_sf, aes(color = Transitioned, shape = Transitioned), size = 3) +
  # Add facility names
  geom_text(data = facility_data, aes(x = Longitude, y = Latitude, label = Facility_Name__MoH_, color = Transitioned), 
            hjust = 1, vjust = 1.5, size = 3) +
  # Customize color and shapes for supported and transitioned
  scale_color_manual(values = c("Supported" = "blue", "Transitioned" = "red")) +
  scale_shape_manual(values = c("Supported" = 16, "Transitioned" = 17)) +
  labs(title = "Facility Locations in Zambia (Supported vs Transitioned)", 
       x = "Longitude", y = "Latitude", color = "Transition Status", shape = "Transition Status") +
  theme_minimal() +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "tl", which_north = "true", style = north_arrow_fancy_orienteering())
