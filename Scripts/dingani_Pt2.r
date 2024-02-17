#Loading packages
source("scripts/r prep2.r")

#PART 2
## Question 1:
#1. Read in the "limpet.csv" data. In one line of code, determine how many 


limpet <- read_xlsx("Data/Dingani/limpet.xlsx")

limpet

#rows and columns are in this data frame.
dim(limpet)

#2.In one line of code, Count up the total number of data points for each unique combination of the variables SEASON and DENSITY
table(limpet$SEASON, limpet$DENSITY)

#3.Calculate the mean of the EGGS variable for each unique combination of the SEASON and DENSITY variables
aggregate(EGGS ~ SEASON + DENSITY, data = limpet, FUN = mean)


write.xlsx(limpet, "Data/Dingani/unq_com_mean.xlsx", rowNames = FALSE)# Write the data frame limpet to an Excel file


#4. Produce a clearly labelled scatterplot of EGGS as a function of DENSITY, 
#colour coding the two levels of SEASON differently, and add a legend

ggplot(limpet, aes(x = DENSITY, y = EGGS, color = SEASON)) +
  geom_point() +
  labs(x = "DENSITY", y = "EGGS", title = "Scatterplot of EGGS as a function of DENSITY") +
  scale_color_manual(values = c("spring" = "blue", "summer" = "red"), name = "SEASON")

ggsave("viz/Dingani/limpet_scatterplot.png",
       device="png",
       type="Cairo",
       height = 6.0,
       width = 13)

#5.Extract the data for just spring, and test whether EGGS and DENSITY are correlated
spring_data <- subset(limpet, SEASON == "spring")
cor.test(spring_data$EGGS, spring_data$DENSITY, method = "pearson")  # or use "spearman" for non-parametric test

# Extract the data for just summer, and test whether EGGS and DENSITY are correlated
summer_data <- subset(limpet, SEASON == "summer")
cor.test(summer_data$EGGS, summer_data$DENSITY, method = "pearson")  # or use "spearman" for non-parametric test


#'*Justification for method used*
#The Pearson correlation test assumes that the variables are normally distributed. 
#Since the sample size is reasonably large, and under the assumption that the data follows a normal distribution, 
#the Pearson correlation test is appropriate.

#The Pearson correlation test evaluates the linear relationship between two continuous variables. 
#It is suitable when we want to assess whether there is a linear association between the number of eggs (EGGS) 
#and the density (DENSITY) of limpets.

#Both the number of eggs and density are interval or ratio scale variables, 
#meeting the requirements of the Pearson correlation test.


## Question 2:
#1Test whether the mean value of EGGS differs between spring and summer

t.test.result <- t.test(EGGS ~ SEASON, data = limpet)

t.test.result

#'*Justification for choosing the two-sample t-test*
#The t-test assumes that the data within each group follows a normal distribution. 
#Since the sample size is reasonably large, and under the assumption that the data follows a 
#normal distribution, the t-test is appropriate.

#The t-test assumes that the samples from the two groups are independent of each other. As long as 
#the observations within each group are independent, the t-test can be applied.

#If the assumption of normality or homogeneity of variances is violated, alternative 
#non-parametric tests such as the Wilcoxon rank-sum test (Mann-Whitney U test) can be considered.


##Question 3:

# 1.Chi-square test for the original dataset

obsrvd <- matrix(c(10, 14, 5, 29, 27, 15), nrow = 2, byrow = TRUE,
                   dimnames = list(c("Species 1", "Species 2"),
                                   c("Habitat A", "Habitat B", "Habitat C")))
obsrvd

#Chi-square test & results
chi.square.rslt <- chisq.test(obsrvd)

chi.square.rslt


#'*Interpretation of results*
#The chi-square test evaluates whether there is a significant association between species and habitat.
#The p-value obtained from the chi-square test is compared to the significance level (e.g., 0.05).
#If the p-value is less than the significance level, we reject the null hypothesis, indicating that there is a significant association.
#If the p-value is greater than the significance level, we fail to reject the null hypothesis, indicating no significant association.

#2. Chi-square test for the new dataset with higher total sample size

#Assuming 12 times higher total sample size with the same proportions
new_obsrvd <- obsrvd * 12

#Chi-square test for the new dataset & resluts
new.chi_square.rslt <- chisq.test(new_obsrvd)

new.chi_square.rslt


#'*Interpretation of results*
#With a higher total sample size but the same proportions, the chi-square test 
#result might show a significant association

#because of the increased power due to the larger sample size. However, the proportions
#remain the same, so the actual association remains unchanged.

#The p-value might be lower due to the larger sample size, but the interpretation 
#remains the same as in the original analysis.


#3.Analysis of sex ratios between 2 habitats
# Original data for sex ratios
obs.sex.ratios <- matrix(c(84 * (1/3), 84 * (2/3), 105 * (3/5), 105 * (2/5)),
                         nrow = 2, byrow = TRUE,
                         dimnames = list(c("Habitat 1", "Habitat 2"),
                                         c("Male", "Female")))

#Chi-square test for sex ratios between habitats
sex.ratio.chi_square <- chisq.test(obs.sex.ratios)

sex.ratio.chi_square

#'*Interpretation of results*
#The chi-square test evaluates whether there is a significant difference in sex 
#ratios between habitats.

#The p-value obtained from the chi-square test is compared to the significance 
#level (e.g., 0.05).
#If the p-value is less than the significance level, we reject the null hypothesis,
#indicating a significant difference in sex ratios between habitats.

# If the p-value is greater than the significance level, we fail to reject the null
#hypothesis, indicating no significant difference in sex ratios between habitats.


## Question 4:
#1. Read in the data
mDat3 <- read_xlsx("Data/Dingani/mDat.xlsx")


par(mfrow = c(2, 2))  #Set up the plotting window # 2 rows, 2 columns

#Plot 1: Distribution of "gestation" #Plot 2: Distribution of "a_weight" #Plot 3: Scatterplot of "gestation" vs "a_weight"
hist(mDat3$gestation, main = "Distribution of Gestation", xlab = "Gestation")
hist(mDat3$a_weight, main = "Distribution of Adult Weight", xlab = "Adult Weight")
plot(log(mDat3$gestation) ~ log(mDat3$a_weight), data = mDat3, 
     main = "Scatterplot of Gestation vs Adult Weight",
     xlab = "Log Adult Weight", ylab = "Log Gestation")

#Linear regression to test the relationship between log(gestation) and log(a_weight)
model <- lm(log(mDat3$gestation) ~ log(mDat3$a_weight), data = mDat3)

#Scatterplot with regression line
plot(log(mDat3$gestation) ~ log(mDat3$a_weight), data = mDat3, 
     main = "Linear Regression of Gestation on Adult Weight",
     xlab = "Log Adult Weight", ylab = "Log Gestation")
abline(model, col = "red")  # Add regression line

#Adding legend for the regression line
legend("topright", legend = "Regression Line", col = "red", lwd = 2)


#3. Linear regression to test the relationship between log(gestation) and log(a_weight)
model <- lm(log(gestation) ~ log(a_weight), data = mDat3)

# 4. Graph illustrating the results of linear regression
#Scatterplot with regression line
plot(log(gestation) ~ log(a_weight), data = mDat3, 
     main = "Linear Regression of Gestation on Adult Weight",
     xlab = "Log Adult Weight", ylab = "Log Gestation")
abline(model, col = "red")  # Add regression line

#Adding legend for the regression line
legend("topright", legend = "Regression Line", col = "red", lwd = 2)


#regression summary
summary(model)


## Question 5:
# Load the dataset
mDat3

# Fit a linear regression model
model <- lm(log(gestation) ~ log(a_weight), data = mDat3)

# Extract residuals from the linear regression model
residuals <- resid(model)

# Plot residuals as a histogram
hist(residuals, main = "Histogram of Residuals", xlab = "Residuals")

#Explanation on obs
#The residuals represent the differences between the observed values and the values
#predicted by the linear regression model.

#Ideally, the residuals should follow a normal distribution with a mean of zero, 
#indicating that the model captures the variability in the data well.

#Any deviation from normality may indicate that the model assumptions are violated
#or that there are unaccounted patterns in the data.

#In this case, if the residuals deviate significantly from normality, it might suggest
#that the linear regression model is not the best fit for the data.

#Additionally, outliers or influential observations in the original data
#can affect the distribution of residuals.



# Generate fake data for correlation test
set.seed(123)  # Set seed for reproducibility
dat.1 <- rnorm(30, mean = 0, sd = 1)  # Variable 1 with mean 0 and variance 1
dat.2 <- rnorm(30, mean = 0, sd = sqrt(2))  # Variable 2 with mean 0 and variance sqrt(2)

# Plot one variable against the other
plot(dat.1, dat.2, main = "Scatterplot of Variable 1 vs Variable 2",
     xlab = "Variable 1", ylab = "Variable 2")

# Test for correlation
correlation <- cor(dat.1, dat.2)

# Printing the correlation coefficient
correlation

#Explanation on obs
# The scatterplot visually displays the relationship between the two variables.
# The correlation coefficient measures the strength and direction of the linear
#relationship between the variables.

# If the correlation coefficient is close to 1 or -1, it indicates a strong 
#positive or negative linear relationship, respectively.

# If the correlation coefficient is close to 0, it suggests no linear 
#relationship between the variables.

# In this case, since the two variables have the same mean but different 
#variances, the correlation might not be significant.

# Even if there is a correlation, it might be weak due to the differences
#in variability between the two variables.


