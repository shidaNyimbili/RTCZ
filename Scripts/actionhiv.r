source("scripts/r prep2.r")

# Read shapefile
districts_zam <- st_read("Data/Updated Shapefiles/Districts.shp")

# Read HIV.prevalence.rates data
actionhiv <- read_xlsx("Data/reserach/prevdataactionhiv.xlsx")


actionhiv

# Extract year from the 'period' column
actionhiv <- actionhiv %>%
  mutate(year = str_sub(period, start = nchar(period) - 4, end = nchar(period)))

# Select relevant columns and handle missing values
actionhiv.1 <- actionhiv %>%
  select(1, 2, 3, 5) %>%
  na.omit()

# Rename columns
actionhiv.2 <- actionhiv.1 %>%
  rename(prov = 1,
         distrt = 2,
         prev.rt = 3,
         yr = 4)

actionhiv.2

# Reshape the data
actionhiv.3 <- actionhiv.2 %>%
  gather(key = subRt, value = rate, c(prev.rt))

actionhiv.3

# Extract relevant columns from provinces_zam
districts_zam1 <- districts_zam %>%
  select(7, 10) %>%
  na.omit()

# Group and join data
actionhiv.4 <- actionhiv.3 %>%
  group_by(yr, distrt, subRt)

actionhiv.5 <- left_join(actionhiv.4,
                         districts_zam1,
                         by = c("distrt" = "DISTRICT")) %>%
  sf::st_as_sf()

actionhiv.5


# Define a reversed color palette
rev_palette <- rev(RColorBrewer::brewer.pal(9, "Blues"))

# Plotting
plot <- ggplot() +
  geom_sf(data = actionhiv.5, aes(fill = rate)) +
  scale_fill_gradient(name = "Prev Rates(%)",
                      low = rev_palette[length(rev_palette)],
                      high = rev_palette[1]) +
  ggtitle("Spatial Distribution of HIV/AIDS Prevalence Rates Across Districts") +
  facet_wrap(~yr) + theme_minimal()

# View the plot
print(plot)

actionhiv_data <- read.xlsx("Data/reserach/Book3.xlsx")
actionhiv_data

socioeconomic_data <- read.xlsx("Data/reserach/Factorsaction.xlsx")
socioeconomic_data
# Merge HIV prevalence data with socioeconomic factors data based on Province
merged_data <- merge(actionhiv_data, socioeconomic_data, by = "province")
merged_data
write.xlsx(merged_data, file = "output_file_17.xlsx")


# Calculate the correlation matrix
correlation_matrix <- cor(merged_data[, c("Average.of.prev", "Epidemiological", "Health_System", "Population_Density", "Socio_Economic")])

# Print the correlation matrix
print(correlation_matrix)


# Convert columns to numeric and check for non-numeric values
merged_data$Epidemiological <- as.numeric(as.character(merged_data$Epidemiological))
merged_data$Health_System <- as.numeric(as.character(merged_data$Health_System))
merged_data$Population_Density <- as.numeric(as.character(merged_data$Population_Density))
merged_data$Socio_Economic <- as.numeric(as.character(merged_data$Socio_Economic))

# Coerce all columns to numeric except 'province' and 'period'

merged_data[, -c(1, 2)] <- sapply(merged_data[, -c(1, 2)], as.numeric)

# Check for any non-numeric values
if (any(is.na(merged_data))) {
  print("There are missing or non-numeric values in the data.")
}

# Now attempt to compute correlations
correlation_matrix <- cor(merged_data[, -c(1, 2)])
merged_data



# Correlation analysis
correlation_matrix <- cor(merged_data[, -c(1, 2)])

correlation_matrix

# Visualization: Heatmap of correlation matrix
heatmap(correlation_matrix, 
        col = colorRampPalette(c("blue", "white", "red"))(50), 
        main = "Correlation Heatmap of HIV Prevalence and Socioeconomic Factors")

merged_data

# Regression analysis
lm_model <- lm(Average.of.prev ~ ., data = merged_data[, -c(1, 2)])
summary(lm_model)

# Spatial analysis: Visualization of HIV prevalence rates
# You may need additional geographic data to plot spatial maps

# Additional analysis and interpretation based on the results
# Load necessary libraries


##Question 2 Additons

# Load HIV prevalence data
actionhiv_data <- read.xlsx("Data/reserach/Book2.xlsx")
actionhiv_data

# Load socioeconomic factors data
socioeconomic_data <- read.xlsx("Data/reserach/Factors.xlsx")
socioeconomic_data

# Load the HIV prevalence rates dataset
hiv_prevalence <- read.xlsx("Data/reserach/Book2.xlsx")

hiv_prevalence <- hiv_prevalence %>%
  rename(hivaids_prev = 1)

# Load the factors influencing HIV/AIDS prevalence dataset
factors <- read.xlsx("Data/reserach/Factors.xlsx")

# Merge the two datasets based on 'province'
merged_data <- merge(hiv_prevalence, factors, by = "province")

merged_data

# Check the merged dataset
head(merged_data)

# Correlation analysis
correlation_matrix <- cor(merged_data[, c(3:7)])

correlation_matrix

# Print correlation matrix
print(correlation_matrix)

# Plot correlation matrix
corrplot::corrplot(correlation_matrix, method = "color")

ggsave("viz/research/analysis1.png",
       plot,
       device = "png",
       type = "cairo",
       height = 7,
       width = 10)

# Check column names in the merged dataset
colnames(merged_data)

# Identify factors contributing to spatial variation in HIV/AIDS prevalence rates
summary(lm(Average.of.prev ~ Epidemiological + Health_System + Socio_Economic, data = merged_data))

