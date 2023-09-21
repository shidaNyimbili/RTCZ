source("scripts/r prep2.r")
tes_data1 <- st_read("Data/RTC/GIS/Tree_Equity_Scores_Tucson/Tucson_Tree_Equity_Scores.shp")

head(tes_data1)

# Visualize tree equity as histogram
# tes_data <- tes_data1  %>%
# na.omit()

tes_data <- drop_na(tes_data1)


head(tes_data)

tes_data$treEqty <- as.numeric(tes_data$treEqty)

hist(tes_data$treEqty, main = "Distribution of Tree Equity Scores", xlab = "Tree Equity Score", ylab = "Frequency")
