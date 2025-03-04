
source("scripts/r prep2.r")

# install.packages("libwgeom")
# 
# 
# demo <- read_csv("C:/Users/SNyimbili/OneDrive - Right to Care/Desktop/R/Book3.csv")
# demo
# 
# demo1 <- demo %>% 
#   mutate(Date = as.Date(Date, format = "%d/%m/%y"))
# 
# demo1
# 
# 
# ###Stata
# 
# #date_upload
# demoR <- read_csv("C:/Users/SNyimbili/OneDrive - Right to Care/Desktop/R/Stata.csv")
# 
# demoR
# 
# demoR1 <- demoR %>% 
#   mutate(date_uploaded = as.Date(date_uploaded, format = "%d/%m/%y"))
# 
# demoR1
# 
# sum(is.na(demoR1$date_uploaded))           ###Its giving 461 NAs
# 
# demoR1 <- na.omit(demoR1)
# 
# demoR1
# 
# #tdb_creation_date
# demoR
# 
# tbd_crtn_col <- demoR %>% 
#   mutate(tdb_creation_date = as.Date(tdb_creation_date, format = "%d/%m/%y"))
# 
# tbd_crtn_col
# 
# 
# sum(is.na(tbd_crtn_col$tdb_creation_date))       #Its giving 140 NAs
# 
# colnames(tbd_crtn_col)
# 
# 
# # install.packages("magick")
# library(magick)
# 
# # Reading a PNG
# image <- image_read('https://raw.githubusercontent.com/R-CoderDotCom/samples/main/bird.png')
# 
# # Printing the image
# print(image, info = FALSE) 
# 
# 
# 
# 
# 
# 
# 
# install.packages("here")
# devtools::install_github("thomasp85/patchwork")
# 
# remotes::install_gitlab("dickoa/rgeoboundaries")
# 
# install.packages("easypackages")




# perinatal.mort <- read_xlsx("C:/Users/SNyimbili/Downloads/perinatal mortality rate.xlsx")
perinatal.mort <- read_xlsx("C:/Users/SNyimbili/Downloads/alex.xlsx")
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

zam.boundary <- geoboundaries(country = "Zambia"
                              , adm_lvl = 1) %>% 
  select(shapeName)

zam.boundary

#write_xlsx(zam.boundary,"data/prematurity/province.xlsx")

zam.boundary1 <- zam.boundary %>%
  select(1, 2) %>%
  na.omit()

zam.boundary1


map_colors <- carto_pal(name = "Burg")


perinatal.mort4 <- perinatal.mort3 %>%
  group_by(yr,prov, subRt)


perinatal.mort4

perinatal.mort5 <- left_join(perinatal.mort4
                      , zam.boundary1
                      , by = c("prov" = "shapeName")) %>%
  sf::st_as_sf()

perinatal.mort5

ggplot(perinatal.mort5, aes(geometry = geometry, fill = rate)) +
  geom_sf()+
  geom_sf_text(aes(label = prov), size = 3) +
  facet_wrap(~yr) +
  scale_fill_carto_c(name="Proportion of\n Mortality Rate"
                     , palette = "Burg") +
  labs(x="", y="", caption = "Data Source: PDSR",
       title = "Proportion of Postpartum FP clients at 6 weeks, 2020-2024"
       , subtitle = "Darker colors represent a higher proportion of mortality rate(%)") + #for faceted and xy labels include x="Longitude", y="Latitude", +faceted
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

##interactive map  
# zam.boundary2 %>%
#   leaflet() %>%
#   addTiles() %>%
#   addPolygons(label = zam.boundary2$shapeName)

ggsave("Viz/6weeks FP_rate.png",
       device="png",
       type="cairo",
       height = 6.5,
       width = 15)

#'*Prematurity rate*
prema.rate <- read_xlsx("data/prematurity/prematurity rate.xlsx")

prema.rate$Month <- as.Date(prema.rate$Month)

prema.rate

prema.rate2 <- prema.rate %>%
  rename( prema.rate = 2) %>%
  mutate(prema.rate.prt = prema.rate/100)



prema.rate2 <- prema.rate2 %>%
  select(1,3)

prema.rate2

prema.rate3 <- prema.rate2 %>% 
  gather(key = subRt , value = rate, c(prema.rate.prt))

prema.rate3

ggplot(prema.rate3, aes(x = Month, y = rate, group = subRt, colour = subRt)) +
  geom_point(alpha=.6, size=1.9) + 
  #geom_line(size=1) +
  geom_smooth(method = loess, size = .8, se=FALSE) +
  scale_y_continuous(limits = c(0,1),
                     labels = percent,
                     breaks = c(.1,.2,.3,.4,.5,.6,.7,.8,.9, 1)) +
  scale_x_date(date_labels="%b %y",date_breaks="4 months") +
  xlab("") + 
  ylab("") +
  ggtitle("Prematurity Rate , Sept 2017-Oct 2022") +
  scale_color_manual(name ="",
                     values = usaid_red) + 
  baseX

ggsave("viz/prematurity/prematurity_rate.png",
       device="png",
       type="cairo",
       height = 5.5,
       width = 12)


#'*Perinatal deaths, Fresh Still & Macerated Stillbirths*
pr.mr.st <- read_xlsx("data/prematurity/perinatal & stillbirths.xlsx")

pr.mr.st

pr.mr.st$Month <- as.Date(pr.mr.st$Month)

pr.mr.st


pr.mr.st2 <- pr.mr.st %>%
  rename(mth =1,
         peri.deaths=2,
         peri.Rt=3,
         frsh.stlbrth.Rt=4,
         mcrtd.brth.Rt=5)

pr.mr.st2

#'*Perinatal deaths*
perinatal.deaths <- pr.mr.st2 %>%
  select(1,2)

perinatal.deaths

perinatal.deaths <- perinatal.deaths %>% 
  gather(key = subRt , value = rate, c(peri.deaths))

perinatal.deaths

ggplot(perinatal.deaths, aes(x = mth, y = rate, group = subRt, colour = subRt)) +
  geom_point(alpha=.6, size=1.9) + 
  #geom_line(size=1) +
  geom_smooth(method = loess, size = .8, se=FALSE) +
  # scale_y_continuous(limits = c(0,1),
  #                    labels = percent,
  #                    breaks = c(.1,.2,.3,.4,.5,.6,.7,.8,.9, 1)) +
  scale_x_date(date_labels="%b %y",date_breaks="3 months") +
  xlab("") + 
  ylab("Deaths") +
  ggtitle("Perinatal deaths ,Jan 2019 - Oct 2022") +
  scale_color_manual(name ="",
                     values = usaid_red) + 
  basey

ggsave("viz/prematurity/perinatal deaths.png",
       device="png",
       type="cairo",
       height = 5.5,
       width = 11)

#'*Stillbirths*
pr.mr.st2
frsh.stillmacerbirth <- pr.mr.st2 %>%
  select(1,4,5)

frsh.stillmacerbirth


frsh.stillmacerbirth <- frsh.stillmacerbirth %>% 
  gather(key = subRt , value = rate, c(mcrtd.brth.Rt,frsh.stlbrth.Rt))

ggplot(frsh.stillmacerbirth, aes(x = mth, y = rate, group = subRt, fill = subRt)) +
  geom_area(alpha=0.2, position = position_dodge()) +
  scale_y_continuous(limits = c(0,8),
                     breaks = c(0,2,4,6,8)) +
  xlab("") + 
  ylab("Rate") +
  ggtitle("Fresh stillbirth and Macerated stillbirth per 1000 live births ,Jan 2019 - Oct 2022") +
  scale_x_date(date_labels="%b %y",date_breaks="3 months") +
  scale_fill_manual(name ="",
                     values = c(usaid_red,usaid_blue),labels = c("Fresh Stillbirth", "Macerated Stillbirth")) + base

ggsave("viz/prematurity/stillbirths.png",
       device="png",
       type="cairo",
       height = 5.0,
       width = 10)


#'*Causes Perinatal Deaths*
cod <- read_xlsx("data/prematurity/Perinatal Deaths.xlsx")

# cod$causes <- as.Date(cod$causes)

cod
cod <- melt(cod[c(1, 2, 3, 4, 5, 6, 7)], id = 'causes')

cod

cod1 <- ggplot(cod, aes(x=causes, y=value, fill=variable), alpha=0.6)+ 
  geom_bar(alpha=.7,stat="identity", position="dodge") +
  scale_fill_manual(values=c( usaid_palette6)) +
  scale_y_continuous(labels=comma) +
  labs(fill="Legend:", title="Causes of Perinatal Deaths, 2017-2022",
       x="",
       y="Number of cases") + base

cod1
ggsave("viz/prematurity/causes.png",
       device="png",
       type="cairo",
       height = 6.0,
       width = 13)

#'*Perinatal Deaths by death*
peri.dth.prv <- read_xlsx("data/prematurity/perinatal deaths by province.xlsx")
peri.dth.prv  <- peri.dth.prv  %>%
  mutate(month_chr = str_sub(periodname,
                             start=1,
                             end=nchar(periodname)-5),
         month = factor(month_chr,
                        levels=c("January","February","March","April","May","June","July","August","September","October","November","December")),
         month_code = as.numeric(month), 
         year = str_sub(periodname, 
                        start=nchar(periodname)-4,
                        end=nchar(periodname)),
         monyr = paste(month_code, year, sep="-"),
         mnthyr = my(monyr))

peri.dth.prv
colnames(peri.dth.prv)

peri.dth.prv1 <- peri.dth.prv %>%
  select(2,3,9)

peri.dth.prv1

peri.dth.prv2 <- peri.dth.prv1 %>%
  rename(prov=2,
         mnth=3)

peri.dth.prv2

pd <- ggplot(peri.dth.prv2, aes(x=mnth, y=Deaths), alpha=0.5)+ 
  geom_smooth(method=loess, color=usaid_red, size=0.7,se=F) + 
  geom_point(color=usaid_red) + faceted +
  facet_wrap(~prov) + ##scales="free_y" tom allow for independ y axis variables
  scale_x_date(date_labels="%b",date_breaks="1 month") + 
  labs(fill="Legend:", title="Perinatal Deaths by Province, 2022",
       x="",
       y="Number of Deaths")
pd

ggsave("viz/prematurity/perinatal deaths.png",
       device="png",
       type="cairo",
       height = 6.0,
       width = 13)