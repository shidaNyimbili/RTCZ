
source("scripts/r prep2.r")
library(cartography)

# Read shapefile
provinces_zam <- st_read("Data/Updated Shapefiles/Updated_Province.shp")

# Read HIV prevalence rates data
prev.hiv <- read_xlsx("Data/prematurity/HIV Prev Rates.xlsx")
glimpse(prev.hiv)

# Extract year from the 'period' column
prev.hiv <- prev.hiv %>%
  mutate(year = str_sub(period,
                        start = nchar(period) - 4,
                        end = nchar(period)))

# Select relevant columns and handle missing values
prev.hiv1 <- prev.hiv %>%
  select(1, 2, 4) %>%
  na.omit()

# Rename columns
prev.hiv2 <- prev.hiv1 %>%
  rename(prov = 1,
         peri.mr = 2,
         yr = 3)

# Reshape the data
prev.hiv3 <- prev.hiv2 %>%
  gather(key = subRt, value = rate, c(peri.mr))

# Extract relevant columns from provinces_zam
provinces_zam1 <- provinces_zam %>%
  select(2, 9) %>%
  na.omit()

# Group and join data
prev.hiv4 <- prev.hiv3 %>%
  group_by(yr, prov, subRt)

prev.hiv5 <- left_join(prev.hiv4,
                       provinces_zam1,
                       by = c("prov" = "PROVINCE")) %>%
  sf::st_as_sf()

# Plotting
ggplot(prev.hiv5, aes(geometry = geometry, fill = rate)) +
  geom_sf() +
  geom_sf_text(aes(label = paste(prov, "\n", sprintf("%.2f", rate))), size = 3.2) + # Add previous rates as labels
  facet_wrap(~yr) +
  scale_fill_carto_c(name = "Prev Rates(%)", palette = "Blues") + # Specify the fill color and adjust legend title
  labs(x = "", y = "", caption = "Data Source: PEPFAR Zambia",
       title = "HIV/AIDS Prevalence rates, 2019-2022") +
  theme_void() +
  theme(plot.title.position = "plot",
        plot.title = element_text(size = 18, hjust = 0.5, family = "Gill Sans Mt", face = "bold"),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        plot.caption = element_text(size = 11),
        legend.text = element_text(size = 13),
        legend.title = element_text(size = 13), # Adjust legend title size
        legend.position = "right",
        strip.text = element_text(size = 14, family = "Gill Sans Mt"))

# Save the plot
ggsave("viz/prematurity/prev_rate3.png",
       device = "png",
       type = "cairo",
       height = 7.5,
       width = 13)

This should resolve the issues you encountered.