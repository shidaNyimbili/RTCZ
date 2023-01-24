##Load packages

source("scripts/r prep2.r")

# Data
df <- economics[economics$date > as.Date("2000-01-01"), ]

# New column with the corresponding year for each date
df$year <- year(df$date)

ggplot(df, aes(x = date, y = unemploy)) +
  geom_line() +
  facet_wrap(~year, scales = "free")

##number 2

# install.packages("ggplot2")
# install.packages("ggpmisc")
# library(ggplot2)
# library(ggpmisc)

# Data
df <- economics[economics$date > as.Date("2000-01-01"), ]

ggplot(df, aes(x = date, y = unemploy)) +
  geom_line() +
  stat_valleys(geom = "point", span = 11, color = "red", size = 2) +
  stat_valleys(geom = "label", span = 11, color = "red", angle = 0,
               hjust = -0.1, x.label.fmt = "%Y-%m-%d") +
  stat_valleys(geom = "rug", span = 11, color = "red", sides = "b") 




