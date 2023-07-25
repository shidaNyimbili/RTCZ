#1: Data Preparation
# Load required libraries
source("scripts/r prep2.r")

# Read the dataset
data <- read.csv("data.csv")

#2: Data Exploration
# Summary statistics
summary(data)

# Visualization
ggplot(data, aes(x = variable_of_interest)) +
  geom_bar() +
  labs(title = "Distribution of Variable of Interest",
       x = "Variable of Interest",
       y = "Count")

#3: Model Building and Evaluation
# Split data into training and testing sets
set.seed(123)
split <- sample.split(data$poor_performance, SplitRatio = 0.7)
train_data <- subset(data, split == TRUE)
test_data <- subset(data, split == FALSE)

# Fit a logistic regression model
model <- glm(poor_performance ~., data = train_data, family = "binomial")

# Make predictions on test set
predictions <- predict(model, newdata = test_data, type = "response")
predicted_classes <- ifelse(predictions > 0.5, 1, 0)

# Confusion matrix to evaluate model performance
conf_matrix <- table(predicted_classes, test_data$poor_performance)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(conf_matrix)
print(paste("Accuracy:", accuracy))

#4 Identifying Poor Performing Indicators

# Extract coefficient estimates from the model
coefficients <- coef(model)

# Sort coefficients in descending order to identify poor performing indicators
sorted_coefficients <- sort(coefficients, decreasing = TRUE)

# Print top indicators contributing to poor performance
print("Top Indicators for Poor Performance:")
print(names(sorted_coefficients[1:5]))

