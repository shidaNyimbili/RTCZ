source("scripts/r prep2.r")
tes_data1 <- st_read("Data/RTC/GIS/Tree_Equity_Scores_Tucson/Tucson_Tree_Equity_Scores.shp")

head(tes_data1)

# Write the extracted data frame to an Excel file
#write.xlsx(tes_data1, "Data/reserach/subset_mdat.xlsx", rowNames = FALSE)

# Visualize tree equity as histogram
tes_data <- tes_data1  %>%
na.omit()

#tes_data <- drop_na(tes_data1)

names(tes_data)

tes_data$TreeEquity <- as.numeric(tes_data$TreeEquity)

hist(tes_data$TreeEquity, main = "Distribution of Tree Equity Scores", xlab = "TreeEquity", ylab = "Frequency")

tes_data$TreeEquity

tes_data

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


# Subset 'tes_data' to extract polygons with empty neighbor sets
empty_polygons <- tes_data[empty_nb, ]
empty_polygons$nghbrhd  # print neighborhood names


#Global G Test
##Test for global spatial autocorrelation

# Now that we removed empty neighbor sets (tes_subset)
# Identify neighbors with queen contiguity (edge/vertex touching)
tes_nb <- poly2nb(tes_subset, queen = TRUE)

# Binary weighting assigns a weight of 1 to all neighboring features 
# and a weight of 0 to all other features
tes_w_binary <- nb2listw(tes_nb, style="B")

# Calculate spatial lag of TreEqty
tes_lag <- lag.listw(tes_w_binary, tes_subset$TreeEquity)


# Test for global G statistic of TreEqty
globalG.test(tes_subset$TreeEquity, tes_w_binary)

# Global G Test
# Test for global spatial autocorrelation
tes_subset

# Identify neighbors, create weights, calculate spatial lag
tes_nbs <- tes_subset |> 
  mutate(
    nb = st_contiguity(geometry),        # neighbors share border/vertex
    wt = st_weights(nb),                 # row-standardized weights
    tes_lag = st_lag(TreeEquity, nb, wt)    # calculate spatial lag of TreeEquity
  )

# Calculate the Gi using local_g_perm
tes_hot_spots <- tes_nbs |> 
  mutate(
    Gi = local_g_perm(TreeEquity, nb, wt, nsim = 999)
    # nsim = number of Monte Carlo simulations (999 is default)
  ) |> 
  # The new 'Gi' column itself contains a dataframe 
  # We can't work with that, so we need to 'unnest' it
  unnest(Gi)

#Let’s do a cursory visualization of Gi values across Tucson.
# Cursory visualization
# Plot looks at gi values for all locations
tes_hot_spots |> 
  ggplot((aes(fill = gi))) +
  geom_sf(color = "black", lwd = 0.15) +
  scale_fill_gradient2() # makes the value 0 (random) be the middle
