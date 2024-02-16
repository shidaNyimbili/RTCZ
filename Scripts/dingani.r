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

#'*Note here i have plotted using Base R*
# Create the plots
par(mfrow = c(1, 2))  # Arrange plots side-by-side

# Left plot: y against x with filled black circles
plot(x, y, type = "p", pch = 16, col = "black", main = "y vs x",
     xlab = "x", ylab = "y")

# Right plot: natural logarithm of y against x with open black circles
plot(x, log(y), type = "p", pch = 1, col = "black", main = "log(y) vs x",
     xlab = "x", ylab = "log(y)")

#saving the plot
filepath <- "viz/Dingani/pointplots2.png"
dev.copy(png, filename = filepath, width = 13, height = 6, units = 'in', res = 300)

# Close the current plotting device
#dev.off()

#4. For bonus marks, remake the same above two plots, but this time plot a
#smooth curve in each case instead of plotting the data points as a dots (circles). Use Google or R help files to figure it out!
# Bonus: Smooth curve instead of plotting data points

#'*Here i will use ggplot2*
#'*Reason is just show you both approaches*


# Create data frames for ggplot to work
y <- exp(x)
data1 <- data.frame(x = x, y = y)
data2 <- data.frame(x = x, log_y = log(y))

# Left plot: y against x with smooth curve
p1 <- ggplot(data1, aes(x = x, y = y)) +
  geom_line(color = "black") +
  labs(title = "y vs x", x = "x", y = "y") +
  theme(panel.border = element_rect(color = "black", fill = NA, size = 1))

# Right plot: natural logarithm of y against x with smooth curve
p2 <- ggplot(data2, aes(x = x, y = log_y)) +
  geom_line(color = "red") +
  labs(title = "log(y) vs x", x = "x", y = "log(y)") +
  theme(panel.border = element_rect(color = "black", fill = NA, size = 1))

p1 + p2 + plot_layout(guides = "collect")

# # Save the plots
# filepath <- "viz/Dingani/smooth_plots.png"
# ggsave(filename = filepath, plot = arrangeGrob(p1, p2, ncol = 2), width = 13, height = 6)

ggsave("viz/Dingani/smoothplots.png",
       device="png",
       type="cairo",
       height = 6.0,
       width = 13)




