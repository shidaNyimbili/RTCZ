
source("scripts/r prep2.r")
# Creating the data frame
region_data <- data.frame(
  Region = c("Lusaka", "Copperbelt", "Luapula", "Eastern", "Central", "Southern", 
             "Northern", "Muchinga", "Western", "North-Western"),
  Population = c(3072000, 2585000, 1684000, 2157000, 2224000, 2174000, 
                 1600000, 1038000, 1097000, 1059000),
  Epidemiological = c(1, 0.9, 0.6, 0.7, 0.8, 0.4, 0.2, 0.3, 0, 0.1),
  Health_System = c(0.1, 0.2, 0.3, 0.4, 0, 0.7, 0.8, 1, 0.9, 0.6),
  Population_Density = c(1, 0.9, 0.8, 0.7, 0.6, 0.4, 0.3, 0.2, 0.1, 0),
  Socio_Economic = c(0.1, 0, 0.4, 0.6, 0.3, 0.2, 1, 0.7, 0.9, 0.8),
  Transport_Availability = c(0, 0.1, 0.3, 0.6, 0.2, 0.7, 0.4, 0.9, 1, 0.8)
)

# Displaying the data
print(region_data)

# Descriptive statistics
summary(region_data)
```

This code creates a data frame, prints the data, and provides a summary of the descriptive statistics for each variable in the data frame. You can customize the analysis based on your specific requirements.


##dDestrictive Analysis by region
# Creating the data frame
region_data <- data.frame(
  Region = c("Lusaka", "Copperbelt", "Luapula", "Eastern", "Central", "Southern", 
             "Northern", "Muchinga", "Western", "North-Western"),
  Epidemiological = c(1, 0.9, 0.6, 0.7, 0.8, 0.4, 0.2, 0.3, 0, 0.1),
  Health_System = c(0.1, 0.2, 0.3, 0.4, 0, 0.7, 0.8, 1, 0.9, 0.6),
  Population_Density = c(1, 0.9, 0.8, 0.7, 0.6, 0.4, 0.3, 0.2, 0.1, 0),
  Socio_Economic = c(0.1, 0, 0.4, 0.6, 0.3, 0.2, 1, 0.7, 0.9, 0.8),
  Transport_Availability = c(0, 0.1, 0.3, 0.6, 0.2, 0.7, 0.4, 0.9, 1, 0.8)
)

# Loop for descriptive analysis by region
for (region in unique(region_data$Region)) {
  cat("Descriptive Analysis for", region, ":\n")
  region_subset <- subset(region_data, Region == region)
  print(summary(region_subset))
  cat("\n")
}

# Creating an empty list to store captured output
output_list <- list()

# Loop for descriptive analysis by region
for (region in unique(region_data$Region)) {
  cat("Descriptive Analysis for", region, ":\n")
  region_subset <- subset(region_data, Region == region)
  
  # Capture the output of summary(region_subset)
  output <- capture.output(print(summary(region_subset)))
  
  # Append the captured output to the list
  output_list[[region]] <- output
  
  cat("\n")
}

# Write the captured output to a text file
writeLines(unlist(output_list), "Descriptive_Analysis_Results.txt")

