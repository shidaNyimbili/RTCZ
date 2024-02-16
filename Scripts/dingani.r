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
       type="cairo",
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





