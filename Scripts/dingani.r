#Loading packages #GithubRepo
source("scripts/r prep2.r")

## Question 2:
#1. Define x to be a sequence that runs from -4 to +4 in steps of 0.25. In one additional line of code,
#determine the number of elements in x.

# Define x sequence

x <- seq(-4, 4, by = 0.25)
num_elements <- length(x)

num_elements

#2. Now define y to be the exponent of x
# Define y as the exponent of x
y <- exp(x)
y

#3. Now create two plots, side-by-side, in the same plotting window.
#In the left-hand one, plot y against x using filled black circles for the points.
#In the right-hand one, plot the natural logarithm of y against x, using open (unfilled) black circles.
#Use base R or `ggplot2` (your choice!).

# Create the plots
par(mfrow = c(1, 2))  # Arrange plots side-by-side

# Left plot: y against x with filled black circles
plot(x, y, type = "p", pch = 16, col = "black", main = "y vs x",
     xlab = "x", ylab = "y")

# Right plot: natural logarithm of y against x with open black circles
plot(x, log(y), type = "p", pch = 1, col = "black", main = "log(y) vs x",
     xlab = "x", ylab = "log(y)")

#4. For bonus marks, remake the same above two plots, but this time plot a
#smooth curve in each case instead of plotting the data points as a dots (circles). Use Google or R help files to figure it out!
# Bonus: Smooth curve instead of plotting data points
# Left plot with smooth curve
# Create the plots
par(mfrow = c(1, 2))  # Arrange plots side-by-side

# Left plot: y against x with smooth curve
plot(x, y, type = "l", col = "blue", main = "y vs x (Smooth Curve)",
     xlab = "x", ylab = "y")

# Right plot: natural logarithm of y against x with smooth curve
plot(x, log(y), type = "l", col = "red", main = "log(y) vs x (Smooth Curve)",
     xlab = "x", ylab = "log(y)")


ggsave("viz/Dingani/smooth plots.png",
       device="png",
       type="cairo",
       height = 6.0,
       width = 13)




