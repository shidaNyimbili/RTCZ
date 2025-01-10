source("scripts/r prep2.r")

# Read shapefile
districts_zam <- st_read("Data/Updated Shapefiles/Districts.shp")

# Read HIV.prevalence.rates data
prev.data <- read_xlsx("Data/reserach/prevdata.xlsx")
actionhiv <- read_xlsx("Data/reserach/prevdataactionhiv.xlsx")


prev.data

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

prev.data.2

# Reshape the data
prev.data.3 <- prev.data.2 %>%
  gather(key = subRt, value = rate, c(prev.rt))

prev.data.3

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

prev.data.5


# Define a reversed color palette
rev_palette <- rev(RColorBrewer::brewer.pal(9, "Blues"))

# Plotting
plot <- ggplot() +
  geom_sf(data = prev.data.5, aes(fill = rate)) +
  scale_fill_gradient(name = "Prev Rates(%)",
                      low = rev_palette[length(rev_palette)],
                      high = rev_palette[1]) +
  ggtitle("Spatial Distribution of HIV/AIDS Prevalence Rates Across Districts") +
  facet_wrap(~yr) + theme_minimal()

# View the plot
print(plot)


# # Load necessary libraries
# library(tidyverse)
# library(ggplot2)
# library(forecast)

# Step 1: Calculate summary statistics

hiv_data <- prev.data.2 %>%
  rename(province = 1,
         district = 2,
         HIV.prevalence.rate = 3,
         period = 4)

hiv_data

summary_stats <- hiv_data %>%
  group_by(period) %>%
  summarise(
    mean_rate = mean(`HIV.prevalence.rate`),
    median_rate = median(`HIV.prevalence.rate`),
    min_rate = min(`HIV.prevalence.rate`),
    max_rate = max(`HIV.prevalence.rate`)
  )

print("Summary Statistics:")
print(summary_stats)

hiv_data

# Define a reversed color palette
rev_palette <- rev(RColorBrewer::brewer.pal(9, "Blues"))

# Step 2: Visualize the temporal trend of HIV.prevalence.rates
ggplot(hiv_data, aes(x = as.factor(period), y = `HIV.prevalence.rate`, color = district)) +
  geom_line() +
  geom_point() +
  facet_wrap(~period)+
  labs(title = "Temporal Trend of HIV.prevalence.rates by District (2020-2023)",
       x = "Year", y = "HIV.prevalence.rate") +
  scale_fill_gradient(name = "Prev Rates(%)",
                      low = rev_palette[length(rev_palette)],
                      high = rev_palette[1]) +
  theme_minimal() +
  theme(legend.position="top", legend.box.background = element_rect())


# Install and load required packages if you haven't already
# library(ggplot2)
# library(viridis)  # Using the viridis color palette, which can handle more colors

# Generate a color palette with the required number of colors
num_districts <- length(unique(hiv_data$district))
palette <- viridis::viridis(num_districts)

# Create a named vector of colors for each district
districts <- unique(hiv_data$district)
district_colors <- setNames(palette, districts)

# Step 2: Visualize the temporal trend of HIV.prevalence.rates
ggplot(hiv_data, aes(x = as.factor(period), y = `HIV.prevalence.rate`, color = district)) +
  geom_line() +
  geom_point() +
  facet_wrap(~period) +
  labs(title = "Temporal Trend of HIV.prevalence.rates by District (2020-2023)",
       x = "Year", y = "HIV.prevalence.rate") +
  scale_color_manual(name = "District", values = district_colors) +
  theme_minimal() +
  theme(legend.position = "top", legend.box.background = element_rect())


####TEST2
library(ggplot2)
library(viridis)  # Using the viridis color palette, which can handle more colors

# Generate a color palette with the required number of colors
num_districts <- length(unique(hiv_data$district))
palette <- viridis::viridis(num_districts)

# Create a named vector of colors for each district
districts <- unique(hiv_data$district)
district_colors <- setNames(palette, districts)

# Filter data for the period 2020 to 2023
hiv_data_subset <- subset(hiv_data, period >= 2020 & period <= 2023)

# Visualize the temporal trend of HIV.prevalence.rates by District (2020-2023)
ggplot(hiv_data_subset, aes(x = as.factor(period), y = `HIV.prevalence.rate`, color = district)) +
  geom_line() +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +  # Add linear trend lines
  facet_wrap(~period) +
  labs(title = "Temporal Trend of HIV.prevalence.rates by District (2020-2023)",
       x = "Year", y = "HIV.prevalence.rate") +
  scale_color_manual(name = "District", values = district_colors) +
  theme_minimal() +
  theme(legend.position = "top", legend.box.background = element_rect())

##TEST2

###test3
library(ggplot2)
library(viridis)  # Using the viridis color palette, which can handle more colors

# Generate a color palette with the required number of colors
palette <- viridis::viridis(length(unique(hiv_data$district)))

# Filter data for the year 2020
hiv_data_2020 <- subset(hiv_data, period == 2020)

# Create a named vector of colors for each district
districts <- unique(hiv_data$district)
district_colors <- setNames(palette, districts)

# Visualize the temporal trend of HIV.prevalence.rates by District for the year 2020
ggplot(hiv_data_2020, aes(x = as.factor(period), y = `HIV.prevalence.rate`, color = district)) +
  geom_line() +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +  # Add linear trend lines
  labs(title = "Temporal Trend of HIV.prevalence.rates by District (Year: 2020)",
       x = "Year", y = "HIV.prevalence.rate") +
  scale_color_manual(name = "District", values = district_colors) +
  theme_minimal() +
  theme(legend.position = "top", legend.box.background = element_rect())

# You can repeat the above code for other years (2021, 2022, 2023) by changing the subset condition.

##Test3
##tes4
library(ggplot2)
library(dplyr)
library(tidyr)
library(viridis)

# Filter data for the years 2020 to 2023
hiv_data_subset <- hiv_data %>% filter(period %in% c(2020, 2021, 2022, 2023))

# Create small multiples using facet_wrap
ggplot(hiv_data_subset, aes(x = as.factor(period), y = `HIV.prevalence.rate`, group = district)) +
  geom_line(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  labs(title = "Temporal Trend of HIV Prevalence Rates by District (2020-2023)",
       x = "Year", y = "HIV Prevalence Rate") +
  facet_wrap(~ district, scales = "free_y", ncol = 4) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  scale_color_viridis(discrete = TRUE)

##test4
###test5
library(ggplot2)
library(reshape2)

# Convert data to wide format for heatmap
hiv_data_wide <- dcast(hiv_data, district ~ period, value.var = "HIV.prevalence.rate")

# Set row names as districts
row.names(hiv_data_wide) <- hiv_data_wide$district
hiv_data_wide$district <- NULL

# Print the structure of hiv_data_wide
str(hiv_data_wide)

hiv_data_wide

# Reshape the data to long format
hiv_data_long <- pivot_longer(hiv_data_wide, cols = everything(), names_to = "Year", values_to = "HIV_Prevalence_Rate")

hiv_data_long
# Create a heatmap
# Create a heatmap
ggplot(data = hiv_data_long, aes(x = Year, y = HIV_Prevalence_Rate, fill = HIV_Prevalence_Rate)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "HIV Prevalence Rates by District and Year",
       x = "Year", y = "District") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  theme_minimal()


##test5

##Animation
# Load necessary libraries
library(ggplot2)
library(gganimate)
library(tidyr)

# Assuming your data is named hiv_data

hiv_data$period <- as.Date(hiv_data$period, format = "%Y")

# Convert the data to long format
hiv_data_long <- pivot_longer(hiv_data, 
                              cols = -c(province, district, period),  # Exclude non-pivot columns
                              names_to = "Year", 
                              values_to = "HIV_Prevalence_Rate")

# Now 'hiv_data_long' should contain the data in the long format

# Check the structure of 'hiv_data_long'
str(hiv_data_long)

# Create an animated plot
animated_plot <- ggplot(data = hiv_data_long, aes(x = period, y = HIV_Prevalence_Rate, group = district)) +
  geom_line(aes(color = district)) +
  labs(title = "HIV Prevalence Rates Over Time",
       x = "Year", y = "HIV Prevalence Rate") +
  transition_reveal(district) +
  theme_minimal()

# Print the animated plot
print(animated_plot)
##Animation

# Step 3: Conduct statistical tests or time series analysis
# For simplicity, let's perform a linear regression to assess trends
linear_model <- lm(`HIV.prevalence.rate` ~ period, data = hiv_data)
print("Linear Regression Results:")
print(summary(linear_model))

# Additionally, you can explore time series decomposition or autocorrelation analysis
# For example, time series decomposition using seasonal decomposition of time series (STL)
hiv_time_series <- ts(hiv_data$`HIV.prevalence.rate`, start = c(2020, 1), end = c(2023, 1), frequency = 1)
stl_result <- stl(hiv_time_series, s.window = "periodic")
plot(stl_result)


##QUESTION 4

# Load required libraries
# library(spdep)
# library(rgdal)
# library(classInt)
# library(sp)
# library(raster)
# library(spdep)
# library(rgeos)
# install.packages('maptools', dependencies=TRUE)
# install.packages("rgeos")
# library(spData)
# install.packages('spDataLarge', repos='https://nowosad.github.io/drat/', type='source')
# remotes::install_github('r-tmap/tmap')
# library(tmap)
# library(tmaptools)

# Read the shapefile
prev.data.5

prevdata <- prev.data.5 %>%
  select(1,2,3,4,5,6)

prevdata

# Check the structure of the data
summary(prevdata)

names(prevdata)

# Choose the data for one year (replace "YYYY" with the year you want to analyze)
selected_year <- 2020
prevdata_year <- prevdata[prevdata$yr == 2020, ]

# Visualize the spatial distribution of HIV/AIDS prevalence rates
plot(prevdata_year["rate"])

# library(sf)

prevdata_year <- st_make_valid(prevdata_year)

prevdata_year

# Calculate spatial weights
nb <- poly2nb(prevdata_year, queen=TRUE)
W <- nb2listw(nb, style="W")

#' #'*KERNEL*
#' # Calculate Kernel weights
#' points_within_polygons <- st_sample(prevdata_year$geometry, size = 116, type = "random")
#' points_within_polygons
#' 
#' # Check the number of points generated within polygons
#' num_points <- length(points_within_polygons)
#' 
#' # Print the number of points
#' print(paste("Number of points generated within polygons:", num_points))
#' 
#' # Compute kernel weights
#' W_kernel <- knn2nb(knearneigh(st_coordinates(points_within_polygons), k = 4), row.names(points_within_polygons))
#' W_kernel <- nb2listw(W_kernel, style = "W")
#' 
#' # Global Moran's I using Kernel weights
#' moran_I_kernel <- moran.test(prevdata_year$rate, W_kernel)
#' print(moran_I_kernel)
#' 
#' # Moran Scatterplot
#' moran.plot(prevdata_year$rate, W_kernel, main = "Moran Scatterplot")
#' 
#' # Change the file format and file name as per your preference
#' dev.copy(png, "moran_scatterplot.png")
#' dev.off()
#' 
#' # Perform Local Moran's I analysis
#' localmoran <- localmoran(le, W_kernel)
#' 
#' # Extract Ii values and Z.Ii values
#' Ii_values <- localmoran[, "Ii"]
#' Z_Ii_values <- localmoran[, "Z.Ii"]
#' 
#' # Convert localmoran to a data frame
#' localmoran_df <- as.data.frame(localmoran)
#' 
#' # Access the "Ii" column using the $ operator
#' lisa <- localmoran_df[["Ii"]]
#' 
#' # Perform cluster analysis
#' lisa_clusters <- cut(lisa, breaks = c(-Inf, 1.645, Inf), labels = c("Not Significant", "Significant"))
#' 
#' # Plot LISA clusters
#' pal <- brewer.pal(3, "Set1")
#' plot(prevdata_year, col = pal[lisa_clusters], main = "Local Indicators of Spatial Association Cluster Map", cex.main = 0.8)
#' legend("bottomright", legend = levels(lisa_clusters), fill = pal, title = "Cluster Significance")

#'*QUEEN*
# Calculate spatial weights
nb <- poly2nb(prevdata_year, queen=TRUE)
W <- nb2listw(nb, style="W")
# Global Moran's I 
moran_I <- moran.test(prevdata_year$rate, W)
print(moran_I)

# Moran Scatterplot
moran.plot(prevdata_year$rate, W, main = "Moran Scatterplot:2020")

# Change the file format and file name as per your preference
dev.copy(png, "moran_scatterplot202020.png")
dev.off()

# Local Moran's I
localmoran <- localmoran(prevdata_year$rate, W)

localmoran

# Extract Ii values
Ii_values <- localmoran[, "Ii"]
# Extract Z.Ii values
Z_Ii_values <- localmoran[, "Z.Ii"]

# Print column names of localmoran object
colnames(localmoran)

str(localmoran)

# Convert localmoran to a data frame
localmoran_df <- as.data.frame(localmoran)

# Access the "Ii" column using the $ operator
localmoran_df$Ii


# Assuming you are trying to access the "I" column for Local Moran's I
# You can use the correct column name from your data structure
# Let's assume the correct column name is "Ii" or "I", replace it with the correct one
lisa <- localmoran_df[["Ii"]]  # or localmoran[["I"]]

# Now, you can perform your desired operation on the 'lisa' object
# For example, let's try the 'cut' function again
lisa_clusters <- cut(lisa, breaks = c(-Inf, 1.645, Inf), labels = c("Not Significant", "Significant"))

lisa_clusters

prevdata_year.1 <- prevdata_year %>%
  select(5,6)

# Plot LISA clusters
png("lisa_clusters_plot.png")

pal <- brewer.pal(3, "Set1")
plot(prevdata_year.1, col=pal[lisa_clusters], main="Local Indicators of Spatial Association Cluster: 2020", cex.main=0.8)
legend("bottomright", legend=levels(lisa_clusters), fill=pal, title="Cluster Significance")

dev.off()

# If you want to visualize the data
plot(prevdata_year["geometry"])

# Calculate centroids of the polygons
centroids <- st_centroid(prevdata_year$geometry)

# Extract longitude and latitude coordinates
prevdata_year$longitude <- st_coordinates(centroids)[, "X"]
prevdata_year$latitude <- st_coordinates(centroids)[, "Y"]

longitude <- prevdata_year$longitude
latitude <- prevdata_year$latitude

longitude
latitude

# Check column names
colnames(prevdata_year)

# Check class of the object
class(prevdata_year)


# Assuming prevdata_year is your sf object
prevdata_year <- st_as_sf(prevdata_year, coords = c("longitude", "latitude"), remove = FALSE)

# remove.packages("gstat")
# install.packages("gstat")


prevdata_year

# Spatial Interpolation (IDW)
idw_interpolation <- idw(formula = rate ~ 1, locations = prevdata_year, newdata = prevdata_year)

analysis <- idw_interpolation$var1.pred
analysis


#Plot the var1.pred: These are the predicted values resulting from the IDW interpolation.
plot(idw_interpolation["var1.pred"], main = "IDW Interpolation of HIV Prevalence Rate: 2020")

# Add names of the districts to the plot using latitude and longitude
text(x = prevdata_year$longitude, y = prevdata_year$latitude, labels = prevdata_year$distrt, cex = 0.7, pos = 1, vjust = 0.5, hjust = 0.5)
# text(x = prevdata_year$longitude, y = prevdata_year$latitude, labels = prevdata_year$distrt, cex = 0.7, pos = 1, offset= 2)
# text(x = prevdata_year$longitude, y = prevdata_year$latitude, labels = prevdata_year$distrt, cex = 0.7, pos = 1, offset = 1)



# Save IDW interpolation plot
png("viz/research/idw_interpolation.png")
plot(idw_interpolation, main = "IDW Interpolation of HIV Prevalence Rate: 2020")
dev.off()

##'*2021*


prev.data.5

prevdata.2021 <- prev.data.5 %>%
  select(1,2,3,4,5,6)

prevdata.2021

# Check the structure of the data
summary(prevdata.2021)

names(prevdata.2021)

# Choose the data for one year (replace "YYYY" with the year you want to analyze)
selected_year <- 2021
prevdata_year <- prevdata.2021[prevdata.2021$yr == 2021, ]

# Visualize the spatial distribution of HIV/AIDS prevalence rates
plot(prevdata_year["rate"])

# library(sf)

prevdata_year <- st_make_valid(prevdata_year)

prevdata_year

# Calculate spatial weights
nb <- poly2nb(prevdata_year, queen=TRUE)
W <- nb2listw(nb, style="W")

# Global Moran's I 
moran_I <- moran.test(prevdata_year$rate, W)
print(moran_I)

# Moran Scatterplot
moran.plot(prevdata_year$rate, W, main = "Moran Scatterplot: 2021")

# Change the file format and file name as per your preference
dev.copy(png, "moran_scatterplot 2021.png")
dev.off()


# Local Moran's I
localmoran <- localmoran(prevdata_year$rate, W)

localmoran

# Extract Ii values
Ii_values <- localmoran[, "Ii"]
# Extract Z.Ii values
Z_Ii_values <- localmoran[, "Z.Ii"]

# Print column names of localmoran object
colnames(localmoran)

str(localmoran)

# Convert localmoran to a data frame
localmoran_df <- as.data.frame(localmoran)

# Access the "Ii" column using the $ operator
localmoran_df$Ii


# Assuming you are trying to access the "I" column for Local Moran's I
# You can use the correct column name from your data structure
# Let's assume the correct column name is "Ii" or "I", replace it with the correct one
lisa <- localmoran_df[["Ii"]]  # or localmoran[["I"]]

# Now, you can perform your desired operation on the 'lisa' object
# For example, let's try the 'cut' function again
lisa_clusters <- cut(lisa, breaks = c(-Inf, 1.645, Inf), labels = c("Not Significant", "Significant"))

lisa_clusters

prevdata_year

prevdata_year.2 <- prevdata_year %>%
  select(5,6)

# Plot LISA clusters
png("lisa_clusters_plot2021.png")

pal <- brewer.pal(3, "Set1")
plot(prevdata_year.2, col=pal[lisa_clusters], main="Local Indicators of Spatial Association Cluster: 2021", cex.main=0.8)
legend("bottomright", legend=levels(lisa_clusters), fill=pal, title="Cluster Significance")

dev.off()

# If you want to visualize the data
plot(prevdata_year["geometry"])


##'*2022*


prev.data.5

prevdata.2022 <- prev.data.5 %>%
  select(1,2,3,4,5,6)

prevdata.2022

# Check the structure of the data
summary(prevdata.2022)

names(prevdata.2022)

# Choose the data for one year (replace "YYYY" with the year you want to analyze)
selected_year <- 2022
prevdata_year <- prevdata.2022[prevdata.2022$yr == 2022, ]

# Visualize the spatial distribution of HIV/AIDS prevalence rates
plot(prevdata_year["rate"])

# library(sf)

prevdata_year <- st_make_valid(prevdata_year)

prevdata_year

# Calculate spatial weights
nb <- poly2nb(prevdata_year, queen=TRUE)
W <- nb2listw(nb, style="W")

# Global Moran's I 
moran_I <- moran.test(prevdata_year$rate, W)
print(moran_I)

# Moran Scatterplot
moran.plot(prevdata_year$rate, W, main = "Moran Scatterplot: 2022")

# Change the file format and file name as per your preference
dev.copy(png, "moran_scatterplot 2022.png")
dev.off()


# Local Moran's I
localmoran <- localmoran(prevdata_year$rate, W)

localmoran

# Extract Ii values
Ii_values <- localmoran[, "Ii"]
# Extract Z.Ii values
Z_Ii_values <- localmoran[, "Z.Ii"]

# Print column names of localmoran object
colnames(localmoran)

str(localmoran)

# Convert localmoran to a data frame
localmoran_df <- as.data.frame(localmoran)

# Access the "Ii" column using the $ operator
localmoran_df$Ii


# Assuming you are trying to access the "I" column for Local Moran's I
# You can use the correct column name from your data structure
# Let's assume the correct column name is "Ii" or "I", replace it with the correct one
lisa <- localmoran_df[["Ii"]]  # or localmoran[["I"]]

# Now, you can perform your desired operation on the 'lisa' object
# For example, let's try the 'cut' function again
lisa_clusters <- cut(lisa, breaks = c(-Inf, 1.645, Inf), labels = c("Not Significant", "Significant"))

lisa_clusters

prevdata_year

prevdata_year.3 <- prevdata_year %>%
  select(5,6)

# Plot LISA clusters
png("lisa_clusters_plot2022.png")

pal <- brewer.pal(3, "Set1")
plot(prevdata_year.3, col=pal[lisa_clusters], main="Local Indicators of Spatial Association Cluster: 2022", cex.main=0.8)
legend("bottomright", legend=levels(lisa_clusters), fill=pal, title="Cluster Significance")

dev.off()

# If you want to visualize the data
plot(prevdata_year["geometry"])


##'*2023*


prev.data.5

prevdata.2023 <- prev.data.5 %>%
  select(1,2,3,4,5,6)

prevdata.2022

# Check the structure of the data
summary(prevdata.2023)

names(prevdata.2023)

# Choose the data for one year (replace "YYYY" with the year you want to analyze)
selected_year <- 2023
prevdata_year <- prevdata.2023[prevdata.2023$yr == 2023, ]

# Visualize the spatial distribution of HIV/AIDS prevalence rates
plot(prevdata_year["rate"])

# library(sf)

prevdata_year <- st_make_valid(prevdata_year)

prevdata_year

# Calculate spatial weights
nb <- poly2nb(prevdata_year, queen=TRUE)
W <- nb2listw(nb, style="W")

# Global Moran's I 
moran_I <- moran.test(prevdata_year$rate, W)
print(moran_I)

# Moran Scatterplot
moran.plot(prevdata_year$rate, W, main = "Moran Scatterplot: 2023")

# Change the file format and file name as per your preference
dev.copy(png, "moran_scatterplot 2023.png")
dev.off()


# Local Moran's I
localmoran <- localmoran(prevdata_year$rate, W)

localmoran

# Extract Ii values
Ii_values <- localmoran[, "Ii"]
# Extract Z.Ii values
Z_Ii_values <- localmoran[, "Z.Ii"]

# Print column names of localmoran object
colnames(localmoran)

str(localmoran)

# Convert localmoran to a data frame
localmoran_df <- as.data.frame(localmoran)

# Access the "Ii" column using the $ operator
localmoran_df$Ii


# Assuming you are trying to access the "I" column for Local Moran's I
# You can use the correct column name from your data structure
# Let's assume the correct column name is "Ii" or "I", replace it with the correct one
lisa <- localmoran_df[["Ii"]]  # or localmoran[["I"]]

# Now, you can perform your desired operation on the 'lisa' object
# For example, let's try the 'cut' function again
lisa_clusters <- cut(lisa, breaks = c(-Inf, 1.645, Inf), labels = c("Not Significant", "Significant"))

lisa_clusters

prevdata_year

prevdata_year.4 <- prevdata_year %>%
  select(5,6)

# Plot LISA clusters
png("lisa_clusters_plot2023.png")

pal <- brewer.pal(3, "Set1")
plot(prevdata_year.4, col=pal[lisa_clusters], main="Local Indicators of Spatial Association Cluster: 2023", cex.main=0.8)
legend("bottomright", legend=levels(lisa_clusters), fill=pal, title="Cluster Significance")

dev.off()

# If you want to visualize the data
plot(prevdata_year["geometry"])