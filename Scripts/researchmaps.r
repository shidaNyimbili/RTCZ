
source("scripts/r prep2.r")


# Read shapefile
provinces_zam <- st_read("Data/Updated Shapefiles/Updated_Province.shp")
districts_zam <- st_read("Data/Updated Shapefiles/Districts.shp")


provinces_zam
districts_zam

names(districts_zam)

# Read HIV prevalence rates data
prev.hiv <- read_xlsx("Data/prematurity/HIV Prev Rates.xlsx")

prev.hiv

prev.data <- read_xlsx("Data/reserach/prevdata.xlsx")

prev.data

glimpse(prev.data)

# Extract year from the 'period' column
prev.data <- prev.data %>%
  mutate(year = str_sub(period,
                        start = nchar(period) - 4,
                        end = nchar(period)))

prev.data

# Select relevant columns and handle missing values
prev.data.1 <- prev.data %>%
  select(1, 2, 3, 5) %>%
  na.omit()

prev.data.1

# Rename columns
prev.data.2 <- prev.data.1 %>%
  rename(prov = 1,
         distrt = 2,
         prev.rt = 3,
         yr = 4)

prev.data.2

# Reshape the data
prev.data.3 <- prev.data.2 %>%
  gather(key = subRt, value = rate, c(prev.rt))

prev.data.3

# Extract relevant columns from provinces_zam
districts_zam1 <- districts_zam %>%
  select(7, 10) %>%
  na.omit()

# Group and join data
prev.data.4 <- prev.data.3 %>%
  group_by(yr, distrt, subRt)

prev.data.5 <- left_join(prev.data.4,
                         districts_zam1,
                       by = c("distrt" = "DISTRICT")) %>%
  sf::st_as_sf()

library(ggplot2)

display.brewer.all(type="seq")
display.brewer.all(type="div")

# Define a reversed color palette
rev_palette <- rev(RColorBrewer::brewer.pal(9, "Blues"))

library(ggplot2)
library(RColorBrewer)

# Define a reversed color palette
rev_palette <- rev(brewer.pal(9, "Blues"))

# Plotting
plot <- ggplot(prev.data.5, aes(geometry = geometry, fill = rate)) +
  geom_sf() +
  geom_sf_text(aes(label = paste(distrt)), size = 1.2) + # Add previous rates as labels
  facet_wrap(~yr) +
  scale_fill_gradient(name = "Prev Rates(%)", low = rev_palette[length(rev_palette)], high = rev_palette[1]) + # Use the reversed color palette
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
ggsave("viz/research/prev_rate.png",
       plot,
       device = "png",
       type = "cairo",
       height = 7,
       width = 10)



#####TEST
# Plotting
plot <- ggplot(prev.data.5, aes(geometry = geometry, fill = rate)) +
  geom_sf() +
  geom_sf_text(aes(label = paste(distrt)), size = 1.9, colour=usaid_red) + # Add previous rates as labels
  facet_wrap(~yr) +
  scale_fill_gradient(name = "Prev Rates(%)", 
                      breaks = seq(0.7, 14, by = 3.25),  # Define breaks for the legend
                      labels = seq(0.7, 14, by = 3.25),  # Labels for the breaks
                      limits = c(0.7, 14),  # Set limits for the color scale
                      low = rev_palette[length(rev_palette)], 
                      high = rev_palette[1]) + # Use the reversed color palette
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
ggsave("viz/research/prev_rate.png",
       plot,
       device = "png",
       type = "cairo",
       height = 15,  # Increase the height
       width = 20)   # Increase the width
##TEST



# Plotting
ggplot(prev.data.5, aes(geometry = geometry, fill = rate)) +
  geom_sf() +
  geom_sf_text(aes(label = paste(distrt, "\n", sprintf("%.2f", rate))), size = 1.2) + # Add previous rates as labels
  facet_wrap(~yr) +
  scale_fill_carto_c(name = "Prev Rates(%)", palette = "RedPurple") + # Specify the fill color and adjust legend title
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
ggsave("viz/research/prev_rate.png",
       device = "png",
       type = "cairo",
       height = 7.5,
       width = 16)
