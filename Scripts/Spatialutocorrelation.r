##Spatial autocorrelation
#Detection Change

source("scripts/r prep2.r")

# Read shapefile
districts_zam <- st_read("Data/Updated Shapefiles/Districts.shp")

# Read HIV.prevalence.rates data
prev.data <- read_xlsx("Data/reserach/Change_Detection.xlsx")

prev.data

# Extract year from the 'period' column
# prev.data <- prev.data %>%
#   mutate(year = str_sub(period, start = nchar(period) - 4, end = nchar(period)))

# Select relevant columns and handle missing values
# prev.data.1 <- prev.data %>%
#   select(1, 2, 3, 5) %>%
#   na.omit()

# Rename columns
prev.data.2 <- prev.data %>%
  rename(distrt = 1,
         chnge = 2,
         yr = 3)

prev.data.2

# Reshape the data
prev.data.3 <- prev.data.2 %>%
  gather(key = subRt, value = rate, c(chnge))

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

prev.data.5

prevdata.2021 <- prev.data.5 %>%
  select(1,2,3,4,5)

prevdata.2021

# Check the structure of the data
summary(prevdata.2021)

names(prevdata.2021)

# Choose the data for one year (replace "YYYY" with the year you want to analyze)
# selected_year <- 2023
# prevdata_year <- prevdata.2021[prevdata.2021$yr == 2023, ]

# Visualize the spatial distribution of HIV/AIDS prevalence rates
# plot(prevdata_year["rate"])
# 
# prevdata_year

# library(sf)

prevdata_year <- st_make_valid(prevdata.2021)

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
