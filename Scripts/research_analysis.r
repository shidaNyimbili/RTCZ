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

# Save the plot
ggsave("viz/research/analysis1.png",
       plot,
       device = "png",
       type = "cairo",
       height = 7,
       width = 10)

# Calculate summary statistics
summary(prev.data.5$rate)

prev.data.5
names(prev.data.5)

head(prev.data.5)

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

# Install and load the spatialEco package if you haven't already
# install.packages("remotes")
remotes::install_github("mpjashby/sfhotspot")
# Load the sfhotspot package

# Perform spatial interpolation if necessary
# Example: Spatial interpolation using kriging
# (This would require additional packages and steps)

##Objective 2
# Load required libraries
library(dplyr)   # For data manipulation
library(ggplot2) # For data visualization

# Load HIV prevalence data
hiv_data <- read.xlsx("Data/reserach/prevdata.xlsx")
hiv_data

# Load socioeconomic factors data
socioeconomic_data <- read.xlsx("Data/reserach/Factors.xlsx")
socioeconomic_data
# Merge HIV prevalence data with socioeconomic factors data based on Province
merged_data <- merge(hiv_data, socioeconomic_data, by = "province")

# Correlation analysis
correlation_matrix <- cor(merged_data[, -c(1, 4)])

# Visualization: Heatmap of correlation matrix
heatmap(correlation_matrix, 
        col = colorRampPalette(c("blue", "white", "red"))(50), 
        main = "Correlation Heatmap of HIV Prevalence and Socioeconomic Factors")

# Regression analysis
lm_model <- lm(prev ~ ., data = merged_data[, -c(1, 4)])
summary(lm_model)

# Spatial analysis: Visualization of HIV prevalence rates
# You may need additional geographic data to plot spatial maps

# Additional analysis and interpretation based on the results
