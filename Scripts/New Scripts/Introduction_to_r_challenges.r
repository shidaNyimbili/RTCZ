
# INTRODUCTION ------------------------------------------------------------


# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

## Under Files tab -> click on New Project -> 
## New Directory -> New Project ->
## Type "my_project" as directory name -> Create Project

## Under Files tab -> click on New Folder -> create new folder called "data"
# Alternatively, you can type dir.create("data")
# Use this folder to store raw data
# Always keep your raw data raw!
# Separate processed data from raw data
# Create another directory for data_output, fig_output and scripts

## Create new R script in your working directory -> click on symbol -> R Script -> my_script.R
# Move the script to the scripts directory

## Your working directory should look like:

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# CREATING OBJECTS --------------------------------------------------------

## Get output from R by typing math in console
3+5
12/7

## Assign values to objects
# Give it a name
# Assignment operator <- (Alt + "-")
# Value
weight_kg <- 55 
# assigns value on right to object on left, i.e. 55 goes into weight_kg
# no output is printed in console -> stored in memory (Environment)

# To print the value, type the name of the object:
weight_kg

# R is case-sensitive, i.e. x is different from X
# don't use names of functions, such as c, mean, etc.
# avoid dots -> many functions in R with dots in their names (special meaning)
# names can't start with numbers
# use a consistent style

# Convert weight from kg to pounds
2.2*weight_kg

# Change a variable's value
weight_kg <- 57.5
2.2*weight_kg

# Assigning a value to one variable does not change values of other variables
# Let's store the animal's weight in pounds in a new variable
weight_lb <- 2.2*weight_kg
2.2*weight_kg -> weight_lb # alternative

# Now change weight_kg to 100
weight_kg <- 100

# What will the value of weight_lb be? 126.5 or 220?
weight_lb


## Comments (Ctrl + Shift + c)
# Anything to the right of # symbol will be ignored by R
# Useful to make notes/explanations in your scripts


# CHALLENGE 1 -------------------------------------------------------------

# 1.1. Run the following code and indicate what the values 
# are after each statement:

mass <- 47.5            
# mass = 

age  <- 122
# age = 

mass_index <- mass/age
# mass_index = 

mass <- mass * 2.0
# mass = 

mass_index
# mass_index =

# Question: is the mass_index correct?

# . -----------------------------------------------------------------------

# . -----------------------------------------------------------------------
# . PRESENTATION
# . -----------------------------------------------------------------------

# FUNCTIONS AND THEIR ARGUMENTS -------------------------------------------

a <- 9 # assign value of 9 to the object a
b <- sqrt(a) 

# value of a is given to sqrt() function
# function calculates square root and returns the value
# which is then assigned to the variable b

b

# return value doesn't need to be numerical or a single item
# it can be a set of things, or even a dataset

# Each function's arguments are different
# If arguments are left out, default values are used, called "options"
# Options alter the way a function operates, e.g. ignore "bad values"


# Let's try a function that can take multiple arguments
round(3.14159)

# we called the round function with only one argument and it returned the value 3
# it was rounded to the nearest whole number
# if you want a different number of digits, look at the arguments or look at the help
args(round)
?round
# specify the number of digits you want
round(3.14159, digits = 2)
# if you provide arguments in the exact same order as they are defined, you don't have
# to name them
round(3.14159, 2)
# if you provide arguments in a different order than they are defined, you have to name them
round(2, 3.14159) # wrong
round(digits = 2, x = 3.14159) # correct


# VECTORS AND DATA TYPES --------------------------------------------------

# Vector = most common and basic data type in R
# Contains series of values (numbers or characters)
# Use the concatenate function to assign series of values
ages <- c(50, 60, 65, 82)  # create a vector of ages
ages

# A vector can also contain characters
animals <- c("mouse", "rat", "dog") # quotes are essential
animals

# Inspect the content of a vector
length(ages) # tells you how many elements are in a particular vector
length(animals)

# All the elements are the same type of data
class(ages)
class(animals)

# To get an overview of the structure of an object and its elements
str(ages)
str(animals)

# Use the c() function to add elements to a vector
ages
ages <- c(ages, 90) # add to the end of the vector
ages <- c(30, ages) # add to the beginning of the vector
ages <- c(ages[1:3], 63, ages[4:6]) # add to the middle of the vector
ages <- append(ages, 70, after = 5) # add to the middle of the vector


# CHALLENGE 2 -------------------------------------------------------------

# 2.1. What will happen in each of the following examples
# (hint: use class() to check data type or look at the environment)

num_char <- c(1, 2, 3, "a")


num_logical <- c(1, 2, 3, TRUE)


char_logical <- c("a", "b", "c", TRUE)


tricky <- c(1, 2, 3, "4")


# . -----------------------------------------------------------------------

# SUBSETTING VECTORS ------------------------------------------------------

# Extract one or several values
food <- c("meat", "eggs", "bread", "cheese")
food[2]
food[c(3, 2)]
# R indices start at 1
# Other languages count from 0

# Repeat indices to create an object with more elements
more_food <- food[c(1,2,3,2,1,4)]
more_food

## Conditional subsetting
# Use a logical vector to select the element with the same index
temp <- c(9, 15, 17, 21, 34)
temp[c(TRUE, FALSE, TRUE, TRUE, FALSE)]

# Get logicals with TRUE for indices that meet a specific condition
temp > 20

# So we can use this to select values above 20:
temp[temp > 20]

# Can combine multiple tests using & (both conditions true)
temp[temp >= 20 & temp <= 30]

# or | (at least one condition is true)
temp[temp < 20 | temp > 30]

# Search for the vector in certain strings:
food
food[food == "cheese" | food == "eggs"]
food %in% c("eggs", "cheese", "bread", "tomato", "pasta")
food[food %in% c("eggs", "cheese", "bread", "tomato", "pasta")]


# CHALLENGE 3 -------------------------------------------------------------

# Can you figure out why "three" > "four" and "four" > "five" returns TRUE
# when you run the following code?

"three" > "four"
"four" > "five"


# . -----------------------------------------------------------------------

# Vectors with other data types:
  # logical = TRUE or FALSE
  # integer = 2L
  # complex = 1 + 4i (real and imaginary parts)

# Vectors are one of many data structures in R
# Other data structures:
  # lists
  # matrices
  # data frames
  # factors
  # arrays

# . -----------------------------------------------------------------------
# . PRESENTATION
# . -----------------------------------------------------------------------

# MISSING DATA ------------------------------------------------------------

# Missing data are represented in vectors as NA
# Most functions will return NA if your data contains missing values

# To ignore missing values when doing calculations, use na.rm = TRUE
heights <- c(2, 4, 4, NA, 6)
heights
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)

# Extract those elements which are NOT missing values
heights[!is.na(heights)]

# Remove incomplete cases
na.omit(heights)
# First line of output = all cases that are not NA
# Second line of output = positions of deleted values
# Third line of output = class of deleted values

# Extract those elements which are complete cases
heights[complete.cases(heights)]



# CHALLENGE 4 -------------------------------------------------------------

# 4.1. Run the following line of code to create a vector ("heights" in inches):

heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)

# 4.2. Create a new vector (called "heights_no_na") with NAs removed:




# 4.3. Calculate the median (using the median() function) of the new "heights_no_na" vector.




# 4.4. How many people in the set are taller than 67 inches?
# Hint: Use conditional subsetting and the length() function



# . -----------------------------------------------------------------------


# LOADING AND INSPECTING DATA ---------------------------------------------

# (1) Load the data via command line
survey <- read.csv("data/survey_data.csv") # OR

# (2) Load the data via command line
survey <- read.csv(file.choose()) #OR

# (3) Load the data using the interface
# In Environment window -> Import Dataset -> Browse for the file -> 
# Change the name to "survey" and select "Yes" for headers before importing # OR

# (4) Load the data using the interface
# In Files window -> browse for file -> click on file ->
# Import Dataset -> same options as (3)

# No output, because assignments don't display anything

# . -----------------------------------------------------------------------
# . PRESENTATION
# . -----------------------------------------------------------------------

# Let's check that our data has been loaded
survey

# Let's check the top 6 lines of this data frame
head(survey)
head(survey, n = 10)
View(survey) # uppercase V

### WHAT ARE DATA FRAMES? ###
## It's a data structure for most tabular data, i.e. it's a table
## Data is represented in the format of a table where columns = vectors 
## (all have the same length and each vector contain the same type of data)

## Look at the size of the data
dim(survey) 
# dimensions: no. of rows; no. of columns

nrow(survey) 
# no. of rows

ncol(survey) 
# no. of clumns

## Look at the content
head(survey)
# first 6 rows

tail(survey)
# last 6 rows

## Look at the names
names(survey)
# column names

rownames(survey)
# row names

## Look at summary of data
str(survey) 
# structure of the object and information about the class, length and content of each column

summary(survey)
# summary statistics for each column


# CHALLENGE 5 -------------------------------------------------------------


# Based on output of "str(surveys)", answer the following:
str(survey)

# 5.1. What is the data structure of the object surveys?  


# 5.2. How many rows and columns are in this object?  


# . -----------------------------------------------------------------------


# INDEXING AND SUBSETTING DATA FRAMES -------------------------------------

survey[1, 1]  # 1st element in 1st column (as a vector)
survey[1, 6]  # 1st element in 6th column (as a vector)
survey[, 1]  # 1st column (as a vector)
survey[1]  # 1st column (as a data.frame)
survey[1:3, 8]  # 1st 3 elements in 7th column (as a vector)
survey[3, ]  # 3rd element for all columns (as a data.frame)
head_survey <- survey[1:6, ]  # same as "head(survey)"
head_survey


# Exclude certain parts of a data frame
survey[, -1]  # the whole data frame except 1st column
survey[-(7:141687), ]  # same as "head(survey)"

# Subset columns by names
survey["country"]  # data.frame
survey[, "country"]   # vector  
survey[["country"]]   # vector  
survey$country    # vector


# CHALLENGE 6 -------------------------------------------------------------

# 6.1. Create a data frame ("survey_200") containing only the
#    200th observation of the survey dataset.


# 6.2. Notice how "nrow(survey)" gave you the number of rows in a data frame?
#    6.2.1. Use that number to pull out just that last row in the data frame (survey).


#    6.2.2. Compare that with what you see as the last row using "tail()" 
#         to make sure it's meeting expectations.


# 6.3. Use "nrow()" to extract the row that is in the middle of the data frame.
#    Store the content of this row in an object named "survey_middle".


# 6.4. Combine "nrow()" with the "-" notation above to reproduce the behavior of
#   "head(surveys)" keeping just the first through 6th rows of the surveys dataset.


# . -----------------------------------------------------------------------

# FACTORS -----------------------------------------------------------------

## When we did str(survey), we saw several columns consisting of integers
## However, some of the other columns are of a special class called factors
## Factors are used to represent categorical data
## Factors can be ordered or unordered
## Factors are stored as integers and have labels (text) associated with these unique integers
## While factors look like charactor vectors, they are actually integers
## Factors contain a pre-defined set of values, known as levels (by default sorted alphabetically)

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# Let's create a factor with 3 levels
shirt_sizes <- factor(c("M", "S", "S", "M", "L", "M"))  # c = concatenate
# R will assign 1 to the level 'L', 2 to 'M', and 3 to 'S'

# Check this level assignment
levels(shirt_sizes)  # check the levels, i.e. L, M, S

# Check number of levels
nlevels(shirt_sizes)  # check the number of levels, i.e. 3
shirt_sizes  # [1] M S S M L M - before ordering - levels: L M S

# Sometimes the order of the factors does not matter, 
# other times you might want to specify the order (e.g. low, medium, high)
# Let's reorder the levels
shirt_sizes <- factor(shirt_sizes, levels = c("S", "M", "L"))
shirt_sizes  # [1] M S S M L M - after ordering - levels: S M L
# In R's memory these factors are represented by integers (1,2,3)

## Convert a factor to a character vector
as.character(shirt_sizes)  

## Renaming factors

# When your data is stored as a factor, you can use the plot() function to get a quick glance at 
# no. of observations represented by each factor level
plot(survey$gender)  # bar plot of number of females and males
# In addition to males and females, there are individuals whose gender information hasn't been recorded
# There is also no label to indicate that the information is missing
# Let's rename this label by first pulling out the data on gender 
gender_data <- survey$gender
head(gender_data)  # view first few lines
levels(gender_data)  # view levels (the empty " " represents missing data)
levels(gender_data)[1] <- "undetermined"  # use indexing and replace " " with "undetermined"
levels(gender_data)
head(gender_data)
plot(gender_data)


# CHALLENGE 7 -------------------------------------------------------------

# 7.1. Rename "F" and "M" to "female" and "male", respectively



# 7.2. Check that the levels have been renamed


# 7.3. Recreate the bar plot such that "undetermined" is last (after "male")


# . -----------------------------------------------------------------------


# STRINGS AS FACTORS ------------------------------------------------------

# By default, characters (i.e. text) is converted/coerced into factors
# In order to keep these columns as characters, set "stringsAsFactors" to FALSE
# Let's first look at the structure when we set "stringsAsFactors" to TRUE
survey <- read.csv("data/survey_data.csv",  stringsAsFactors = TRUE)
str(survey)
survey <- read.csv("data/survey_data.csv",  stringsAsFactors = FALSE)
str(survey)

# We can convert the "gender" column into a factor if needed
survey$gender <- factor(survey$gender)
str(survey)

# Creating a data frame
# Instead of creating a data frame with read.csv(), you can create your own using data.frame()

my_data <- data.frame(name = c("Bianca", "Oliver", "Anthony"), 
                      age = c(28, 30, 35))

my_data

# CHALLENGE 8 -------------------------------------------------------------

# 8.1. The code in this question has a few mistakes. Identify the mistakes.


animal_data <- data.frame(animal=c(dog, cat, sea cucumber, sea urchin),
                          feel=c("furry", "spiny", "smooth"),
                          weight=c(45, 8 1.1, 0.8))

# Try to fix the code by adding/removing elements:



# 8.2. Can you predict the class for each of the columns in the following example?
# Check your guesses using `str(country_climate)`:

country_climate <- data.frame(country = c("Canada", "Panama", "South Africa", "Australia"),
                              climate = c("cold", "hot", "temperate", "hot/temperate"),
                              temperature = c(10, 30, 18, "15"),
                              northern_hemisphere = c(TRUE, TRUE, FALSE, "FALSE"),
                              has_kangaroo = c(FALSE, FALSE, FALSE, 1))

str(country_climate)

#      8.2.1. Are they what you expected?


#      8.2.2. What would have been different if we had added `stringsAsFactors = FALSE`
#        to this call?



#     8.2.3. How can the code be improved?



# . -----------------------------------------------------------------------

# FORMATTING DATES --------------------------------------------------------

# One common issue: converting date and time information 
# into a variable that is appropriate and usable during analyses

# Store each component of your date separately, like the 'survey' dataset
str(survey)

## Install and load the tidyverse package

# Install package via command line
install.packages("tidyverse") # only install a package ONCE

# Install package via interface
# Package -> Install -> Type name of package(s) -> Install 

# Load the tidyverse and lubridate packages

# Load the package via command line
library(tidyverse)  # load the package every time you start a new R session
# If it gives an error that it requires another package, just install and load that specific package
library(lubridate) # part of tidyverse package

# Load the package via interface
# Check the box next to the name of the installed package in the package manager window

# Create a date object and inspect the structure
my_date <- ymd("2015-01-01")
str(my_date)
# The ymd() function takes a vector representing year, month and day
# and converts it to a Date vector that is recognized by R

# Paste the year, month and day separately - get the same result
my_date <- ymd(paste("2015", "1", "1", sep = "-"))
# sep indicates the character to use to separate each component
str(my_date)

# Let's apply the paste function to the survey dataset
# Create character vector from year, month and day columns
paste(survey$year, survey$month, survey$day, sep = "-")

# Create a date vector using the ymd() function
ymd(paste(survey$year, survey$month, survey$day, sep = "-"))
# We notice that some dates failed to parse - we'll investigate them shortly
# Note: there are also a dmy, mdy, ydm, etc. functions - depending on order of your dates

# Now add this date vector as new date column in surveys
survey$date <- ymd(paste(survey$year, survey$month, survey$day, sep = "-"))
str(survey) # notice the new column, with 'Date' as the class

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# Inspect the new column
summary(survey$date)
# Something went wrong! Some dates are missing

# Let's investigate where they are coming from
# Identify the rows in our data frame that are failing
# Extract the columns year, month and day
missing_dates <- survey[is.na(survey$date), c("year", "month", "day")]
View(missing_dates)

# Why did these dates fail to parse?
# April (month 4) and September (month 9) only has 30 days, not 31

# Let's fix this:
survey$day[survey$month == 4 & survey$day == 31] <- 30
survey$day[survey$month == 9 & survey$day == 31] <- 30

# Remember that columns don't automatically update like Excel, so redo date column
survey$date <- ymd(paste(survey$year, survey$month, survey$day, sep = "-"))

# Let's make sure there are no missing dates anymore
summary(survey$date)


# DATA MANIPULATION USING dplyr AND tidyr ---------------------------------

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

## Load the data using read_csv() function from tidyverse
# Don't need to set stringsAsFactors to FALSE
# thus preventing character data to be converted to factor data
survey <- read_csv("data/survey_data.csv")
str(survey)
# tbl_df (tibble) - similar to data frame
# It only prints the first few rows of data
# and only as many columns as fit on one screen
# Character data is not automatically converted to factors

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

## Selecting columns and filtering rows

# Select specific columns
select(survey, gender, weight, age)

# To select all columns EXCEPT certain ones, use "-"
select(survey, -group, -eye_color)

# Choose rows based on specific criteria
filter(survey, weight < 60)

# What if you want to select and filter at the same time?
# 1. use intermediate steps
survey2 <- filter(survey, weight < 60)
survey3 <- select(survey2, gender, weight, age)
# clutter up your workspace
# hard to keep track of multiple steps

# 2. use nested functions
survey4 <- select(filter(survey, weight < 60), gender, weight, age)
# difficult to read
# R evaluates the expression from the inside out (first filtering, then selecting)

# 3. use pipes - recommended way!

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# Pipes

survey %>%  # Shortcut = Ctrl + Shift + M
  filter(weight < 60) %>%
  select(gender, weight, age)

# Create a new object with the smaller version of the data
# Option 1
survey_small <- survey %>%
  filter(weight < 60) %>%
  select(gender, weight, age)

# Option 2
survey %>%
  filter(weight < 60) %>%
  select(gender, weight, age) -> survey_small

survey_small

# pipes let you take output of one function and use as input for the next function

# CHALLENGE 9 -------------------------------------------------------------

# Using pipes, subset the survey data to include individuals surveyed before
# 2005 and retain only columns "year", "gender", and "weight"




# . -----------------------------------------------------------------------

## Mutate

# Create new columns based on values in existing columns

survey %>%
  mutate(bmi = weight/height^2)
# We can't see the last column (bmi)

survey %>%
  mutate(bmi = weight/height^2) %>%
  select(weight, height, bmi)
# select only certain columns

# remove NAs by using filter()
survey %>%
  filter(!is.na(weight)) %>%
  mutate(bmi = weight/height^2) %>%
  select(weight, height, bmi)


# CHALLENGE 10 ------------------------------------------------------------

# Create a new data frame from the survey data with the following:
#       * New column called "height_half" containing values that are half the "height" values
#       * In the "height_half" column, there are no NAs and all values are less than 85
#       * Only keep the "gender" and "height_half" columns



# . -----------------------------------------------------------------------

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# SPLIT-APPLY-COMBINE ANALYSIS --------------------------------------------

# Split data into groups > apply some analysis to each group > combine results
# Do this using the group_by() function
# Summarize() function is often used together with group_by()
# It collapses each group into a single-row summary of that group

# Calculate the mean weight by sex
survey %>%
  group_by(gender) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
# dplyr changed data.frame to tbl_df and only prints first few rows

# You can also group by multiple columns
survey %>%
  group_by(gender, eye_color) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))

# First remove missing values (NA) for weight before calculating summary statistics
survey %>%
  filter(!is.na(weight)) %>%  
  group_by(gender, eye_color) %>% 
  summarize(mean_weight = mean(weight))

# If you want to display more data, use the print() function
survey %>%
  filter(!is.na(weight)) %>%
  group_by(gender, eye_color) %>%
  summarize(mean_weight = mean(weight)) %>%
  print(n = 15)

# Once data is grouped, you can summarize multiple variables simultaneously
# Example, calculate the mean and minimum weight for each eye color for each gender
survey %>%
  filter(!is.na(weight)) %>%
  group_by(gender, eye_color) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight))  

## Arrange()
# Sort data to put the groups with the smallest min_weight first
survey %>%
  filter(!is.na(weight)) %>%
  group_by(gender, eye_color) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(min_weight)

# You can also sort in descending order
survey %>%
  filter(!is.na(weight)) %>%
  group_by(gender, eye_color) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(desc(min_weight))

## Counting
# Count the number of observations for each factor or combination of factors
survey %>%
  count(gender)

# Count is shorthand for group_by and summarise
survey %>%
  group_by(gender) %>% 
  summarize(total = n())

# Count provides the sort argument for convenience
survey %>%
  count(gender, sort = TRUE)

# Count a combination of factors
survey %>%
  count(gender, eye_color) 

# To sort the table (with multiple factors), use the arrange() function
survey %>%
  count(gender, eye_color) %>%
  arrange(eye_color, desc(n))


# CHALLENGE 11 ------------------------------------------------------------

# 11.1. How many individuals were surveyed for each "sport"?


# 11.2. Use group_by() and summarize() to find the mean, min, and max 
#    height for each gender. Also add
#    the number of observations (hint: see ?n()).



# 11.3. For which sport was the heaviest weight measured in each year?


# . -----------------------------------------------------------------------


# RESHAPING WITH GATHER AND SPREAD ----------------------------------------

# Remember the 4 rules of defining tidy data:
# 1. Each variable has its own column
# 2. Each observation has its own row
# 3. Each value must have its own cell
# 4. Each type of observational unit forms a table

# What if instead of comparing records, 
# we wanted to compare the different mean weight 
# of each eye color between groups?

# This means the values of the eye color column would 
# become the names of column variables and the cells 
# would contain the values of the mean weight observed for each group.

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

### OLD WAY ###

# spread() takes three principal arguments:
# 1. the data
# 2. the key column variable whose values will become new column names.
# 3. the value column variable whose values will fill the new column variables.

# First filter observations and variables of interest,
# then create a new variable for the mean_weight

survey_gs <- survey %>%   # create new variable
  filter(!is.na(weight)) %>%   # remove missing weight
  group_by(group, sport) %>% 
  summarize(mean_weight = mean(weight))  # create mean_weight column

survey_gs

# Use spread() to key on eye color with values from mean_weight
survey_spread <- survey_gs %>%
  spread(key = sport, value = mean_weight)

survey_spread

### NEW WAY ###

survey_gs %>% 
  pivot_wider(names_from = sport,
              values_from = mean_weight)

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

### OLD WAY ###

# Gathering does the exact opposite
# We are gathering the column names and turning them 
# into a pair of new variables

# gather() takes four principal arguments:
# 1. the data
# 2. the key column variable we wish to create from column names.
# 3. the values column variable we wish to create and fill with values associated with the key.
# 4. the names of the columns we use to fill the key variable (or to drop).

survey_gather <- survey_spread %>%
  gather(key = sport, value = mean_weight, -group)
# recreate surveys_gs from survey_spread
# create a key called "sport"
# create a value called mean_weight
# don't gather values of the group column

survey_gather

# Can also gather specific columns by using the : operator
survey_spread %>% 
  gather(key = sport,
         value = mean_weight,
         archery:weightlifting) %>% 
  head()

### NEW WAY ###

survey_spread %>% 
  pivot_longer(archery:weightlifting,
               names_to = "sport",
               values_to = "mean_weight")

# CHALLENGE 12 ------------------------------------------------------------

# 12.1. Spread the survey data frame with `year` as columns, 
#    `group` as rows, and 
#    the values are the number of unique sport types per group. 
#    You will need to summarize before reshaping, and 
#    use the function `n_distinct` to get the number of unique sport types. 
#    It's a powerful function! See `?n_distinct` for more information.



# 12.2. Now take that data frame, and gather() it again, 
#    so each row is a unique `plot_id` by `year` combination



# 12.3. The `survey` data set contains two columns of measurement - 
#    `height` and `weight`.  
#    This makes it difficult to do things like look at the 
#    relationship between mean values of each measurement 
#    per year in different sport types. Let's walk through 
#    a common solution for this type of problem. 

#    First, use `gather` to create a dataset where 
#    we have a key column called `measurement` and a `value` 
#    column that takes on the value of either `height` 
#    or `weight`. Hint: You'll need to specify which columns 
#    are being gathered.



# 12.4. With this new dataset, calculate the average 
#    of each `measurement` in each `year` for each different 
#    `sport`. Then `spread` them into a data set with 
#    a column for `height` and `weight`. 
#    Hint: Remember, you only need to specify the key and value 
#    columns for `spread`.



# . -----------------------------------------------------------------------


# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# EXPORTING DATA ----------------------------------------------------------

## Subset the data and remove all missing data, i.e. clean your data

survey_clean <- survey %>%
  filter(!is.na(gender),  # remove missing (NA) genders
         !is.na(age),     # remove missing (NA) ages
         !is.na(weight),  # remove missing (NA) weights
         !is.na(height))  # remove missing (NA) heights


# We are interested in plotting sport participation over time
# Remove observations for "rare" sports (observations <8000)
sport_counts <- survey_clean %>%
  count(sport) %>% 
  filter(n >= 8000)

# Only keep the most commonly practised sports
survey_complete <- survey_clean %>%
  filter(survey_clean$sport %in% sport_counts$sport)
# use "dim(survey_complete)" to check that there are 123596 rows and 12 columns

## Save the survey_complete dataset as a CSV file in your data_output folder
write_csv(survey_complete, path = "data_output/survey_complete.csv")


# DATA VISUALIZATION WITH ggplot2 -----------------------------------------

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

## Plotting with ggplot2
library(tidyverse)

# Use the 'survey_complete' data set that we exported in the previous step
# If not still in the workspace, load the data
survey_complete <- read_csv("data_output/survey_complete.csv")


# Scatter plot ------------------------------------------------------------

# Bind the plot to a specific data frame
ggplot(data = survey_complete)  
# ggplot() creates a coordinate system that you can add layers to
# output: grey block
# If you get an error about "invalid graphics state", run "dev.off()" in the console

# define mapping (aesthetics (aes)), by selecting variables to be plotted
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height))  
# output: grey block + gridlines + axes

# add geoms_(points/lines/bars) graphical representation of data in plot
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height)) +
  geom_point()   # "+" must be at end of each line containing a layer
# The + sign is used to add new layers
# It must be placed at the end of the line containing the previous layer

## Assign the plot to a variable to create a plot template
survey_plot <- ggplot(data = survey_complete, 
                       mapping = aes(x = weight, y = height))  
# no output - just assigned to object

# Draw the plot
survey_plot + geom_point()

# This is the correct syntax for adding layers
survey_plot +     # "+" at the end of each line
  geom_point()

# This will not add the new layer
survey_plot
+ geom_point()    # "+" on the wrong line

# Scatter plots can be useful for small datasets
# It may show patterns, i.e. x is associated with y
# It may also display clusters, as you can see in this plot

# For large datasets, overplotting of points can be a limitation
# Handle this by using hexagonal binning of observations

install.packages("hexbin")
library(hexbin)

survey_plot +
  geom_hex()
# The plot space is tessellated (covered) into hexagons
# Each hexagon is colored according to number of observations

# Define dataset to use, lay the axes and choose a geom
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height)) +
  geom_point()

# Start modifying the plot to extract more information
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height)) +
  geom_point(alpha = 0.1)
# alpha adds transparency to avoid overplotting - lower alpha = more transparency

# Add color for all the points
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height)) +
  geom_point(alpha = 0.1, color = "blue")

# Add a different color to each gender in the plot
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height)) +
  geom_point(alpha = 0.1, aes(color = gender))

# We can also specify the colors directly inside the global mapping
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height, color = gender)) +
  geom_point(alpha = 0.5)

# Plot only a subset of the data
ggplot(data = filter(survey_complete, continent == "Africa"),
       mapping = aes(x = weight, y = height, color = gender)) +
  geom_point(alpha = 0.5) +
  geom_point(data = filter(survey_complete, country == "South Africa"),
             pch = 21, # change point shape (21 = filled circle)
             color="black",
             stroke = 1)

# Color specific data points with a different color
ggplot(data = filter(survey_complete, continent == "Africa"),
       mapping = aes(x = weight, y = height, color = gender)) +
  geom_point(alpha = 0.5) +
  geom_point(data = filter(survey_complete, country == "South Africa"),
             color = "black",
             alpha = 0.5)

# Color only the borders of specific data points with a different color
ggplot(data = filter(survey_complete, continent == "Africa"),
       mapping = aes(x = weight, y = height, color = gender)) +
  geom_point(alpha = 0.5) +
  geom_point(data = filter(survey_complete, country == "South Africa"),
             pch = 21, # change point shape (21 = filled circle)
             color="black",
             stroke = 1) # change thickness of border

# We can change the geom layer and colors can still be determined by gender
ggplot(data = survey_complete,
       mapping = aes(x = weight, y = height, color = gender)) +
  geom_hex(alpha = 0.5)

# Add size aesthetic (size only works for continuous variables)
ggplot(data = filter(survey_complete, country == "South Africa" & eye_color == "blue"),
       mapping = aes(x = weight, y = height, color = gender, size = age)) +
  geom_point(alpha = 0.5)

# CHALLENGE 13 ------------------------------------------------------------

# Create a scatter plot of weight over sport type
# with gender showing in different colors




# . -----------------------------------------------------------------------


# Boxplot -----------------------------------------------------------------

## Boxplot = visual shorthand for distribution of values

# Visualize distribution of weight within each sport type
ggplot(data = survey_complete,
       mapping = aes(x = sport, y = weight)) +
  geom_boxplot()

# box stretches from the 25th percentile of the distribution to the 75th percentile
# also known as IQR (interquartile range)
# line in middle of boxplot = median (50th percentile) of distribution
# distribution may be symmetric about the median, or skewed to one side
# whiskers go to further non-outlier points
# outliers = values > 1.5 * IQR (measured from edges of box)

# Add points to the boxplot - better idea of number of measurements and
# of their distribution
ggplot(data = survey_complete,
       mapping = aes(x = sport, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "tomato")
# Boxplot is behind the jitter

# Let's put the boxplot in front of the jitter
ggplot(data = survey_complete,
       mapping = aes(x = sport, y = weight)) +
  geom_jitter(alpha = 0.3, color = "tomato") +
  geom_boxplot(alpha = 0)


# CHALLENGE 14 ------------------------------------------------------------

# 14.1. Boxplots are useful summaries, but hide the *shape* of the distribution.
# Replace the boxplot with a violin plot or a dot plot to see the shape
# See geom_violin() and geom_dotplot()


# 14.2. Change the scale of the axis to better distribute observations; see scale_y_log10()


# 14.3. Create a boxplot for the distribution of height for each gender


# 14.4. Add colored datapoints to the previous plot according to the 
# group in which the individual was surveyed
# Use "alpha = 0.1" to add transparency to data points
# Hint: check class for "group" - change from integer to factor


# Check the class for "group"


# Change the class from integer to factor and plot data again


# 14.5. Why does this change how R makes the graph?



# . -----------------------------------------------------------------------


# Line graph --------------------------------------------------------------

## Plotting time series data

# Calculate number of counts per year for each sport
yearly_counts <- survey_complete %>%
  count(year, sport)

yearly_counts

# Visualize timelapse data as a line plot with year on x axis and counts on y axis
ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n)) +
  geom_line()
# This doesn't work, because we plot data for all sport types together

# Draw a line for each sport by modifying the aesthetic function
ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n, group = sport)) +
  geom_line()
# This is still not a good plot - all the lines are the same color

# Add colors to distinguish sport types in the plot
ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n, color = sport)) +
  geom_line()


## Faceting
# Split one plot into multiple plots based on a factor in the dataset

# Make one plot for a time series for each genus
ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(facets = vars(sport))

# Split the line in each plot by gender for each sport measured
yearly_gender_counts <- survey_complete %>%
  count(year, sport, gender)

yearly_gender_counts

# Make a faceted plot by splitting further by gender (within a single plot)
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(facets = vars(sport))

# CHALLENGE 15 ------------------------------------------------------------

# Create a plot that depicts how the average weight of individuals change
# through the years for group that was surveyed




# . -----------------------------------------------------------------------


## Facets

## Facet grid - specify how you want your plots arranged

# Compare how weights of males and females changed through time

# Organise panels by both rows and columns
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_grid(rows = vars(gender), cols = vars(sport))

# Organise the panels only by rows
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_grid(rows = vars(sport))

# Organise panels only by columns
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_grid(cols = vars(sport))
# Customization
# ggplot2 cheat sheet https://www.rstudio.com/wp-content/uploads/2015/08/ggplot2-cheatsheet.pdf


## ggplot2 themes

# Set the background to white and remove the grid to make plots more readable
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(facets = vars(sport)) +
  theme_bw() +
  theme(panel.grid = element_blank())

# Change names of axes and add a title
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw()

# Change the legend title (option 1)
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals",
       color = "Gender") +
  theme_bw()

# Change the legend title (option 2) and legend values
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals") +
  scale_color_manual(name = "Gender",
                    values = c("orange", "blue"),
                    labels = c("Female", "Male"))
  theme_bw()

# Improve readability of axes names by changing size and font
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(text = element_text(size = 16)) +
  scale_x_discrete()


# Change orientation of labels and adjust them to not overlap (use an angle)
ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(colour = "grey20", size = 12),
        text = element_text(size = 16))

# Save the theme changes as an object to apply them to other plots in the future
grey_theme <- theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
                    axis.text.y = element_text(colour = "grey20", size = 12),
                    text = element_text(size = 16))

ggplot(data = yearly_gender_counts,
       mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  grey_theme


# Bar graph ---------------------------------------------------------------

# Let's plot the average weight for individuals (both genders) for each sport type
# Firstly, calculate the mean weight for individuals (both genders) for each sport type
sport_weight_gender <- survey_complete %>% 
  group_by(sport, gender) %>% 
  summarise(mean_weight = mean(weight))

# Secondly, calculate the standard deviation
stdev <- sd(sport_weight_gender$mean_weight)

# Make a stacked bar plot with normalised values
ggplot(data = sport_weight_gender,
       mapping = aes(x = sport, fill = gender)) +
  geom_bar(position = "fill") +
  labs(x = NULL,
       y = "Average weight (kg)")

# Make a stacked bar plot without normalising values
ggplot(data = sport_weight_gender,
       mapping = aes(x = sport, y = mean_weight, fill = gender)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(x = NULL,
       y = "Average weight (kg)")

# Arrange elements side-by-side
ggplot(data = sport_weight_gender,
       mapping = aes(x = sport, y = mean_weight, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = NULL,
       y = "Average weight (kg)")

# Add error bars
ggplot(data = sport_weight_gender,
       mapping = aes(x = sport, y = mean_weight, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = mean_weight, ymax = mean_weight + stdev),
                width = 0.2,
                position = position_dodge(0.9)) +
  labs(x = NULL,
       y = "Average weight (kg)")

# Rotate the bar plot
ggplot(data = sport_weight_gender,
       mapping = aes(x = sport, y = mean_weight, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = mean_weight, ymax = mean_weight + stdev),
                width = 0.2,
                position = position_dodge(0.9)) +
  labs(x = NULL,
       y = "Average weight (kg)") +
  coord_flip()


# CHALLENGE 16 ------------------------------------------------------------

# Try to improve one of the plots generated in
# this exercise or make one of your own

# Some ideas:
  # Change the thickness of the lines
  # Change the name of the legend and the labels
  # Try using a different color palette (http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/)


# . -----------------------------------------------------------------------

# Maps --------------------------------------------------------------------

# Basic elements of a map that should be considered are:
  # Polygons: closed shapes such as country borders
  # Lines: linear shapes that are not filled with any aspect, such as highways, streams, or roads
  # Points: specify specific positions, such as city or landmark locations

my_packages <- c("cowplot", "googleway", "ggplot2", "ggrepel", "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata")

install.packages(my_packages)

install.packages("pacman")
install.packages("libwgeom")
library(pacman)

install.packages("libwgeom", lib = "C:/R/R-4.1.3/library")

source("scripts/r prep2.r")

pacman::p_load(cowplot, googleway, ggplot2, ggrepel, ggspatial, libwgeom, sf, rnaturalearth, rnaturalearthdata) 


#The package rnaturalearth provides a map of countries of the entire world. 
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

ggplot(data = world) +
  geom_sf()

# Interactive plots -------------------------------------------------------

library(plotly)

ggplot(data = filter(survey_complete, country == "South Africa" & eye_color == "blue"),
       mapping = aes(x = weight, y = height, color = gender, size = age)) +
  geom_point(alpha = 0.5) +
  theme(legend.position = "bottom") -> my_plot


ggplotly(my_plot)


# Arranging plots ---------------------------------------------------------

# Combine separate ggplots into a single figure
install.packages("gridExtra")
library(gridExtra)

sport_weight_boxplot <- ggplot(data = survey_complete,
                               mapping = aes(x = sport, y = weight)) +
  geom_boxplot() +
  scale_y_log10() +
  labs(x = "Genus",
       y = "Weight (g)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


sport_count_plot <- ggplot(data = yearly_counts,
                           mapping = aes(x = year, y = n, color = sport)) +
  geom_line() + 
  labs(x = "Year", y = "Frequency")

grid.arrange(sport_weight_boxplot, sport_count_plot, ncol = 2, widths = c(4, 6))

# Tools to construct more complex layouts:
# https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html

### Export the plot
# Export tab in the Plot pane in RStudio will save your plots at low resolution
# Instead, use ggsave()
my_plot <- ggplot(data = yearly_gender_counts, 
                  mapping = aes(x = year, y = n, color = gender)) +
  geom_line() +
  facet_wrap(vars(sport)) +
  labs(title = "Sport participation through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(colour = "grey20", size = 12),
        text=element_text(size = 16))

ggsave("fig_output/yearly_gender_counts.png", my_plot, width=15, height=10)

# It also works for grid.arrange() plots:
combo_plot <- grid.arrange(sport_weight_boxplot, sport_count_plot, ncol = 2, widths = c(4, 6))

ggsave("fig_output/combo_plot_freq_weight.png", combo_plot, width = 10, dpi = 300)



# Additional Resources ----------------------------------------------------

# R for Data Science Book: https://r4ds.had.co.nz/index.html

# For many more types of plots (with their code), see the following resources:
# R Graph Gallery: https://www.r-graph-gallery.com/
# Blog: http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html
# R Graphics Cookbook: http://users.metu.edu.tr/ozancan/R%20Graphics%20Cookbook.pdf

# RStudio cheatsheets: https://rstudio.com/resources/cheatsheets/

# See the following blog for shapes, sizes and colors:
# https://www.datanovia.com/en/blog/ggplot-point-shapes-best-tips/

# Complete list of themes is available at
# https://ggplot2.tidyverse.org/reference/ggtheme.html

# Journal themes
# Package ggthemes allows you to choose specific journal styles
# https://jrnold.github.io/ggthemes/reference/index.html

# ggplot2 extensions website
# https://www.ggplot2-exts.org/

# . -----------------------------------------------------------------------
# . PRESENTATION . #
# . -----------------------------------------------------------------------

# THE END -----------------------------------------------------------------


