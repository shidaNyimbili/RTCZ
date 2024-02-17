#Loading packages
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

#dev.off()

#4. For bonus marks, remake the same above two plots, but this time plot a
#smooth curve in each case instead of plotting the data points as a dots (circles). Use Google or R help files to figure it out!
# Bonus: Smooth curve instead of plotting data points

#'*Here i will use ggplot2*
#'*Reason is just show you both approaches*


# Create data frames for ggplot to work
y <- exp(x)
dat1 <- data.frame(x = x, y = y)
dat2 <- data.frame(x = x, log_y = log(y))

# Left plot: y against x with smooth curve
p1 <- ggplot(dat1, aes(x = x, y = y)) +
  geom_line(color = "black") +
  labs(title = "y vs x", x = "x", y = "y") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 1))

# Right plot: natural logarithm of y against x with smooth curve
p2 <- ggplot(dat2, aes(x = x, y = log_y)) +
  geom_line(color = "black") +
  labs(title = "log(y) vs x", x = "x", y = "log(y)") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 1))

p1 + p2 + plot_layout(guides = "collect")


ggsave("viz/Dingani/smoothplots.png",
       device="png",
       type="Cairo",
       height = 6.0,
       width = 13)

#### Question 3:
#1. Read in the $mDat.csv$ data file.

mDat <- read_xlsx("Data/Dingani/mDat.xlsx")

# # Select relevant columns and handle missing/blank cells
 mdat <- mDat %>%
   select(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) %>%
   na.omit()

mdat
glimpse(mdat)
names(mdat)

#2. Determine the dimensions of the data frame.
dim(mdat)
dim.data.frame(mdat)

#3. Count up (using R code!) the number of observations (rows) for each 
#taxonomic order ("order" column) in the dataset.

table(mdat$order)

#4. Subset the data for just the orders "Artiodactyla" and "Primates".
subset_mdat <- subset(mdat, order %in% c("Artiodactyla", "Primates"))
subset_mdat

# Write the data frame mdata to an Excel file
write.xlsx(mdat, "Data/Dingani/subset_mdat.xlsx", rowNames = FALSE)

#5. Now subset the resulting new (smaller) dataframe for rows 1 to 100 AND for rows 200 to 300
# Check the dimensions of the data frame
dim(subset_mdat)

# Subset rows 1 to 100 and rows 200 to 300 in subset_mdat
subset_mdat.1 <- subset_mdat %>%
  slice(c(1:100, 200:300))

subset_mdat.1

# 6. Now retain only the columns called "order", "family", and "genus".
subset_ofg <- subset_mdat.1[, c("order", "family", "genus")]

subset_ofg

write.xlsx(subset_ofg, "Data/Dingani/subset_OrderFamilyGenius.xlsx", rowNames = FALSE)

# 7. Now determine the dimensions of the resulting (again smaller) dataframe.
dim(subset_ofg)

#8. Finally, for a bonus point, count (using R code!) the number of unique observations
#for each combination of order and family in the final dataset produced after the above 7 steps.
# Count the number of unique observations for each combination of order and family

subset_ofg

count_unique_obs <- subset_ofg %>%
  group_by(order, family) %>%
  summarise(count_unique_obs = n_distinct(genus))

count_unique_obs
write.xlsx(count_unique_obs, "Data/Dingani/count_unique_obs.xlsx", rowNames = FALSE)

## Question 4:
#1. Using the `mDat.csv` dataset again, take the natural logarithm of the
#"b_weight" column and store it as a new variable (column) in the dataframe.

mDat
mDat$log_b_weight <- log(mDat$b_weight)

mDat$log_b_weight

# 2. Calculate the mean, standard deviation, and sample size for each taxonomic order
stats_mean.StDV <- mDat %>%
  group_by(order) %>%
  summarise(mean_log_b_weight = mean(log_b_weight, na.rm = TRUE),
            sd_log_b_weight = sd(log_b_weight, na.rm = TRUE),
            n = n())
stats_mean.StDV
write.xlsx(stats_mean.StDV, "Data/Dingani/summary_stats.xlsx", rowNames = FALSE)

# 3. Calculate the standard error for the log(b_weight) variable for each taxonomic order
stats_mean.StDV.error <- stats_mean.StDV %>%
  mutate(SE_log_b_weight = sd_log_b_weight / sqrt(n))

stats_mean.StDV.error

write.xlsx(stats_mean.StDV.error, "Data/Dingani/summary_stats_error.xlsx", rowNames = FALSE)

# 4. Calculate the mean value for the `litters_yr` variable
#This value is stored in "mean_litters_yr" column
mean_litters_yr <- mean(mDat$litters_yr, na.rm = TRUE)

#Mean value
mean_litters_yr

# Here i am Subtract the mean value from each individual value of `litters_yr`
mDat$mean_centered_litters_yr <- mDat$litters_yr - mean_litters_yr

#'*Why do you get an error message here?*
#-----Reason---
#'*We may encounter errors due to missing or negative values in the litters_yr variable*
#'*Additionally, taking the logarithm of zero or negative values will result in NaN or Inf*
#'* And We handle missing or negative values using na.rm = TRUE and by adding a small constant*

mDat$log_mean_centered_litters_yr <- log(mDat$mean_centered_litters_yr + 1e-6)

#Finally, we print the dataset to observe the results and potential error messages.
mDat

names(mDat) #This shows that our calculations have been added to the dataframe

#For better obs, we export the dataframe into an excel
write.xlsx(mDat, "Data/Dingani/final_datasets.xlsx", rowNames = FALSE)


## Question 5:
#1. Generate a vector of 1000 random numbers drawn from a normal distribution of mean = 100 and *variance* = 25.

# Set the parameters
mean_val <- 100
variance_val <- 25

# Calculate the standard deviation
sd_val <- sqrt(variance_val)

# Generating the vector of random numbers
random_vector <- rnorm(1000, mean = mean_val, sd = sd_val)

# output of the first few elements of the vector
head(random_vector)

random_vector

#2. Now plot two histograms, side-by-side on the same single plot:

#Here we use the df made in the previosu question

random_vector

# The we Create a vector containing the natural logarithm of the random numbers
log_random_vector <- log(random_vector)


# Because we want to use ggplot2, we Create a data frame with the random and log-random variables
dat.random <- data.frame(random = random_vector, log_random = log_random_vector)


# Plot the histograms using ggplot
plt1 <- ggplot(dat.random, aes(x = random)) +
  geom_histogram(binwidth = 5, fill = "skyblue") +
  labs(title = "Histogram of Random Variable", x = "Value", y = "Frequency") +
  theme_minimal()

plt2 <- ggplot(dat.random, aes(x = log_random)) +
  geom_histogram(binwidth = 0.05, fill = "lightgreen") +
  labs(title = "Histogram of Log(Random Variable)", x = "Value", y = "Frequency") +
  theme_minimal()

plt1 + plt2 + plot_layout(guides = "collect")

ggsave("viz/Dingani/random.png",
       device="png",
       type="Cairo",
       height = 6.0,
       width = 13)
