install.packages("caret")
library(lm)
installed.packages("lm")

# Load the necessary libraries
library(caret)

# Load the dataset
data <- read.csv("data.csv")

# Split the data into training and test sets
set.seed(123)
train_ind <- createDataPartition(data$target, p = 0.8, list = FALSE)
train <- data[train_ind, ]
test <- data[-train_ind, ]

# Build the model using the training data
model <- train(target ~ ., data = train, method = "lm")

# Make predictions on the test data
predictions <- predict(model, test)

# Evaluate the model's performance
accuracy <- mean(predictions == test$target)
print(accuracy)
