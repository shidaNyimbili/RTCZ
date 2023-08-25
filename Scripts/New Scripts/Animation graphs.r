
source("scripts/r prep2.r")

gapminder

#write_excel_csv(gapminder, "cleaned_data_file.csv", col_names = TRUE)


# Make a ggplot, but add frame=year: one image per year
dm <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = continent)) +
  geom_point() +
  scale_x_log10() +
  theme_bw() +
  # gganimate specific bits:
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')
dm

dm1 <- dm + facet_wrap(~continent) +
  transition_time(year) +
  labs(title = "Year: {frame_time}")

dm1




gganimate::animate(dm1, nframes = 100, fps = 10, renderer = gifski_renderer())

# Save at gif:
anim_save("271-ggplot2-animated-gif-chart-with-gganimate1.gif")


##Map animation
source("scripts/r prep2.r")
# library(ggplot2)
# library(sf)


provinces_zam <- st_read("Data/Updated Shapefiles/Updated_Province.shp")

#library(sf)

# Check CRS of sf objects
#crs1 <- st_crs(provinces_zam)
#crs2 <- st_crs(sf_object2)

# Print the CRS information
#print(crs1)
#print(crs2)






#verify data
str(provinces_zam)

head(provinces_zam)

#colors_prov <- c("red", "orange", "yellow", "green", "blue", "purple", "pink", "brown", "grey","lightblue")

#plot

ggplot(provinces_zam) +
  geom_sf(aes(fill = PROVINCE), color = "black") +
  scale_fill_manual(values = colors_prov, guide = "none") +
  labs(x = "Longitude", y = "Latitud", title = "Map of Provinces in Zambia") +
  theme(plot.title = element_text(hjust = 0.5))


perinatal.mort <- read_xlsx("Data/prematurity/perinatal mortality rate2.xlsx")
perinatal.mort
perinatal.mort  <- perinatal.mort  %>%
  mutate(year = str_sub(period,
                        start=nchar(period)-4,
                        end=nchar(period)))
perinatal.mort

perinatal.mort1 <- perinatal.mort %>%
  select(1,2,4) %>%
  na.omit()

perinatal.mort2 <- perinatal.mort1 %>%
  rename(prov =1,
         peri.mr=2,
         yr=3)

perinatal.mort2

perinatal.mort3 <- perinatal.mort2 %>% 
  gather(key = subRt , value = rate, c(peri.mr))

perinatal.mort3

#zam.boundary <- geoboundaries(country = "Zambia"
#, adm_lvl = 1) %>% 
#select(shapeName)

#zam.boundary

#write_xlsx(zam.boundary,"data/prematurity/province.xlsx")

provinces_zam1 <- provinces_zam %>%
  select(2, 9) %>%
  na.omit()

provinces_zam1


map_colors <- carto_pal(name = "Burg")


perinatal.mort4 <- perinatal.mort3 %>%
  group_by(yr,prov, subRt)


perinatal.mort4

perinatal.mort5 <- left_join(perinatal.mort4
                             , provinces_zam1
                             , by = c("prov" = "PROVINCE")) %>%
  sf::st_as_sf()

perinatal.mort5



ggplot(perinatal.mort5, aes(geometry = geometry, fill = rate)) +
  geom_sf()+
  geom_sf_text(aes(label = prov), size = 3) +
  facet_wrap(~yr) +
  scale_fill_carto_c(name="Proportion of\n Mortality Rate"
                     , palette = "Blues") +
  labs(x="", y="", caption = "Data Source: SI/VM&E Action HIV",
       title = "Increase of PLHIV, 2017-2022"
       , subtitle = "Darker colors represent a significant increase in density Population per sqkm") + #for faceted and xy labels include x="Longitude", y="http://127.0.0.1:28939/graphics/plot_zoom_png?width=923&height=900Latitude", +faceted
  theme_void() +
  theme(plot.title.position = "plot",
        plot.title = element_text(size = 16, hjust=0.5, family="Gill Sans Mt", face="bold"),
        plot.subtitle = element_text(size = 12, hjust=0.5),
        plot.caption = element_text(size=11),
        # axis.title.x = element_text(size = 12, family="Gill Sans Mt", face="bold"),
        # axis.title.y = element_text(size = 12, family="Gill Sans Mt", face="bold"),
        # axis.text.x = element_text(size = 8),
        # axis.text.y = element_text(size = 10),
        legend.text = element_text(size = 12),
        legend.title=element_blank(),
        legend.position="right",
        strip.text=element_text(size=14, family="Gill Sans Mt"))

perinatal.mort5
perinatal.mort5 <- st_transform(perinatal.mort5, crs = st_crs(perinatal.mort5))

perinatal.mort5$yr <- as.Date(as.character(perinatal.mort5$yr), format = "%Y")

perinatal.mort5


##Maps
# Make a ggplot, but add frame=year: one image per year
dm <- ggplot(perinatal.mort5, aes(geometry = geometry, fill = rate, color = rate)) +
  #geom_point() +
  scale_x_log10() +
  theme_bw() +
  # gganimate specific bits:
  labs(title = 'Year: {yr}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(yr) +
  ease_aes('linear')

dm

# Transform sf_object2 to match the CRS of sf_object1
perinatal.mort5 <- st_transform(perinatal.mort5, crs = st_crs(perinatal.mort5))

perinatal.mort5$yr <- as.Date(as.character(perinatal.mort5$yr), format = "%Y")

perinatal.mort5



# Use mutate from dplyr to convert the column
perinatal.mort6 <- perinatal.mort5 %>%
  mutate(yr = format(as.Date(yr), format = "%Y"))
  
perinatal.mort6$yr

perinatal.mort6

ggplot(perinatal.mort6, aes(geometry = geometry, fill = rate)) +
  geom_sf()+
  geom_sf_text(aes(label = prov), size = 3) +
  facet_wrap(~yr) +
  scale_fill_carto_c(name="Proportion of\n Mortality Rate"
                     , palette = "Blues") +
  labs(x="", y="", caption = "Data Source: SI/VM&E Action HIV",
       title = "Increase of PLHIV, 2017-2022"
       , subtitle = "Darker colors represent a significant increase in density Population per sqkm") + #for faceted and xy labels include x="Longitude", y="http://127.0.0.1:28939/graphics/plot_zoom_png?width=923&height=900Latitude", +faceted
  theme_void() +
  theme(plot.title.position = "plot",
        plot.title = element_text(size = 16, hjust=0.5, family="Gill Sans Mt", face="bold"),
        plot.subtitle = element_text(size = 12, hjust=0.5),
        plot.caption = element_text(size=11),
        # axis.title.x = element_text(size = 12, family="Gill Sans Mt", face="bold"),
        # axis.title.y = element_text(size = 12, family="Gill Sans Mt", face="bold"),
        # axis.text.x = element_text(size = 8),
        # axis.text.y = element_text(size = 10),
        legend.text = element_text(size = 12),
        legend.title=element_blank(),
        legend.position="right",
        strip.text=element_text(size=14, family="Gill Sans Mt"))
####Animation map v3

# Install packages if not already installed
# install.packages("ggplot2")
# install.packages("gganimate")
# install.packages("sf")  # For working with spatial data (if needed)

# Load packages
library(ggplot2)
library(gganimate)

library(ggplot2)
library(gganimate)
library(transformr)

perinatal.mort6

library(sf)

# Check CRS of sf objects
crs1 <- st_crs(sf_object1)
crs2 <- st_crs(sf_object2)

# Print the CRS information
print(crs1)
print(crs2)


library(sf)

# Assuming your data is in a geographic CRS like WGS 84 (EPSG 4326)
# Define a projected CRS appropriate for your region
projected_crs <- st_crs("+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs")

# Reproject your data to the projected CRS
data <- st_transform(perinatal.mort6, crs = projected_crs)

data1 <- st_transform(data, crs = st_crs(data))

data1

# Use mutate from dplyr to convert the column
perinatal.mort6 <- data1 %>%
  mutate(yr = format(as.Date(yr), format = "%Y"))

perinatal.mort6

# Now, you can use st_point_on_surface() on the reprojected data
#result <- st_point_on_surface(data)

# List all objects in your workspace
# Filter objects that are of class "sf" or "sfc"
objects <- ls(perinatal.mort5)
sf_objects <- objects[sapply(objects, function(obj) inherits(get(obj), "sf") || inherits(get(obj), "sfc"))]

# Print the list of sf objects
print(sf_objects)

# Check CRS of sf objects
crs1 <- st_crs(health_facilities_sf)
crs2 <- st_crs(patients_sf)
print(crs1)
print(crs2)


patients <- st_transform(patients_sf, crs = st_crs(health_facilities_sf))

data1

perinatal.mort6 <- perinatal.mort5 %>%
  mutate(yr = format(as.Date(yr), format = "%Y"))


patients <- st_transform(patients_sf, crs = st_crs(health_facilities_sf))

perinatal.mort5

# Create a ggplot2 object with a base map
base_plot <- ggplot(perinatal.mort5, aes(geometry = geometry, fill = rate)) +
  geom_sf()+
  geom_sf_text(aes(label = prov), size = 3) +
  #geom_polygon(aes(fill = geometry)) +  # Customize aesthetics
  labs(title = "Performance Map") +
  theme_minimal() +
  transition_time(yr)

base_plot

# Render the animation
gganimate::animate(base_plot, nframes = 100, fps = 10, renderer = gifski_renderer())

# To save the animation to a file (e.g., GIF)
# anim_save("performance_animation.gif")

install.packages('elevatr')


###New idea

library(rnaturalearth)
library(elevatr)
library(terra)
map <- ne_countries(type = "countries", country = "Zambia",
                    scale = "medium", returnclass = "sf")
d <- get_elev_raster(locations = map, z = 9, clip = "locations")
terra::plot(rast(d), plg = list(title = "Elevation (m)"))
