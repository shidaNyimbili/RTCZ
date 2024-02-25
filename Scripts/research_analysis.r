# Load required libraries

source("scripts/r prep2.r")

# Read shapefile
provinces_zam <- st_read("Data/Updated Shapefiles/Updated_Province.shp")
districts_zam <- st_read("Data/Updated Shapefiles/Districts.shp")

# Read HIV prevalence rates data
prev.hiv <- read_xlsx("Data/prematurity/HIV Prev Rates.xlsx")
prev.data <- read_xlsx("Data/reserach/prevdata.xlsx")

# Extract year from the 'period' column
prev.data <- prev.data %>%
  mutate(year = str_sub(period, start = nchar(period) - 4, end = nchar(period)))

# Select relevant columns and handle missing values
prev.data.1 <- prev.data %>%
  select(1, 2, 3, 5) %>%
  na.omit()

# Rename columns
prev.data.2 <- prev.data.1 %>%
  rename(prov = 1,
         distrt = 2,
         prev.rt = 3,
         yr = 4)

# Reshape the data
prev.data.3 <- prev.data.2 %>%
  gather(key = subRt, value = rate, c(prev.rt))

# Extract relevant columns from provinces_zam
districts_zam1 <- districts_zam %>%
  select(7, 10) %>%
  na.omit()

# Group and join data
prev.data.4 <- prev.data.3 %>%
  group_by(yr, distrt, subRt)

prev.data.5 <- left_join(prev.data.4,
                         districts_zam1,
                         by = c("distrt" = "DISTRICT")) %>%
  sf::st_as_sf()


# Define a reversed color palette
rev_palette <- rev(RColorBrewer::brewer.pal(9, "Blues"))

# Plotting
plot <- ggplot() +
  geom_sf(data = provinces_zam, fill = NA, color = "black") + # Add provincial boundaries
  geom_sf(data = prev.data.5, aes(fill = rate)) +
  scale_fill_gradient(name = "Prev Rates(%)",
                      low = rev_palette[length(rev_palette)],
                      high = rev_palette[1]) +
  ggtitle("Spatial Distribution of HIV/AIDS Prevalence Rates Across Districts") +
  facet_wrap(~yr) + theme_minimal()

# View the plot
print(plot)

# Calculate summary statistics
summary(prev.data.5$rate)

prev.data.5
names(prev.data.5)

head(prev.data.5)

proj4string(prev.data.5)


# Load necessary libraries
library(sf)
library(spdep)

# Check for invalid geometries
invalid_geoms <- !st_is_valid(prev.data.5)
invalid_geoms_indices <- which(invalid_geoms)

# Attempt to fix invalid geometries
prev.data.5 <- st_make_valid(prev.data.5)

# Check again for invalid geometries
invalid_geoms <- !st_is_valid(prev.data.5)
invalid_geoms_indices <- which(invalid_geoms)

# Construct spatial weights matrix based on polygon adjacency
nb <- poly2nb(prev.data.5$geometry)

# Convert neighbor list to spatial weights matrix
listw <- nb2listw(nb, style = "B")

# Perform Moran's I test
moran_test <- moran.test(prev.data.5$rate, listw)
moran_test

# Construct spatial weights matrix based on polygon adjacency
nb <- poly2nb(prev.data.5$geometry)

nb
listw <- nb2listw(nb, style = "B")

# Check data type and handle missing values if needed
# For example:
# prev.data.5$rate <- as.numeric(prev.data.5$rate)
# prev.data.5$rate[is.na(prev.data.5$rate)] <- 0  # Replace missing values with appropriate values

# Conduct hotspot analysis
# Example: Getis-Ord Gi* statistic
hotspot <- spdep::localG(listw, prev.data.5$rate)
print(hotspot)

###Test
# Ensure Data Type: Verify that prev.data.5$rate is a numeric vector
rate_values <- as.numeric(prev.data.5$rate)

# Check for NA or missing values and handle them if necessary
# For example:
# rate_values[is.na(rate_values)] <- 0  # Replace NA values with 0 or any other appropriate value

# Construct spatial weights matrix based on polygon adjacency
nb <- poly2nb(prev.data.5$geometry)
listw <- nb2listw(nb, style = "B")

# Conduct hotspot analysis
hotspot <- spdep::localG(prev.data.5, listw, attr = rate_values)
print(hotspot)

##Test

# Perform spatial interpolation if necessary
# Example: Spatial interpolation using kriging
# (This would require additional packages and steps)

# Further analysis and interpretation based on results

