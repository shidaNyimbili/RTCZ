source("scripts/r prep2.r")
tes_data1 <- st_read("Data/RTC/GIS/Tree_Equity_Scores_Tucson/Tucson_Tree_Equity_Scores.shp")

head(tes_data1)

# Visualize tree equity as histogram
tes_data <- tes_data1  %>%
na.omit()

#tes_data <- drop_na(tes_data1)


names(tes_data)

tes_data$TreeEquity <- as.numeric(tes_data$TreeEquity)

hist(tes_data$TreeEquity, main = "Distribution of Tree Equity Scores", xlab = "TreeEquity", ylab = "Frequency")

tes_data$TreeEquity

# Visualize tree equity across neighborhoods
ggplot(tes_data) +
  geom_sf(aes(fill = TreeEquity), color = "black", lwd = 0.15) +
  scale_fill_gradient(name = "Tree Equity Score",
                      low = "white",
                      high = "darkgreen") +
  ggtitle("Tree Equity Scores of Tucson Neighborhoods") +
  labs(caption = "Data source: City of Tucson") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "right")

# Create a neighbor list based on queen contiguity
list_nb <- poly2nb(tes_data, queen = TRUE)

# Check for empty neighbor sets
# card() calculates number of neighbors for each polygon in the list
# which() finds polygons with 0 neighbors
empty_nb <- which(card(list_nb) == 0)
empty_nb  

# Remove polygons with empty neighbor sets from the data
tes_subset <- tes_data[-empty_nb, ]
