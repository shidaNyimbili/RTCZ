#source("scripts/r prep2.r")

# rm(list =ls())
# graphics.off()

library(dplyr)
library(tidyr)
library(ggplot2)


#inspect the data
help("mpg")

df <- mpg

df 

view(df)

#Checking data type and number of rowsColumns
str(df)

nrow(df); ncol(df)
names(df)
glimpse(df)

###*Manipulate the variables
#Select() - columns selection

##Extract: manufacturer, model year

df1 <- select(df, manufacturer, model, year)
df1

df.car.info <- select(df, manufacturer, model, year)

#Columns that begin with letter: "m"
select(df, starts_with(match = "m"))

##columns that contain with letter: "r"
select(df, contains("r"))
select(df, contains("a"))

##columns that end with letters
select(df, ends_with("y"))

##select columns by column index or position
select(df, 1:5)
select(df,1)
select(df, c(1, 4, 6)) #select multiple columns in no chronological order

df

##Rename columns
df1 <- rename(df,
              shida = manufacturer,
              zevy = year)

select(df,
       shida = manufacturer,
       zevy = year,
       everything())

df

colnames(df1)
colnames(df)

##Mutate / Transmute
#Creating new variables
#Average calculations

df <- mutate(df, 
             'avg miles per gallon' = (cty + hwy/2))

View(df)
## car, cyl/ trans

df <- mutate(df,
             car = paste(manufacturer, model, sep= " "))
