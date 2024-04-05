source("scripts/r prep2.r")

# Read shapefile
districts_zam <- st_read("Data/Updated Shapefiles/Districts.shp")

# Read HIV.prevalence.rates data
prev.data <- read_xlsx("Data/reserach/prevdata.xlsx")

prev.data

# Extract year from the 'period' column
prev.data <- prev.data %>%
  mutate(year = str_sub(period, start = nchar(period) - 4, end = nchar(period)))

# Select relevant columns and handle missing values
prev.data.1 <- prev.data %>%
  select(1, 2, 3, 5) %>%
  na.omit()

prev.data.1

# Rename columns
prev.data.3 <- prev.data.1 %>%
  rename(prov = 1,
         distrt = 2,
         rate = 3,
         yr = 4)

prev.data.3

# Reshape the data
# prev.data.3 <- prev.data.2 %>%
#   gather(key = subRt, value = rate, c(prev.rt))

# Extract relevant columns from provinces_zam
districts_zam1 <- districts_zam %>%
  select(7, 10) %>%
  na.omit()

# Group and join data
prev.data.4 <- prev.data.3 %>%
  group_by(yr, distrt)

dta.hotspt <- left_join(prev.data.4,
                         districts_zam1,
                         by = c("distrt" = "DISTRICT")) %>%
  sf::st_as_sf()

dta.hotspt

prevdata_year <- dta.hotspt %>%
  select(1,2,3,5)

# #Filter years
selected_year = 2020
prevdata_year <- dta.hotspt[dta.hotspt$yr == 2020, ]

# selected_year <- c(2020, 2021)
# prevdata_year <- dta.hotspt[dta.hotspt$yr %in% selected_year, ]


prevdata_year

prevdata_year <- drop_na(prevdata_year)

names(prevdata_year)

prevdata_year$rate <- as.numeric(prevdata_year$rate)

hist(prevdata_year$rate, main = "Distribution of HIV Prevalence Rates", xlab = "rate", ylab = "Frequency")

prevdata_year$rate

prevdata_year

# Visualize district prev rates across across the country
ggplot(prevdata_year) +
  geom_sf(aes(fill = rate), color = "black", lwd = 0.15) +
  geom_sf_text(aes(label = distrt), size = 2) +
  scale_fill_gradient(name = "HIV Prevalence Rates",
                      low = "white",
                      high = "darkgreen") +
  ggtitle("District HIV Prevalence rates in Zambia in 2020") +
  labs(x ="", y="",caption = "Data source: PEPFAR Zambia") +
  theme_minimal() +
  facet_wrap(~yr)

ggsave("viz/research/20202021.png",
       device="png",
       type="cairo",
       height = 7.5,
       width = 10)

prevdata_year <- st_make_valid(prevdata_year)

# Create a district list based on queen contiguity
list_nb <- poly2nb(prevdata_year, queen = TRUE)

# Check for empty district sets
# card() calculates number of district for each polygon in the list
# which() finds polygons with 0 neighbors
empty_nb <- which(card(list_nb) == 0)
empty_nb
# 
# # Remove district-polygons with empty neighbor sets from the data
prevdata_year.subset <- prevdata_year[-empty_nb, ]
# 
# # Subset 'prevdata_year' to extract polygons with empty neighbor sets
empty_polygons <- prevdata_year.subset[empty_nb, ]

empty_polygons

empty_polygons$nghbrhd  # print neighborhood names

#Global G Test
##Test for global spatial autocorrelation
# Now that we removed empty neighbor sets (tes_subset)
# Identify neighbors with queen contiguity (edge/vertex touching)
prev_nb <- poly2nb(prevdata_year, queen = TRUE)

# Binary weighting assigns a weight of 1 to all neighboring features 
# and a weight of 0 to all other features
prev_w_binary <- nb2listw(prev_nb, style="B")

# Calculate spatial lag of TreEqty
prev_lag <- lag.listw(prev_w_binary, prevdata_year$rate)

prev_lag

# Calculate spatial weights
prev_w <- poly2nb(prevdata_year)
prev_w_binary <- nb2listw(prev_w, style = "B")

# Calculate spatial lag
prevdata_year$prev_lag <- lag.listw(prev_w_binary, prevdata_year$rate)


# Test for global G statistic of prev rates
globalG.test(prevdata_year$rate, prev_w_binary)

# Global G Test
# Test for global spatial autocorrelation

# Identify neighbors, create weights, calculate spatial lag
prev_nbs <- prevdata_year |> 
  mutate(
    nb = st_contiguity(geometry),        # neighbors share border/vertex
    wt = st_weights(nb),                 # row-standardized weights
    prev_lag = st_lag(rate, nb, wt)    # calculate spatial lag of TreeEquity
  )

# Calculate the Gi using local_g_perm
prev_hot_spots <- prev_nbs |> 
  mutate(
    Gi = local_g_perm(prevdata_year, nb, wt, nsim = 999)
    # nsim = number of Monte Carlo simulations (999 is default)
  ) |> 
  # The new 'Gi' column itself contains a dataframe 
  # We can't work with that, so we need to 'unnest' it
  unnest(Gi)


