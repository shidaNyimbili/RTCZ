source("scripts/r prep2.r")

socioeconomic_data <- read.xlsx("Data/reserach/Factors.xlsx")
socioeconomic_data
# Merge HIV prevalence data with socioeconomic factors data based on Province
merged_data <- merge(hiv_data, socioeconomic_data, by = "province")
merged_data

# Initialize an empty data frame to store results
correlation_results <- data.frame(district = character(), 
                                  avg_prev_epidemiological = numeric(),
                                  avg_prev_health_system = numeric(),
                                  avg_prev_population_density = numeric(),
                                  stringsAsFactors = FALSE)

# Loop through each district
for (district in unique(correlation_data_unique$district)) {
  # Subset the data for the current district
  district_data <- subset(correlation_data_unique, district == district)
  
  # Calculate correlation
  avg_prev_epidemiological <- cor(district_data$Average.of.prev, district_data$Epidemiological)
  avg_prev_health_system <- cor(district_data$Average.of.prev, district_data$Health_System)
  avg_prev_population_density <- cor(district_data$Average.of.prev, district_data$Population_Density)
  
  # Append results to correlation_results data frame
  correlation_results <- rbind(correlation_results, 
                               data.frame(district = district,
                                          avg_prev_epidemiological = avg_prev_epidemiological,
                                          avg_prev_health_system = avg_prev_health_system,
                                          avg_prev_population_density = avg_prev_population_density))
}

# Print correlation results
print(correlation_results)

###Method 2
# Initialize an empty list to store correlations for each district
correlation_list <- list()

# Loop through each district
for (district in unique(merged_data$district)) {
  # Subset the data for the current district
  district_data <- merged_data[merged_data$district == district, ]
  
  # Calculate correlations for the current district
  correlations <- cor(district_data[c("Average.of.prev", "Epidemiological", "Health_System", "Socio_Economic", "Population_Density")])
  
  # Store correlations in the list with the district name as the key
  correlation_list[[district]] <- correlations
}

# View correlations for each district
for (district in names(correlation_list)) {
  print(paste("Correlations for", district, ":"))
  print(correlation_list[[district]])
}

##New Method
# Initialize an empty list to store correlations for each district
correlation_list <- list()

# Loop through each district
for (district in unique(merged_data$district)) {
  # Subset the data for the current district
  district_data <- merged_data[merged_data$district == district, ]
  
  # Check if there is sufficient data to compute correlations
  if (nrow(district_data) > 1) {
    # Calculate correlations for the current district
    correlations <- cor(district_data[c("Average.of.prev", "Epidemiological", "Health_System", "Socio_Economic", "Population_Density")])
    
    # Store correlations in the list with the district name as the key
    correlation_list[[district]] <- correlations
  } else {
    # If there is insufficient data, print a message
    print(paste("Insufficient data for", district))
  }
}

# View correlations for each district
for (district in names(correlation_list)) {
  print(paste("Correlations for", district, ":"))
  print(correlation_list[[district]])
}

#Method444
# Load the necessary library
library(dplyr)

merged_data


# Initialize an empty list to store correlations for each district
correlation_list <- list()

# Loop through each district
for (district in unique(merged_data$district)) {
  # Subset the data for the current district
  district_data <- merged_data[merged_data$district == district, ]
  
  # Check if there is sufficient data to compute correlations
  if (nrow(district_data) > 1) {
    # Calculate correlations for the current district
    correlations <- cor(district_data[c("Average.of.prev", "Epidemiological", "Health_System", "Socio_Economic", "Population_Density")])
    
    # Store correlations in the list with the district name as the key
    correlation_list[[district]] <- correlations
  } else {
    # If there is insufficient data, print a message
    print(paste("Insufficient data for", district))
  }
}

# View correlations for each district
for (district in names(correlation_list)) {
  print(paste("Correlations for", district, ":"))
  print(correlation_list[[district]])
}

#Analysis for each district
# Load required libraries
library(dplyr)
library(ggplot2)
library(lmtest)

# Read the data

merged_data

# Iterate over each district
districts <- unique(merged_data$district)
results <- list()

for (district in districts) {
  # Subset data for the current district
  district_data <- merged_data[merged_data$district == district, ]
  
  # 1. Data Exploration
  print(paste("District:", district))
  summary(district_data$Average.of.prev)
  
  # 2. Correlation Analysis
  correlation_matrix <- cor(district_data[, c("Average.of.prev", "Epidemiological", "Health_System", "Population_Density", "Socio_Economic")])
  print(correlation_matrix)
  
  # 3. Regression Analysis
  model <- lm(Average.of.prev ~ Epidemiological + Health_System + Population_Density + Socio_Economic, data = district_data)
  print(summary(model))
  
  # Store results
  results[[district]] <- list(
    summary_stats = summary(model),
    correlation_matrix = correlation_matrix
  )
}

# Access results for a specific district, e.g., Chibombo
chibombo_results <- results[["Chibombo"]]

# 4. Spatial Analysis
# You'll need shapefile data for provinces/districts to perform this analysis

# 5. Subgroup Analysis
# You can perform subgroup analysis within each district if needed

# 6. Qualitative Insights
# Collect qualitative data through interviews or surveys

# 7. Policy Implications
# Based on the findings, suggest interventions and policies

###Province
summary(merged_data$Average.of.prev)

# Boxplot of HIV/AIDS prevalence rates by province
ggplot(merged_data, aes(x = province, y = Average.of.prev)) +
  geom_boxplot() +
  labs(title = "Boxplot of HIV/AIDS Prevalence Rates by Province")

# 2. Correlation Analysis
correlation_matrix <- cor(merged_data[, c("Average.of.prev", "Epidemiological", "Health_System", "Population_Density", "Socio_Economic")])
print(correlation_matrix)

# 3. Regression Analysis
model <- lm(Average.of.prev ~ Epidemiological + Health_System + Population_Density + Socio_Economic, data = merged_data)
summary(model)

# 4. Spatial Analysis
# You'll need shapefile data for provinces/districts to perform this analysis

# 5. Subgroup Analysis
# Scatterplot of HIV/AIDS prevalence rates by population density
ggplot(merged_data, aes(x = Population_Density, y = Average.of.prev)) +
  geom_point() +
  labs(title = "Scatterplot of HIV/AIDS Prevalence Rates by Population Density")

# 6. Qualitative Insights
# Collect qualitative data through interviews or surveys

# 7. Policy Implications
# Based on the findings, suggest interventions and policies


# Load required libraries
library(dplyr)
library(ggplot2)
library(lmtest)

# Read the data
merged_data <- read.csv("path_to_your_data.csv")

# Iterate over each district
districts <- unique(merged_data$district)
results <- list()

for (district in districts) {
  # Subset data for the current district
  district_data <- merged_data[merged_data$district == district, ]
  
  # 1. Data Exploration
  print(paste("District:", district))
  summary(district_data$Average.of.prev)
  
  # 2. Correlation Analysis
  correlation_matrix <- cor(district_data[, c("Average.of.prev", "Epidemiological", "Health_System", "Population_Density", "Socio_Economic")])
  print(correlation_matrix)
  
  # 3. Regression Analysis
  model <- lm(Average.of.prev ~ Epidemiological + Health_System + Population_Density + Socio_Economic, data = district_data)
  print(summary(model))
  
  # Store results
  results[[district]] <- list(
    summary_stats = summary(model),
    correlation_matrix = correlation_matrix
  )
}

# Access results for a specific district, e.g., Chibombo
chibombo_results <- results[["Chibombo"]]


###Alternative
soc1 <- read.xlsx("Data/reserach/outdist.xlsx")
soc1

soc <- soc1 %>%
  rename(hiv_prev = 2)

soc

# Fit a linear regression model for each district
district_models <- soc %>%
  group_by(district) %>%
  do(model = lm(Average.of.prev ~ Epidemiological + Health_System + Population_Density + Socio_Economic, data = .))

# Extract coefficients for each district
coefficients_df <- district_models %>%
  mutate(coefficients = list(summary(model)$coefficients)) %>%
  select(district, coefficients) %>%
  unnest(coefficients)

# Print coefficients for each district
print(coefficients_df)
