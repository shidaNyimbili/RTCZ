


# Read in the data from a CSV file
data <- read.csv("data.csv")

# Remove rows with missing values
clean_data <- data[complete.cases(data), ]

# Replace remaining missing values with the column mean
clean_data <- apply(clean_data, 2, function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x))
