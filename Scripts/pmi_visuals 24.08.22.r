#Load Packages


source("scripts/r prep2.r")

#'*St PAULS MISSION SEVERE AND MALRIA DEATHS*
iccm <- read_xls("Data/RTC/demodata/iccm.xls")
st.pauls <- read_xls("Data/RTC/demodata/stpaulsmission.xls")
st.pauls  <- st.pauls  %>%
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

names(st.pauls)

st.pauls

st.pauls1 <- st.pauls %>%
  select(2,3,9) %>%
  na.omit()

st.pauls1


st.pauls2 <- st.pauls1 %>%
  rename(severe = 1,
         deaths  = 2,
         mnthyr=3)

st.pauls2

#Correlation check
ggpairs(st.pauls2, columns = 1:2)



iccm$start <- as.Date(iccm$start) 
iccm$end <- as.Date(iccm$end)

start <- as.Date(NULL)
end <- as.Date(NULL)

dt <- as.Date("2017-10-01")
dt1 <- as.Date("2018-10-01")
dt2 <- as.Date("2020-12-01")
dt3 <- as.Date("2014-10-01")

st_plt <- ggplot(st.pauls2) +
  geom_area(data=st.pauls2, aes(x=mnthyr, y=severe, fill ="severe"), alpha=.3, position = position_dodge()) +
  geom_area(data=st.pauls2, aes(x=mnthyr, y=deaths, fill ="deaths"), alpha=.9, position = position_dodge()) +
  geom_rect(data=iccm, aes(NULL, NULL, xmin=start, xmax=end, fill=campaign),
            ymin=0,ymax=272, size=0.6, alpha=0.2, lty="dotted") +
  labs(fill="Legend:", title="Severe Malaria and deaths Cases for St Pauls Mission Hospital, 2014-2022",
       x="",
       y="Malaria and Deaths Cases", caption = "Data Source: HMIS & PAMO") +
  scale_y_continuous(breaks = c(0, 68,136,204,272)) +
  scale_fill_manual(values=c(usaid_red, medium_grey, zamOrange), labels=c("Malaria Death Cases", "ICCM Campaigns","Reported Severe Malaria")) + 
  scale_x_date( date_labels="%b %y",date_breaks="6 month", limits = NULL) + basey +
  
  geom_vline(xintercept = c(dt, dt1, dt2, dt3) ,color=c(light_grey,"#198a00ff", "#198a00ff", zamGreen) ,lty=c("solid","dotted", "dotted", "dotted") ,size=c(2,2,2,2), alpha=1)+
  annotate("text", x = dt, y = 0, label = substitute(paste(bold('Integrated community case management'))), size=4, angle=90, hjust =-0.3, vjust=-1, color="black")+
  annotate("text", x = dt1, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns'))), size=4, angle=90, hjust =-1, vjust=-0.7, color="#198a00ff")+
  annotate("text", x = dt2, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns'))), size=4, angle=90, hjust =-1, vjust=-0.5, color="#198a00ff") +
  annotate("text", x = dt3, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns'))), size=4, angle=90, hjust =-1, vjust=-0.5, color="#198a00ff")



st_plt

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/stPauls.png",
       device="png",
       type="cairo",
       height = 6.5,
       width = 13)

#'*Malaria Incidence Maps*
mal.inc <- read_xls("C:/Users/snyimbili/Documents/RTCZ/Data Analytics & GIS/R/R Data/R Data/Data PMI/Nchelenge(monthly)_2014-2022.xls")
mal.inc  <- mal.inc  %>%
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

names(mal.inc)
mal.inc

mal.inc1 <- mal.inc %>%
  select(2, 8, 27) %>%
  na.omit()

mal.inc1

mal.inc1 <- mal.inc1 %>%
  rename(ogunt = 1,
         mal.incr  = 2,
         yr=3) %>%
  mutate(mal.incp=mal.incr/100)

mal.inc1

mal.inc1 <- mal.inc1 %>% 
  gather(key = subpop , value = rate, c(mal.incp))

mal.inc1

  
zam.boundary <- geoboundaries(country = "Zambia"
                     , adm_lvl = 2) %>% 
  select(shapeName)

zam.boundary

zam.boundary1 <- zam.boundary %>%
  select(1, 2) %>%
  na.omit()

zam.boundary1

zam.boundary2 <- filter(zam.boundary1, shapeName == 'Nchelenge')

names(zam.boundary2)
zam.boundary2


# zam.boundary$shapeName <- recode(zam.boundary$shapeName
#                         , "North Western" = "Northwestern")         #Correcting name so that they match

map_colors <- carto_pal(name = "Burg")


mal.inc2 <- mal.inc1 %>%
  group_by(yr,ogunt, subpop)

  # summarise(value = mean(rate_fix)) %>% 
  # mutate(target = case_when(as.numeric(year) == 2018 ~ .79
  #                           , as.numeric(year) == 2019 ~ .86
  #                           , as.numeric(year) == 2020 ~ .9
  #                           , as.numeric(year) == 2021 ~ .95))



mal.inc2 <- left_join(mal.inc2
                       , zam.boundary2
                       , by = c("ogunt" = "shapeName")) %>%
  sf::st_as_sf()

mal.inc2


ggplot(mal.inc2, aes(geometry = geometry, fill = rate)) +
  geom_sf()+
  #geom_sf_text(aes(label = ogunt), size = 4) +
  facet_wrap(~yr) +
  scale_fill_carto_c(name="Proportion of\n Malaria incidence"
                     , palette = "Burg") +
  labs(x="", y="", caption = "Data Source: PDSR",
       title = "Proportions of Malaria Incidence rates all ages by year, 2018-2022"
       , subtitle = "Darker colors represent a higher proportion of incidence rate") + #for faceted and xy labels include x="Longitude", y="Latitude", +faceted
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


ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/iNcidence rates2.png",
       device="png",
       type="cairo",
       height = 6.5,
       width = 13)


#'*Provincial Rainfall and Malaria Confirmed Cases*
rnf_malprov <- read_xlsx("data/Malaria/Provincial rainfall.xlsx")
names(rnf_malprov)
rnf_malprov

# rnf1<- rnf %>%
#   group_by(Month, Year, Province) %>%
#   summarise(sm.rainfall=sum(Rainfall),
#             avg.rainfall=(mean(Rainfall))) %>%
#   mutate(date = my(paste(Month, Year, sep="-")))

rnf_malprov <- rnf_malprov %>%
  rename(prov = 1,
         mal.cases = 2,
         mnthyr = 3,
         rainfall = 4) %>%
  
  # mutate(rainfallr = rainfall*250) %>% 
  
  select(prov, mal.cases, mnthyr, rainfall) %>% 
  mutate(prov = factor(prov),
         ip = case_when(prov=="Northern" |
                          prov =="Central" |
                          prov =="Muchinga" |
                          prov =="Southern" |
                          prov =="Copperbelt" |
                          prov =="Lusaka" |
                          prov =="Western" |
                          prov =="Muchinga" |
                          prov == "Northwestern"|
                          prov =="Eastern" ~ "ip",
                        TRUE ~ "non-ip"))

rnf_malprov

table(rnf_malprov$ip, rnf_malprov$prov)
frq(rnf_malprov$ip) #sjmisc


rnf_malprov

levels(rnf_malprov$prov)

# rnf_malprov1 <- rnf_malprov %>% 
#   
#   gather(key = subpop , value = rate, c(mal.cases, rainfallr)) %>% 
#   
  mutate(ip = factor(ip),
         subpop = factor(subpop))

levels(rnf_malprov1$ip)
# levels(rnf_malprov1$subpop)

rnf_malprov

st.pauls7 <- rnf_malprov %>%
  select(1,2,4) %>%
  na.omit()

st.pauls7
ggcorr(st.pauls7[,-1], method = c("pairwise", "pearson")) 

# ggpairs(rnf_malprov, columns = c(2,4), aes(color=prov, alpha=0.5)) + 
#   scale_x_continuous(labels=comma) +
# scale_color_manual(values=c(usaid_palette6, zamGreen, light_blue, light_grey, zamOrange))


scalefactor <- max(rnf_malprov$mal.cases) / max(rnf_malprov$rainfall)

# ggplot(rnf_malprov1, aes(x = mnthyr, y = rate, group = subpop, colour = subpop)) +
ggplot(rnf_malprov,aes(x = mnthyr))+
  #geom_line(alpha=.6, size=.4) +
  # geom_point(alpha=.6, size=.4) + 
  # stat_smooth(method = "loess", size = .6, se=F) +
  geom_smooth(aes(y=mal.cases, colour="mal.cases"), method="lm", size = .4, se=F) +
  #geom_point(aes(y=mal.cases, colour="mal.cases"),alpha=.6, size=.2, colour=usaid_red) +
  geom_smooth(aes(y=rainfall*scalefactor, colour="rainfall"), method="lm", size = .6, se=F) +
  #geom_point(aes(y=rainfall*scalefactor, colour="rainfall"),alpha=.6, size=.4) +
  scale_y_continuous(name ="Confirmed Malaria Cases", labels=comma,
                     limits=c(0,150000),
                     breaks = c(0,50000,100000,150000),
                     sec.axis=sec_axis(trans = ~./scalefactor, name = "Rainfall (mm)")) +
  labs(x ="", y="",
       caption = "Data Source: \nWFP - Rainfall \nHMIS - Malaria Cases",
       title="Linear trends for Provincial confirmed Malaria cases \n and amount of rainfall received per month, 2014-2022") +
  facet_wrap(~prov) + faceted +
  theme(axis.line.y.right = element_line(color = usaid_blue),
        axis.ticks.y.right = element_line(color = usaid_blue),
        axis.text.y.right = element_text(color = usaid_blue),
        axis.title.y.right = element_text(color = usaid_blue)) +
  basey +
  scale_colour_manual(values = c("mal.cases"=usaid_red,"rainfall"=usaid_blue),labels = c("Confirmed Malaria Cases", "Rainfall")) +
  plot_layout(guides = "collect")

# rnf2 <- ggplot(rnf_malprov,aes(x = mnthyr))+
#   #geom_line(alpha=.6, size=.4) +
#   # geom_point(alpha=.6, size=.4) + 
#   # stat_smooth(method = "loess", size = .6, se=F) +
#   geom_smooth(aes(y=mal.cases, colour="mal.cases"), method="loess", size = .4, se=F) +
#   #geom_point(aes(y=mal.cases, colour="mal.cases"),alpha=.6, size=.2, colour=usaid_red) +
#   geom_smooth(aes(y=rainfall*scalefactor, colour="rainfall"), method="loess", size = .6, se=F) +
#   #geom_point(aes(y=rainfall*scalefactor, colour="rainfall"),alpha=.6, size=.4) +
#   scale_y_continuous(name ="Confirmed Malaria Cases", labels=comma,
#                      limits=c(0,150000),
#                      breaks = c(0,50000,100000,150000),
#                      sec.axis=sec_axis(trans = ~./scalefactor, name = "Rainfall (mm)")) +
#   labs(x ="", y="",
#        caption = "Data Source: \nWFP - Rainfall \nHMIS - Malaria Cases",
#        title="Statistical trends for Provincial confirmed Malaria cases \n and amount of rainfall received per month, 2014-2022") +
#   facet_wrap(~prov) + faceted +
#   theme(axis.line.y.right = element_line(color = usaid_blue),
#         axis.ticks.y.right = element_line(color = usaid_blue),
#         axis.text.y.right = element_text(color = usaid_blue),
#         axis.title.y.right = element_text(color = usaid_blue)) +
#   baseC +
#   scale_colour_manual(values = c("mal.cases"=usaid_red,"rainfall"=usaid_blue),labels = c("Confirmed Malaria Cases", "Rainfall")) +
#   plot_layout(guides = "collect")
# 
# plot_grid(rnf1, rnf2, nrows = 1, ncol = 2) + plot_layout(guides = "collect")
 

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/Provincial Malaria and Rainfall Linear.png",
       device="png",
       type="cairo",
       height = 8.5,
       width = 15)

#'*Luapula Province*
rnf_malprov <- read_xlsx("data/Malaria/Provincial rainfall.xlsx")
names(rnf_malprov)
rnf_malprov

rnf_malprov$mnthyr <- as.Date(rnf_malprov$mnthyr)

rnf_malprov



rnf_malprov <- rnf_malprov %>%
  rename(prov = 1,
         mal.cases = 2,
         mnthyr = 3,
         rainfall = 4)

rnf_malprov


rnf_malprov1 <- rnf_malprov %>% 
  gather(key = subpop , value = rate, c(mal.cases))

rnf_malprov1


# rnf_malprov2 <- rnf_malprov1 %>%
#   select(1, 2) %>%
#   na.omit()

rnf_malprov1

rnf_malprov2 <- filter(rnf_malprov1, prov  == 'Luapula')

rnf_malprov2

scalefactor <- max(rnf_malprov$mal.cases) / max(rnf_malprov$rainfall)

ggplot(rnf_malprov2, aes(x = mnthyr, y = rate, group = subpop, colour = subpop)) +
#ggplot(rnf_malprov,aes(x = mnthyr))+
  #geom_line(alpha=.6, size=.4) +
  # geom_point(alpha=.6, size=.4) + 
  stat_smooth(method = "loess", size = 1, se=F) + geom_point(size=1, colour=usaid_red) +
  #geom_smooth(aes(y=mal.cases, colour="mal.cases"), method="lm", size = .4, se=F) +
  #geom_point(aes(y=mal.cases, colour="mal.cases"),alpha=.6, size=.2, colour=usaid_red) +
  geom_smooth(aes(y=rainfall*scalefactor, colour="rainfall"), method=loess, size = 1, se=F) +
  geom_point(aes(y=rainfall*scalefactor, colour="rainfall"),alpha=.6, size=1) +
  scale_x_date(date_labels="%Y",date_breaks = "1 year") +
  scale_y_continuous(name ="Confirmed Malaria Cases", labels=comma,
                     limits=c(0,150000),
                     breaks = c(0,50000,100000,150000),
                     sec.axis=sec_axis(trans = ~./scalefactor, name = "Rainfall (mm)")) +
  labs(x ="", y="",
       caption = "Data Source: \nWFP - Rainfall \nHMIS - Malaria Cases",
       title="Luapula Province confirmed Malaria cases \n and amount of rainfall received per month, 2014-2022") +
  facet_wrap(~prov) + faceted +
  theme(axis.line.y.right = element_line(color = usaid_blue),
        axis.ticks.y.right = element_line(color = usaid_blue),
        axis.text.y.right = element_text(color = usaid_blue),
        axis.title.y.right = element_text(color = usaid_blue)) +
  basey +
  scale_colour_manual(values = c("mal.cases"=usaid_red,"rainfall"=usaid_blue),labels = c("Confirmed Malaria Cases", "Rainfall")) +
  plot_layout(guides = "collect")

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/Province Luapula.png",
       device="png",
       type="cairo",
       height = 6.5,
       width = 11)


#'*Malaria 2022 and rainfall*

ip <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/rainfallmalariatoday.xls")

ip
ip$periodname <- as.Date(ip$periodname)  

ip1 <- ip[order(ip$periodname), ]

ip2 <- ip1 %>%
  rename(mth=1,
         cases=2,
         rnfl=3)

ip2

#plot

ot_plt <- ggplot(ip2,aes(x=mth))+
  
  geom_smooth(aes(y=cases, fill="case"), size=1, colour=usaid_red, se=T) +
  geom_point(aes(y=cases, fill="case"), size=1, colour=usaid_red, se=T) +
  geom_smooth(aes(y=rnfl*300, fill="rnfl"), size=1.5, alpha=0.8, se=F, colour=light_blue) + 
  # geom_point(aes(y=Malaria_Cases), size=3, color="#BA0C2F")+
  scale_x_date(date_labels="%b %y",date_breaks="5 month")+
  scale_y_continuous(labels=comma, sec.axis=sec_axis(trans = ~ .*0.007, name = "Rainfall (mm)"))+
  labs(fill="Legend:", caption="Data Source: HMIS, WFP - Rainfall",title="Confirmed Malaria Cases and Rainfall Trends in Nchelenge, 2014-2022", x="", y="Number of Malaria Cases") + 
  scale_fill_manual(name ="",
                    values = c(usaid_red, light_blue),
                    labels= c("Confirmed Malaria Cases", "Rainfall")) + basey

ot_plt

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/cases and rainfall.png",
       device="png",
       type="cairo",
       height = 5.5,
       width = 13)




#'*Death and Artesunate stockouts*

stcks.out <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/stockstoday.xls")

stcks.out

stcks.out$ReportingPeriod <- as.Date(stcks.out$ReportingPeriod)  

# stcks.out1 <- stcks.out[order(stcks.out$ReportingMonth), ]

# stcks.out <- melt(stcks.out, id = "ReportingPeriod")

stcks.out

stcks.out1 <- stcks.out %>%
  rename(prdct =1,
         mnth = 2,
         stckOt = 3,
         dths=4
         )
  
  stcks.out1 <- stcks.out1 %>% 
  gather(key = subpop , value = rate, c(stckOt,dths ))
  
  stcks.out1


id_plt <- ggplot(stcks.out1, aes(x=mnth, y = rate, group = subpop  , colour = subpop)) +
  geom_smooth(method = loess, size = .6, se=F) +
  geom_point(size=.3) +
  #geom_line(alpha=.6, size=.6, colour=usaid_blue) + 
  facet_wrap(~prdct) + 
  faceted +
  scale_x_date(date_labels="%Y", date_breaks = "1 year") +
  scale_y_continuous(limits = c(0,28),
                     breaks = c(0, 7,14, 21, 28)) +
  labs(x ="", y="", title="Stockouts of drugs used in treating severe Malaria show no sign of correlation with Malaria deaths, \n excepts for Artesunate stockouts in 2021", 
       caption = "Data Source: \n HMIS - Malaria Deaths \n PAMO")  +
  scale_colour_manual(name ="",
                      values = c(usaid_red,usaid_blue),
                      labels= c("Malaria deaths during stockouts", "Stockout days")) + basey


id_plt + plot_layout(guides = "collect")

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/Deaths stockouts.png",
       device="png",
       type="cairo",
       height = 5.5,
       width = 11)


#'*PT ITNS*
source("scripts/r prep2.r")

ipt.itn <- read_xlsx("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/IPTITNPreg.xlsx")
ipt.itn  <- ipt.itn  %>%
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


names(ipt.itn)

ipt.itn1 <- ipt.itn %>%
  select(2, 3, 4, 5,9, 11) %>%
  na.omit()

ipt.itn1

ipt.itn2 <- ipt.itn1 %>%
  rename(iptp1p = 1,
         iptp3p  = 2,
         itnp=3,
         mal.preg=4,
         yr=5,
         mth=6)

ipt.itn2

ipt.itn3 <- ipt.itn2 %>% 
  gather(key = subpop , value = rate, c(iptp1p,iptp3p,itnp))

ipt.itn3

scalefactor <- max(ipt.itn2$itnp) / max(ipt.itn2$mal.preg)

ipt.itn_plt <- ggplot(ipt.itn3,aes(x=mth, y=rate, fill=subpop))+
  geom_bar(color="#CFCDC9",position ='dodge', stat = "identity") +
  scale_x_date(date_labels="%b-%y",date_breaks="6 months") + scale_fill_manual(values = c(usaid_palette))
ipt.itn_plt

ipt.itn_plt + geom_smooth(ipt.itn2,mapping=aes(x=mth, y=mal.preg*scalefactor, fill="mal.preg"), method=loess, size = .6, se=F, colour=zamOrange) +
  scale_y_continuous(name ="ITNs & IPT Proportions",
                     sec.axis=sec_axis(trans = ~./scalefactor, name = "Malaria in pregnancy")) +
  labs(fill="Legend:", caption= "Data Source: HMIS", 
       title="Malaria in pregnancy, IPT and ITN provided to pregnant woman at 1st ANC coverage visit", 
       x="", y="ITNs & IPT Proportions") +
  scale_fill_manual(values = c(usaid_palette),
                    labels=c("IPTp1", "IPTp3", "ITNs", "Malaria in preganancy")) + basey

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/iptitn.png",
       device="png",
       type="cairo",
       height = 7,
       width = 13)




###OTTS

library(readxl)
library(tidyverse)
ot <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/OTSS_ALL.xls")

ot

ot$Periods <- as.Date(ot$Periods)  

ot1 <- ot[order(ot$Periods), ]

ot1
#plot
ot_plt <- ggplot(ot1, fill=positive) +
  geom_smooth(aes(x=Periods, y=Adherence_to_Negative_Test_Results),method = 'loess', color="#205493", size=1) + 
  geom_point(aes(x=Periods, y=Adherence_to_Negative_Test_Results),method = 'loess', size=2,  color="#205493") +
  geom_smooth(aes(x=Periods, y=Adherence_to_Positive_Test_Results),method = 'loess', color="#BA0C2F", size=1) +
  geom_point(aes(x=Periods, y=Adherence_to_Positive_Test_Results),method = 'loess', size=2,  color="#BA0C2F")+
  geom_smooth(aes(x=Periods, y=Testing_Prior_to_Treatment_Score),method = 'loess', colour="#F5B041",size=1) +
  geom_point(aes(x=Periods, y=Testing_Prior_to_Treatment_Score),method = 'loess', size=2,  color="#F5B041")+
  geom_smooth(aes(x=Periods, y=Clinical_Observation_Overall),method = 'loess', size=1.5,  color="#C5E2F7",lty="longdash") +
  geom_smooth(aes(x=Periods, y=RDT100_RDT_Observation),method = 'loess', size=1.5, color="orange", lty="longdash") +
  geom_smooth(aes(x=Periods, y=Overall_Laboratory_Score),method = 'loess', color="#56E78E", size=1.5) + 
  # scale_color_manual(values=c("#002A6C", "#CFCDC9", "#A7C6ED", "#A7C6ED", "#A7C6ED", "#A7C6ED"))+
  labs(fill="Legend:", title="RDT confirmed overlayed with Malaria diagnostic positivity rate - Nchelenge",
       x="Period",
       y="Diagnostic Positivity(%)") + base
ot_plt

#'*RDT and positivity rate*
source("scripts/r prep2.r")
rdt <- read_xlsx("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/rdt.xlsx")


rdt$period <- as.Date(rdt$period)  

rdt1 <- rdt[order(rdt$period), ]

rdt1

rdt2 <- rdt1 %>%
  select(1, 2, 4,5) %>%
  na.omit()

rdt2

rdt3 <- rdt2 %>%
  rename(mnt=1,
         rdt.cases=2,
         pstivity=3,
         clcl.cases=4)

rdt3

# rdt4 <- rdt3 %>% 
#   gather(key = subpop , value = rate, c(rdt.cases,clcl.cases))
# 
# rdt4

rd_plt <- ggplot(rdt3) +
  geom_smooth(data=rdt3, aes(x=mnt, y=rdt.cases, fill="rdt.cases"), method = loess, size = .6, se=F, color=usaid_blue) +
  geom_point(data=rdt3, aes(x=mnt, y=rdt.cases, fill="rdt.cases"),size=.3, color=usaid_blue) +
  geom_smooth(data=rdt3, aes(x=mnt, y=clcl.cases, fill="clcl.cases"), method = loess, size = .6, se=F, color=medium_grey) +
  geom_point(data=rdt3, aes(x=mnt, y=clcl.cases, fill="clcl.cases"),size=.3, color=medium_grey) +
  geom_smooth(data=rdt3, aes(x=mnt, y=pstivity*60, fill="pstivity"), method = loess, size = .6, se=F, color=usaid_red) +
  geom_point(data=rdt3, aes(x=mnt, y=pstivity*60, fill="pstivity"),size=.3, color=usaid_red) +
  scale_x_date(date_labels="%b %y",date_breaks = "4 months") +
  scale_y_continuous(labels=comma, sec.axis=sec_axis(trans = ~ .*0.0002, labels=percent, name = "RDT Diagnostic Positivity")) +
  labs(x="",y="",title="RDT Malaria tested cases positivity rates has been reducing since October 2020",caption= "Data Source: HMIS - Malaria Clinical Cases \n PAMO - RDT ") +
  scale_fill_manual(name ="",values=c(usaid_blue, usaid_red,medium_grey), labels = c("RDT Positivity rate","RDT Tested Cases","Malaria Clinical Cases")) + basey

rd_plt

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/rdt.png",
       device="png",
       type="cairo",
       height = 6,
       width = 12)



##indoor resting density
source("scripts/r prep2.r")
insecty <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Insecticidetype_malariacases.xls")


# ggplot(dat1, aes(monthyr, Malaria_Confirmed_Cases)) + geom_line()
#insecty <- melt(data = indens, id.vars = c("mnth","gambia", "Site","funestus"), variable.name = "mnth")
insecty$mont <- as.Date(insecty$mont)  

insecty1 <- insecty[order(insecty$mont), ]

insecty1

# insecty$mont <- as.Date(insecty$mont) origin="2014"
# insect1 <- insecty[order(insecty$mont), ]
# # 
# indens1

#Calculation sd
# sd(indens1$funestus)

id_plt <- ggplot(insecty1) + 
  geom_bar(aes(x=mont, y=Pop.Visited, fill=Insecticide), stat="identity", position = "dodge") +
  scale_fill_manual(values=c("Actelic"="#002F6C","Fludora"="#F5B041", "Sumishield"="#BA0C2F", "Malaria Cases"="#6C6463")) +
  geom_smooth(aes(x=mont, y=Malaria.Confirmed.Cases/120, fill="Malaria Cases") ,color="#6C6463", size=1, se=F) + 
  geom_point(aes(x=mont, y=Malaria.Confirmed.Cases/1200), stat="identity",color="#6C6463",size=3) +
  scale_x_date(date_labels="%Y",date_breaks="1 year", limits = NULL)+
  scale_y_continuous(labels=comma, sec.axis = sec_axis(trans = ~ .*1200, labels=comma, name = "Malaria cases"))+
  labs(fill="Legend:", title="Malaria Cases and Insecticide Types Used Over Time - Nchelenge",
       x=" Period",
       y="Coverage(%)") + base
# theme(legend.key=element_blank(), legend.title=element_blank(),
#       legend.box="horizontal",legend.position = "bottom")

mallbs <- c("97,227",
            "88,475",
            "55,123",
            "71,173",
            "66,514",
            "47,015",
            "137,986",
            "109,894")

id_plt

# id_plt + geom_label(aes(x=mont, y=Malaria/1200),
#                     label=mallbs, color = c("#002A6C","#002A6C","#002A6C","#002A6C","#002A6C", "#CFCDC9","#CFCDC9", "#A7C6ED"), fontface = "bold", hjust=0.5, vjust = 1.6)

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Malaria & Insecticide withot labels.png",
       device="png",
       type="cairo",
       height = 7,
       width = 12)




#'*indoor resting density*
libra
indens <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/inddensity.xls")

indens

indens <- melt(data = indens, id.vars = c("mnth","gambiae", "Site","funestus", "Rainfall"), variable.name = "mnth")

indens

indens$mnth <- as.Date(indens$mnth)  

indens1 <- indens[order(indens$mnth), ]

indens1
scalefactor <- max(indens1$funestus) / max(indens1$Rainfall)

id_plt <- ggplot(indens1, aes(x=mnth, y=funestus, fill = Site)) +
  geom_bar(stat="identity", position = "dodge") + 
  #geom_smooth( aes(x=mnth, y=Rainfall, fill="Rainfall"), method=loess, width=0.4, colour="orange", alpha=0.9, size=0.9, se=F) +
  #geom_point(indens1, mapping=aes(x=mnth, y=Rainfall/1), width=0.4, fill="orange",color="orange", alpha=0.9, size=1.5) +
  #scale_y_continuous(sec.axis = sec_axis(trans = ~ .*1, labels=comma, name = "Rainfall(mm)"))+
  scale_x_date(date_labels="%b %y",date_breaks="3 months") + 
  scale_fill_manual(values=c("orange",light_blue,"#BA0C2F")) +
  labs(fill="Legend:", caption="Data Source: \n Vector Link - Data only available starting from 2019",title="The Indoor Resting Density An.funestus S.I \n tends to rise each year from August to October begining 2019",
       x="",
       y="No. of vectors per house per night") + base

id_plt + geom_line( aes(x=mnth, y=Rainfall*scalefactor, fill="Rainfall"), method=loess, width=0.4, colour=light_blue, alpha=0.8, size=0.9, se=F) + 
  geom_point( aes(x=mnth, y=Rainfall*scalefactor, fill="Rainfall"), colour=light_blue, alpha=0.5, size=2.5)+
  scale_y_continuous(sec.axis = sec_axis(trans = ~ ./scalefactor, labels=comma, name = "Rainfall(mm)")) +
  scale_fill_manual(values=c(zamOrange,light_blue,usaid_blue),
                    labels=c("Manchene-Control Site", "Rainfall", "Shikapande-Intervention"))

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/resting density an An.funestus.png",
       device="png",
       type="cairo",
       height = 6,
       width = 12)


##Animated trends Malaria
library(gganimate)

iptm <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/ipt.xls")


iptm_data$period <- as.Date(as.character(iptm$period), format = "%Y")

iptm_long <- melt(iptm_data, id = "period")
iptm_long

# Plot
iptm_plt <- ggplot(iptm_long, aes(x=period, y=value,  color=variable)) +
  geom_line(size=1, alpha=0.5) +
  geom_point(size=3) +
  # scale_color_viridis(discrete = TRUE) +
  scale_x_date(date_labels="%Y",date_breaks="1 year") +
  scale_color_manual(values=c("#002A6C","#C2113A", "#EF7D00"))+
  scale_y_continuous(labels=comma) +
  labs(color="Legend:", title="Nchelenge Confirmed Cases",
       x="",
       y="cases") +
  transition_reveal(period) + base
animate(iptm_plt, height = 800, width =1000)

# #anim_save("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/smooth-animation-Severe-Malaria.gif",
#           device="gif",
#           type="cairo",
#           height = 7,
#           width = 15)

anim_save("viz/Malaria/deleteme.gif",
          plot = iptm_plt,
          device="gif",
          type="cairo",
          height=6,
          width=13)


##Malaria In Pregnancy

iptm <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/ipt.xls")

iptm

iptm$period <- as.Date(as.character(iptm$period), format = "%Y")      #Date type in R is always a combination of year, month and day (not necessarily in this order). You cannot have a Date type with only the year

class(period)

sapply(iptm_data, mode)

str(iptm_data)

iptm_long <- melt(iptm, id = "period")

iptm_long


gfg_plot <- ggplot(iptm_long,aes(x = period,y = value, fill = variable)) +  geom_line(size=1, alpha=0.5) + geom_point(size=3)+
  #scale_x_continuous(date_breaks(width="4 months")) +
  scale_color_manual(values=c("#002A6C","#C2113A", "#EF7D00"))+
  scale_y_continuous(labels=comma) +
  labs(color="Legend:", title="Nchelenge Confirmed Cases",
       x="",
       y="cases") +
  base
gfg_plot

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Malaria in pregnanc2y.png",
       device="png",
       type="cairo",
       height = 7,
       width = 12)



#'*Severe Malaria and Deaths*
source("scripts/r prep2.r")
iccm <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/iccm.xls")
svrNch <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge(monthly)_2014-2022.xls")
svrNch  <- svrNch  %>%
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

names(svrNch)

svrNch2 <- svrNch %>%
  select(13, 19, 20,29) %>%
  na.omit()

svrNch2

svrNch2 <- svrNch2 %>%
  rename(no.dths=1,
         ipdA5=2,
         ipdU5=3,
         mth=4) %>%
  
  mutate(Tsvere = ipdA5+ipdU5)

svrNch2

svrNch3 <- svrNch2 %>%
  select(1,4,5) %>%
  na.omit()

svrNch3

# svrNch3 <- svrNch3 %>%
#   gather(key = subpop , value = rate, c(Tsvere,no.dths))

svrNch3

iccm$start <- as.Date(iccm$start) 
iccm$end <- as.Date(iccm$end)

start <- as.Date(NULL)
end <- as.Date(NULL)


svr <- ggplot(svrNch3) +
  geom_area(data=svrNch3, aes(x=mth, y=Tsvere, fill ="Tsvere"), alpha=.3, position = position_dodge()) +
  geom_area(data=svrNch3, aes(x=mth, y=no.dths, fill ="no.dths"), alpha=.9, position = position_dodge()) +
  geom_rect(data=iccm, aes(NULL, NULL, xmin=start, xmax=end, fill=campaign),
            ymin=0,ymax=600, size=0.6, alpha=0.2, lty="dotted") +
  labs(fill="Legend:", title="Severe Malaria Cases have remainined relatively high, while the Malaria deaths remained low \n , and there was a huge spike in Severe Malaria in March 2020",
       x="",
       y="Cases", caption = "Data Source: HMIS \n Note: The spike in the Severe Malaria cases is suspected to have have been due to data quality issues") +
  scale_y_continuous(breaks = c(0, 130,260,390,530)) +
  scale_fill_manual(values=c(zamOrange, usaid_red, medium_grey), labels=c("ICCM Campaigns", "Malaria Deaths", "Total Severe Malaria Cases")) + 
  scale_x_date( date_labels="%b %y",date_breaks="4 month", limits = NULL) + basey +
  
  geom_vline(xintercept = c(dt, dt1, dt2) ,color=c("#EF7D00","#198a00ff", "#198a00ff") ,lty=c("solid","dotted", "dotted") ,size=c(2,1,1), alpha=1)+
  annotate("text", x = dt, y = 0, label = substitute(paste(bold('Integrated community case management: Oct'))), size=4, angle=90, hjust =-0.3, vjust=-1, color="#EF7D00")+
  annotate("text", x = dt1, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns: Oct'))), size=4, angle=90, hjust =-1, vjust=-0.7, color="#198a00ff")+
  annotate("text", x = dt2, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns: Dec'))), size=4, angle=90, hjust =-1, vjust=-0.5, color="#198a00ff")
  


dt <- as.Date("2017-10-01")
dt1 <- as.Date("2018-10-01")
dt2 <- as.Date("2020-12-01")

svr
ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/Severe & Death Cases2.png",
         device="png",
         type="cairo",
         height=7.6,
         width=14)



##Malaria Cases -5 & 5+

source("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Scripts/r prep.R")
source("scripts/r prep.r")
library(gganimate)
library(areaplot)
ani <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/insecticideinc.xls")
mal5 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/malariacasesfives.xls")

# lapply(mal5, na.omit)
mal5 <- melt(mal5[, c(1, 2,3)], id = 'peri')


#Date conversion
mal5$peri <- as.Date(mal5$peri)

sapply(mal5, mode)

mal5

ani$Start <- as.Date(ani$Start) 
ani$End <- as.Date(ani$End) 

cm1 <- as.Date("2020-10-01")
cm2 <- as.Date("2017-10-01")
cm3 <- as.Date("2020-12-01")
cm4 <- as.Date("2018-10-01")
cm5 <- as.Date("2016-04-01")
cm7 <- as.Date("2016-09-01")
cm8 <- as.Date("2017-09-01")
cm9 <- as.Date("2018-09-01")
cm10 <- as.Date("2019-09-01")

Start <- as.Date(NULL)
End <- as.Date(NULL)



mal5plt <- ggplot(mal5,aes(x=peri, y=value, fill = variable), alpha=0.2) +
  geom_area(alpha=0.6, position = position_dodge()) +
  geom_rect(data=ani1, aes(NULL, NULL, xmin=Start, xmax=End, fill=Inserticide),
            ymin=0,ymax=10000, colour="#CFCDC9", size=0.6, alpha=0.6, lty="twodash") +
  geom_vline(xintercept = c(cm2, cm3,cm4,cm5),color=c("#198a00ff","#198a00ff","#198a00ff","#198a00ff"),
             lty=c("solid", "solid","solid", "solid") ,size=3, alpha=0.5)+
  scale_fill_manual(values=c("Actelic Insecticide"="#002A6C", "Fludora Insecticide"="#F5B041", 
                             "Sumishield Insecticide"="#8C8985","Under 5yrs"= "#BA0C2F","Above 5yrs"="#A7C6ED")) +
  scale_y_continuous(labels=comma) +
  scale_x_date(date_labels="%b %Y",date_breaks="6 months")+
  labs(fill="Legend:", title="Malaria Cases by Age groups with all Interventions",
       x="",
       y="Cases") + base +
  # + transition_reveal(year) + base
  # animate(mal5plt, height = 800, width =1000)
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  
           angle=90, hjust =-12, vjust=-1.4) +
  annotate("text", x = cm7, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm8, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", 
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm9, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm10, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", 
           angle=90, hjust =-12, vjust=-0.3) +
  annotate("text", x = cm2, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns:Oct'))), size=4, 
           angle=90, hjust =-1.1, vjust=1.5) +
  annotate("text", x = cm3, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns: Dec'))), size=4, 
           angle=90, hjust =-1.1, vjust=-0.5)+
  annotate("text", x = cm4, y = 0, label = substitute(paste(bold('Integrated community case management'))), size=4, 
           angle=90, hjust =-0.8, vjust=1.5) +
  annotate("text", x = cm5, y = 0, label = substitute(paste(bold('Behaviour Change Communication'))), size=4, 
           angle=90, hjust =-1, vjust=-0.5)


mal5plt

# anim_save("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/smooth-animation-Malaria-age-group.gif",
#           device="gif",
#           type="cairo",
#           height = 800,
#           width=1000)

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed By Age group.png",
       device="png",
       type="cairo",
       height=7,
       width=13)

#'*Malaria Incidence Nchelenge*
source("scripts/r prep2.r")
Mal.mnt.Nch <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge(monthly)_2014-2022.xls")
Mal.mnt.Nch  <- Mal.mnt.Nch  %>%
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
iccm <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/iccm.xls")
ani <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/insecticideinc.xls")
malin <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Malariaincidence.xls")

malin$year <- as.Date(malin$year)

malin_data <- malin

sapply(malin, mode)
malin

ani$Start <- as.Date(ani$Start) 
ani$End <- as.Date(ani$End) 

ani1 <- ani[order(ani$Start), ]
ani1 <- ani[order(ani$End), ]


# cm <- as.Date("2014-10-01")
cm1 <- as.Date("2020-10-01")
cm2 <- as.Date("2017-10-01")
cm3 <- as.Date("2020-12-01")
cm4 <- as.Date("2017-11-01")
cm5 <- as.Date("2016-04-01")
# cm6 <- as.Date("2015-10-01")
cm7 <- as.Date("2016-09-01")
cm8 <- as.Date("2017-09-01")
cm9 <- as.Date("2018-09-01")
cm10 <- as.Date("2019-09-01")
cm11 <- as.Date("2021-10-01")

Start <- as.Date(NULL)
End <- as.Date(NULL)

iccm$start <- as.Date(iccm$start) 
iccm$end <- as.Date(iccm$end)

start <- as.Date(NULL)
end <- as.Date(NULL)

Mal.mnt.Nch1 <- Mal.mnt.Nch %>% select(3, 15, 23, 29)
Mal.mnt.Nch1

names(Mal.mnt.Nch1)
Mal.mnt.Nch2 <- Mal.mnt.Nch1 %>%
  rename(mal.case=1,
         mal.clnc=2,
         rnfl=3,
         mnthy=4)

colnames(Mal.mnt.Nch2)

malin %>% 
  convert(int(Incidence_all_ages, Incidence_rate_under5, Incidence_rate_above5))

malin

inc <- ggplot(malin,aes(x=year))+
  # geom_line(aes(y=Incidence_rate_under5, color="Incidence rate under5"), size=1)+
  # geom_point(aes(y=Incidence_rate_under5, color="Incidence rate under5"), size=3)+
  geom_smooth(aes(y=Incidence_all_ages), method=loess,color="#CFCDC9", size=1, alpha=1, se=F)+
  # geom_line(data=Mal.mnt.Nch2, aes(y=rnfl/0.004), method = loess,color=light_blue, alpha=0.9, size=1, se=F) +
  # geom_point(data=Mal.mnt.Nch2, aes(y=rnfl/0.004), method = loess,color=light_blue, alpha=9, size=3, se=F)+
  #geom_point(aes(y=Incidence_all_ages, color="Incidence all ages"), size=3)+
  # geom_line(aes(y=Incidence_rate_above5, color="Incidence rate above5"), size=1)+
  # geom_point(aes(y=Incidence_rate_above5, color="Incidence rate above5"), size=3)+
  geom_rect(data=ani1, aes(NULL, NULL, xmin=Start, xmax=End, fill=Inserticide),
            ymin=0,ymax=15000, colour="#CFCDC9", size=0.6, alpha=0.6, lty="twodash") +
  geom_rect(data=iccm, aes(NULL, NULL, xmin=start, xmax=end),
            ymin=0,ymax=25000, size=0.6, fill=zamOrange, alpha=0.2, lty="twodash") +
  geom_vline(xintercept = c(cm2, cm3,cm5),color=c("#198a00ff","#198a00ff",light_blue),
             lty=c("solid", "solid", "solid") ,size=3, alpha=0.5) +
  scale_y_continuous(labels=comma,sec.axis = sec_axis(trans = ~ .*0.004, labels=comma, name = "Rainfall(mm)"))+
  scale_x_date(date_labels="%b %Y",date_breaks="6 months")+
  labs(fill="Legend", caption="Data Source: HMIS, Vector Link, WFP- Rainfall",title = "Malaria Incidence Rates & All Interventions" , x="Months", y="Malaria Incidence Rate(%)") +
  scale_fill_manual(values = c("Actelic Insecticide"="#002A6C", "Fludora Insecticide"=rich_black, 
                               "Sumishield Insecticide"="#BA0C2F", "Incidence all ages"= "#CFCDC9", "ICCM Campaigns"= zamOrange)) +
  # scale_color_manual(values = c("Incidence rate under5"="#BA0C2F", "Incidence all ages"="#205493", 
  #                               "Incidence rate above5"="#EF7D00"))+ 
  base +
  # transition_reveal(year)
  # annotate("text", x = cm, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="black",  
           angle=90, hjust =-12, vjust=-1.4) +
  # annotate("text", x = cm6, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm7, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="black",  
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm8, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="black", 
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm9, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="black",  
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm10, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="black", 
           angle=90, hjust =-12, vjust=-0.3) +
  annotate("text", x = cm11, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="black",  
           angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm2, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns:Oct'))), size=3.5, 
           angle=90, hjust =-1.1, vjust=-0.25) +
  annotate("text", x = cm3, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns: Dec'))), size=4, 
           angle=90, hjust =-1.1, vjust=1.5)+
  #annotate("text", x = cm4, y = 0, label = substitute(paste(bold('Integrated community case management'))), size=4, 
           #angle=90, hjust =-0.8, vjust=1.5) +
  annotate("text", x = cm5, y = 0, label = substitute(paste(bold('Behaviour Change Communication'))), size=4, 
           angle=90, hjust =-1, vjust=-0.5)


inc
ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/incidenceModified.png",
       plot = inc,
       device="png",
       type="cairo",
       height=7.5,
       width=13)

# animate(inc, height = 800, width =1000)
# # 
# #Save Animation
# anim_save("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/smooth-animation-Severe-Malaria.gif",
#           device="gif",
#           type="cairo",
#           height = 700,
#           width = 1000)

##Save Static image
ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.2022/Nchelenge Malaria Incidence Rates All ages.png",
       device="png",
       type="cairo",
       height = 7,
       width = 12)




#'*Heatmap Luapula Malaria Deaths By Districts*
library(pheatmap)
#ht <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/districtdeathsluapula.xls")
dt1 <- "C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/districtdeathsluapula.csv"
ht <- read.csv(dt1, row.names = 1)

#d3heatmap(ht, scale = "row", dendrogram = "none",colors=usaid_palette6) #using d3heatmap

htplt <-pheatmap(ht,
                 treeheight_row=0, 
                 treeheight_col=0,  
                 cutree_rows = 3,
                 cluster_cols=FALSE,
                 main ="In 2020, Nchelenge had the highest number of malaria deaths, followed by Mansa",
                 plot.title = element_text(size = 15, family="Gill Sans Mt"),
                 axis.title=element_text(size=14, family="Gill Sans Mt"),
                 axis.text=element_text(size=14, family="Gill Sans Mt"),
                 axis.ticks = element_blank(),
                 caption="Data Source: HMIS",
                 color = colorRampPalette(brewer.pal(8,"Blues"))(400))

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/2heatmap Malaria Deaths1.png",
       plot = htplt,
       device="png",
       type="cairo",
       height=5.5,
       width=10)


ggsave("viz/Malaria/heatmap Malaria Deaths.png",
       plot = htplt,
       device="png",
       type="cairo",
       height=6,
       width=13)


#'*FACETED MALARIA Deaths BY DSITRICT*
dist.deaths <- read_xlsx("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/deaths_facets.xlsx")
dist.deaths  <- dist.deaths  %>%
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

sum(dist.deaths$month_chr!=dist.deaths$month) # expecting 0 if vars same

dist.deaths$periodname <- as.Date(dist.deaths$periodname)

dist.deaths

names(dist.deaths)
dist.deaths1 <- dist.deaths %>%
  select(2, 3,9) %>%
  na.omit()

dist.deaths1

dist.deaths2 <- dist.deaths1 %>%
  rename(dst=1,
         dths=2,
         mth=3) %>%
  na.omit()


ggplot(dist.deaths2, aes(mth,dths, colour=usaid_blue)) + 
  geom_smooth(method = loess, size = .6, se=FALSE) +
  geom_point(size=.2) +
  #geom_line(alpha=.6, size=.6, colour=usaid_blue) + 
  facet_wrap(~dst) + 
  faceted +
  scale_x_date(date_labels="%Y", date_breaks = "1 year") +
  scale_y_continuous(limits = c(0,50),
                     breaks = c(0, 12, 26, 38, 50)) +
  labs(x ="", y="", caption = "Data Source: HMIS", title="In the past two years, the number of Malaria deaths in Nchelenge has increased starting in 2019 \n and declined at beginning of 2021")  +
  scale_colour_manual(name ="",
                     values = usaid_red) + baseC

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/deaths faceted.png",
       device="png",
       type="cairo",
       height=8,
       width=18)



##Malaria Deaths trendline
source("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Scripts/r prep.R")
source("scripts/r prep2.r")
library(gganimate)


dth <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/deaths.xls")
#dth <- melt(dth[, c(1, 2,3)], id.vars = 'Year')
dth$Year <- as.Date(dth$Year)

sapply(dth, mode)
dth

ggplot(dth,aes(x=Year))+
  geom_line(aes(y=Death_above_5, color="Death_above_5"))+
  geom_point(aes(y=Death_above_5, color="Death_above_5"))+
  geom_line(aes(y=Death_under_5, color="Death_under_5"))+
  geom_point(aes(y=Death_under_5, color="Death_under_5"))+
  scale_x_date(date_labels="%Y-%m",date_breaks="6 months")+
  labs(title="Malaria Deaths",
       x="Months",
       y="cases") + base + 
  transition_reveal(Year)
animate(iptm_plt, height = 800, width =1000)


ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed death11s.png",
       device="png",
       type="cairo",
       height=6,
       width=13)


##Malaria Nchelenge trend line 2014-2021 with campaigns

dat <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge Confirmed Cases.xls")
pmi_data <- dat %>%
  mutate(name2=name)
pmi_data
pmi_data %>%
  ggplot(aes(x=Year, y=Confirmed_Cases,group=name))+
  geom_line( dat=pmi_data %>% dplyr::select(-name), aes(group=name2), color="#BA0C2F", size=1, alpha=0.6) +
  geom_point(aes(color = name, group = name), color="#BA0C2F", size=3, alpha=6 ) +
  geom_vline(xintercept = c(vline1, vline2, vline3, vline4),color=c("#212721","#EF7D00", "#0067B9","#EF7D00") ,lty=c("solid", "solid", "solid", "solid") ,size=c(5,5,5,5), alpha=0.5)+
  annotate("text", x = vline1, y = 0, label = "SBC", size=2, angle=90, hjust =-10) +
  annotate("text", x = vline2, y = 0, label = "Mass ITNS Distribution", size=2, angle=90, hjust =-2)+
  annotate("text", x = vline3, y = 0, label = "ICCM", size=2, angle=90, hjust =-8) +
  annotate("text", x = vline4, y = 0, label = "Mass ITN's Distribution", size=2, angle=90, hjust =-2)+
  scale_x_continuous(breaks=2014:2021) +
  scale_y_continuous(labels=comma) + #faceted
  labs(title="Nchelenge Confirmed Cases",
       x="",
       y="cases") +
  base

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases trendline with IRS.png",
       device="png",
       type="cairo",
       height=4,
       width=7)


#Malaria Cases in Nchelenge as bars 2014-2021

pmi_data %>%
  ggplot(aes(x=Year, y=Confirmed_Cases)) + 
  geom_col(width=.4, fill=usaid_blue, alpha=7) +
  #geom_text(aes(label=Confirmed_Cases), vjust = 1.5, color="white", size=2) +
  scale_x_continuous(breaks=2014:2021) +
  scale_y_continuous(labels=comma) +
  labs(title="Nchelenge Confirmed Cases",
       x="",
       y="Confirmed cases") +
  base


# ggsave("viz/Malaria/Nchelenge confirmed cases bar.png",
#         device="png",
#         type="cairo",
#        height=6,
#         width=10)
ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases bar.png",
       device="png",
       type="cairo",
       height=4,
       width=7)


#'*Malaria Nchelenge Monthly trend line 2014-2021*
source("scripts/r prep2.r")

dat1 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge Confirmed Cases Monthly 2014-2021.xls")

dat1

dat2 <- as.Date(period$dat1)

ggplot(dat1, aes(period, Malaria_Confirmed_Cases)) + geom_line()

monthly_data <- dat1 %>%
  
  geom_line( dat1=monthly_data %>% dplyr::select(-name), aes(group=name2), color="#BA0C2F", size=1, alpha=0.6) +
  geom_point(aes(color = name, group =-name), color="#BA0C2F", size=3, alpha=6 ) +
  geom_vline(xintercept = c(vline1, vline2, vline3, vline4, vline5),color=c("#212721","#EF7D00", "#0067B9","#EF7D00","#198a00ff") ,lty=c("solid", "solid", "solid", "solid", "dotted") ,size=5, alpha=0.5)+
  annotate("text", x = vline1, y = 0, label = "SBC", size=2, angle=90, hjust =-10) +
  annotate("text", x = vline2, y = 0, label = "Mass ITNS Distribution", size=2, angle=90, hjust =-2)+
  annotate("text", x = vline3, y = 0, label = "ICCM", size=2, angle=90, hjust =-8) +
  annotate("text", x = vline4, y = 0, label = "Mass ITN's Distribution", size=2, angle=90, hjust =-2)+
  scale_x_continuous(breaks=2014:2021) +
  scale_y_continuous(labels=comma) + #faceted
  labs(title="Nchelenge Confirmed Cases",
       x="",
       y="Confirmed cases") +
  base

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases trendline with IRS campaigns.png",
       device="png",
       type="cairo",
       height=4,
       width=7)


##########'*Malaria Nchelenge Monthly trend line 2014-2021*
source("scripts/r prep2.r")
iccm <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/iccm.xls")
Mal.mnt.Nch <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge(monthly)_2014-2022.xls")
Mal.mnt.Nch  <- Mal.mnt.Nch  %>%
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
ani <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/insecticideall.xls")

#Date conversion
# dat2$period <- as.Date(dat2$period)  
# 
# da <- dat2[order(dat2$period), ]

names(Mal.mnt.Nch)

ani$Start <- as.Date(ani$Start) 
ani$End <- as.Date(ani$End) 

ani1 <- ani[order(ani$Start), ]
ani1 <- ani[order(ani$End), ]


#campaigns
cm <- as.Date("2014-10-01")
cm1 <- as.Date("2020-10-01")
cm2 <- as.Date("2017-10-01")
cm3 <- as.Date("2014-11-01")
cm4 <- as.Date("2017-11-01")
cm5 <- as.Date("2016-04-01")
cm6 <- as.Date("2015-10-01")
cm7 <- as.Date("2016-09-01")
cm8 <- as.Date("2017-09-01")
cm9 <- as.Date("2018-09-01")
cm10 <- as.Date("2019-09-01")
cm11 <- as.Date("2021-10-01")
cm12 <- as.Date("2020-11-01")

Start <- as.Date(NULL)
End <- as.Date(NULL)

iccm$start <- as.Date(iccm$start) 
iccm$end <- as.Date(iccm$end)

start <- as.Date(NULL)
end <- as.Date(NULL)


da
sapply(Mal.mnt.Nch,mode)

Mal.mnt.Nch1 <- Mal.mnt.Nch %>% select(3, 15, 23, 29)
Mal.mnt.Nch1

names(Mal.mnt.Nch1)
Mal.mnt.Nch2 <- Mal.mnt.Nch1 %>%
  rename(mal.case=1,
         mal.clnc=2,
         rnfl=3,
         mnthy=4)

colnames(Mal.mnt.Nch2) 

#plot
ggplot(Mal.mnt.Nch2,aes(x=mnthy))+
  geom_rect(data=ani1, aes(NULL, NULL, xmin=Start, xmax=End, fill=Inserticide),
            ymin=0,ymax=25000, colour=usaid_blue, size=0.6, alpha=0.6, lty="twodash") +
  geom_area(aes(y=mal.case, fill="mal.case"), alpha=0.3, color=usaid_blue)+
  geom_rect(data=iccm, aes(NULL, NULL, xmin=start, xmax=end),
            ymin=0,ymax=25000, size=0.6, fill=zamOrange, alpha=0.2, lty="twodash") +
  #geom_area(aes(y=mal.clnc, fill="mal.clnc"), alpha=0.3, color=usaid_blue)+
  geom_line(aes(y=rnfl/0.004), method = loess,color=light_blue, alpha=0.9, size=1, se=F) +
  geom_point(aes(y=rnfl/0.004), method = loess,color=light_blue, alpha=9, size=3, se=F)+
  geom_vline(xintercept = c(cm2, cm3, cm12),color=c("#198a00ff","#198a00ff","#198a00ff"), lty=c("solid", "solid", "solid") ,size=3, alpha=0.5) +
  # geom_point(aes(y=Malaria_Confirmed_Cases, color="Malaria_Confirmed_Cases"))+
  scale_x_date(date_labels="%b %y",date_breaks="6 months") +
  scale_y_continuous(labels=comma,sec.axis = sec_axis(trans = ~ .*0.004, labels=comma, name = "Rainfall(mm)"))+
  scale_fill_manual(values = c("Actelic Insecticide"="#002A6C", "Fludora Insecticide"=rich_black, 
                               "Sumishield Insecticide"="#BA0C2F", "Malaria Confirmed Cases"=light_grey, "ICCM Campaigns"= zamOrange)) +
  labs(fill="Legend:", caption="Data Source: HMIS, Vector Link, WFP- Rainfall"
       , title="Nchelenge Monthly Confirmed Malaria Cases with vector Control Campaigns, 2014-2022",
       x="",
       y="Confimred Malaria Cases") + base +
  annotate("text", x = cm, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  angle=90, hjust =-12, vjust=-1.4) +
  annotate("text", x = cm6, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm7, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm8, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm9, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm10, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white", angle=90, hjust =-12, vjust=-0.3) +
  annotate("text", x = cm11, y = 0, label = substitute(paste(bold('IRS'))), size=4, color="white",  angle=90, hjust =-12, vjust=-0.1) +
  annotate("text", x = cm2, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns'))), size=4, angle=90, hjust =-2.1, vjust=-0.15) +
  annotate("text", x = cm12, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns'))), size=4, angle=90, hjust =-2.1, vjust=-0.15) +
  annotate("text", x = cm3, y = 0, label = substitute(paste(bold('ITNS Mass Dist.Campaigns'))), size=4, angle=90, hjust =-2.1, vjust=-0.15)+
  # annotate("text", x = cm4, y = 0, label = substitute(paste(bold('ICCM Campaigns'))), size=4, angle=90, hjust =-2, vjust=1.5) +
  # annotate("text", x = cm5, y = 0, label = substitute(paste(bold('Behaviour Change Communication'))), size=4, angle=90, hjust =-1.5, vjust=-0.5)+
  annotate("text", x = cm, y = 0, label = substitute(paste(bold('Rainfall'))), size=5, color="black", angle=360, hjust =-16.3, vjust=-12.7)

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/No clinical Both all campaigns.png",
       device="png",
       type="cairo",
       height=9,
       width=16)


#'*Malaria Area Plot with Rainfall and Human Biting Rates*
source("scripts/r prep2.r")
# library(cowplot)
# library(geomtextpath)
# library(writexl)


# anf <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/hlb.xls")
ani <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/insecticide.xls")
all.vc <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/all.vectors.xls")
# rf <- read_xlsx("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge Rainfall.xlsx")
#dat5 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Manchene indoors.xls")
#dat6 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Manchene outdoors.xls")
#dat3<- read_xls(here("data/Malaria/shakall.xls"))
#dat2 <- read_xls(here("data/Malaria/hlb.xls"))


# Nchelenge HLC Shikapande FvG

# anf <- melt(anf[, c(1, 4, 5, 6)], id = 'period')
all.vc1 <- all.vc %>% select(1, 4, 5, 10)
all.vc1

anf$period <- as.Date(anf$period)
# rf$Period <- as.Date(rf$Period)
# rf
all.vc1$period <- as.Date(all.vc1$period)
all.vc1
# view(all.vc1)
# anf1 <- anf[order(anf$period), ]
ani1

ani$Start <- as.Date(ani$Start) 
ani$End <- as.Date(ani$End) 

ani1 <- ani[order(ani$Start), ]
ani1 <- ani[order(ani$End), ]
# 
# 
# rf <- rf[order(rf$period), ]
# rf1 <- rf[order(rf$period), ]
# rf
# names(rf)

#campaigns
cm <- as.Date("2019-10-01")
cm1 <- as.Date("2020-10-01")
Start <- as.Date(NULL)
End <- as.Date(NULL)

# str(anf1$period)
# 
# sapply(anf, mode)
# 
# class(period)
# ani1
# anf1
# rf1
# 
names(all.vc1)
all.vc1 <- all.vc1 %>%
  rename(mnthy=1,
         ind.spryd=2,
         ind.unspryd=3,
         rnfl=4)
# 
# all.vc2 <- all.vc1 %>%
#   gather(key = subpop , value = rate, c(ind.spryd, ind.unspryd))
# 
# all.vc2
#   
#   ggplot(all.vc2, aes(x = mnthy, y = rate, colour =subpop)) +
#     geom_area(aes(x=mnthy, y=rnfl, fill=usaid_blue), alpha=1, fill=light_blue, position=position_dodge())+
#     scale_y_continuous(labels=comma, sec.axis = sec_axis(trans = ~ .*1,name = "Rainfall(mm)")) +
#     geom_point(alpha=.6, size=.4) +
#     geom_smooth(method = loess, size = .6, se=F) +
#     scale_x_date(date_breaks="3 months", date_labels="%b %y") + basey
#     



# write_xlsx(new_anf1,"C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/dfdemo.xlsx")

pmi_1 <- ggplot(all.vc1,aes(x=mnthy))+
  geom_area(aes(y=ind.spryd, fill="ind.spryd"), alpha=1, color=light_grey, position=position_dodge())+
  geom_rect(data=ani1, aes(NULL, NULL, xmin=Start, xmax=End, fill=Inserticide),
            ymin=c(0,0), ymax=c(100, 100), colour="#CFCDC9", size=0.6, alpha=0.4, lty="twodash") +
  geom_area(aes(y=ind.unspryd, fill="ind.unspryd"), alpha=0.5, color=usaid_blue, position=position_dodge())+ 
  geom_line(aes(y=rnfl*1), method = loess,color=light_blue, alpha=0.3, size=1.5, se=F) +
  geom_point(aes(y=rnfl*1), method = loess,color=light_blue, alpha=9, size=3)+
  scale_fill_manual(values=c(zamOrange,light_grey,usaid_blue,light_blue),
                    labels = c("Fludora Insecticide", 
                               "Biting rate: An.gambiae s.l Outdoor Sprayed", 
                               "Biting rate: An.gambiae s.l Outdoor Unsprayed")) +
  scale_x_date(date_breaks="2 months", date_labels="%b %y") +
  scale_y_continuous(labels=comma,sec.axis = sec_axis(trans = ~ .*1, labels=comma, name = "Rainfall(mm)"))+
  labs(fill="Legend:", 
       #caption="Data Source: \n Vector Link-Data only available from 2019-2022 \n WFP-Rainfall", 
       title="Number of bites per person per Night in Sprayed and Unsprayed Areas - Outdoor",
       x="",
       y="human biting rate") + 
  basey +
  annotate("text", x = cm, y = 0, label = substitute(paste(bold('Indoor Residual Spraying'))), size=5, angle=90, hjust =-1.3, vjust=-1) +
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('Indoor Residual Spraying'))), size=5, angle=90, hjust =-1.3, vjust=-0.7)+
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('Rainfall'))), size=5, angle=360, hjust =-11.3, vjust=-20.7)

pmi_1

all.vc2 <- all.vc %>% select(1, 8, 9, 10)
all.vc2$period <- as.Date(all.vc2$period)
all.vc2

names(all.vc2)
all.vc2 <- all.vc2 %>%
  rename(mnthy=1,
         otd.spryd=2,
         otd.unspryd=3,
         rnfl=4)

all.vc2

pmi_2 <- ggplot(all.vc2,aes(x=mnthy))+
  geom_area(aes(y=otd.spryd, fill="otd.spryd"), alpha=1, color=light_grey, position=position_dodge())+
  geom_rect(data=ani1, aes(NULL, NULL, xmin=Start, xmax=End, fill=Inserticide),
            ymin=c(0,0), ymax=c(150, 150), colour="#CFCDC9", size=0.5, alpha=0.4, lty="twodash") +
  geom_area(aes(y=otd.unspryd, fill="otd.unspryd"), alpha=0.5, color=usaid_blue, position=position_dodge())+ 
  geom_line(aes(y=rnfl*1), method = loess,color=light_blue, alpha=0.3, size=1.5, se=F) +
  geom_point(aes(y=rnfl*1), method = loess,color=light_blue, alpha=9, size=3)+
  scale_fill_manual(values=c(zamOrange,light_grey,usaid_blue,light_blue),
                    labels = c("Fludora Insecticide", 
                               "Biting rate: An.funestus s.l Outdoor Sprayed", 
                               "Biting rate: An.funestus s.l Outdoor Unsprayed")) +
  scale_x_date(date_breaks="2 months", date_labels="%b %y") +
  scale_y_continuous(labels=comma,sec.axis = sec_axis(trans = ~ .*1, labels=comma, name = "Rainfall(mm)"))+
  labs(fill="Legend:", 
       caption="Data Source: \n Vector Link-Data only available from 2019-2022 \n WFP-Rainfall \n PLEASE NOTE: NO DATA FOR HBR FROM FEB-AUG 2020", 
       #title="Number of bites per person per Night in Sprayed and Unsprayed Areas - Outdoor",
       x="",
       y="human biting rate") + 
  basey +
  annotate("text", x = cm, y = 0, label = substitute(paste(bold('Indoor Residual Spraying'))), size=5, angle=90, hjust =-1.2, vjust=-1) +
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('Indoor Residual Spraying'))), size=5, angle=90, hjust =-1.2, vjust=-0.7)+
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('Rainfall'))), size=5, angle=360, hjust =-12.1, vjust=-19.9)

pmi_2
pmi_1

all_prov <- pmi_1 + pmi_2 + plot_layout(ncol=1)
all_prov

# all_prov <- grid.arrange(ipprov, nonipprov, ncol = 2, common.legend = TRUE, legend="bottom")

all_prov
ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/24.08.22/Outdoors.png",
       plot = all_prov,
       device="png",
       type="cairo",
       height=16,
       width=20)



ang <- ang %>% select(1,6,7)
ang

ang$period <- as.Date(ang$period)  

ang1 <- ang[order(ang$period), ]


pmi_2 <-ggplot(ang1,aes(x=period)) +
  geom_area(aes(y=gambiae_INDOOR_sprayed, fill="gambiae_INDOOR_sprayed"), alpha=1, color="#CFCDC9", position=position_dodge())+ 
  geom_rect(data=ani, aes(NULL,NULL,xmin=Start,xmax=End,fill=Inserticide),
            ymin=c(0,0) ,ymax=c(78,78), colour="#CFCDC9", size=0.6, alpha=0.8, lty="twodash") +
  geom_area(aes(y=gambiae_INDOOR_Unsprayed , fill="gambiae_INDOOR_Unsprayed"), alpha=0.7, color="#A7C6ED", position=position_dodge())+ 
  geom_line(aes(y=Rainfall/1, fill="Rainfall"), color="#A7C6ED", size=1) +
  scale_fill_manual(values=c("#EF7D00","#CFCDC9","#002F6C","#A7C6ED")) +
  scale_x_date(date_breaks="3 months", date_labels="%b %Y")+
  scale_y_continuous(sec.axis = sec_axis(trans = ~ .*1, labels=comma, name = "Rainfall(mm)"), labels=comma)+
  labs(fill="Legend:", #title="Number of bites per person per Night in Sprayed and Unsprayed Areas",
       x="",
       y="Human Bite Rate") +
  base +
  annotate("text", x = cm, y = 0, label = substitute(paste(bold('Indoor Residual Spraying'))), size=5, angle=90, hjust =-1.1, vjust=-1) +
  annotate("text", x = cm1, y = 0, label = substitute(paste(bold('Indoor Residual Spraying'))), size=5, angle=90, hjust =-1.1, vjust=-0.7)



pm2 <- pmi_2 + geom_point(aes(y=Rainfall/1),color="#A7C6ED", size=3)
pm2


plot_grid(pm1, pm2, nrows = 2, ncol = 1)

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge HBR All1 outdoors.png",
       #ggsave("viz/Malaria/Nchelenge HLC Manchene fg.png",
       device="png",
       #type="cairo",
       height=23,
       width=20)



#'*Nchelenge HLC for  Manchene FvG*

dat5<- melt(dat5[, c(1, 2, 3)], id.vars = 'Year')

dat5

sapply(dat5, mode)


pmi_4 <- ggplot(dat5, aes(x=Year, y=value, fill = variable)) + 
  geom_area(alpha=.7)+
  scale_fill_manual(values=c("#002A6C","#C2113A")) +
  labs(fill="Legend:", #title="Number of bites per person per Night at Manchene (Not Sprayed)",
       x="",
       y="Human Bite Rate") +
  theme(
    axis.title.y=element_text(angle=0, hjust=2, vjust=6),
    plot.title=element_text(size=10, hjust=1.5)) + 
  #  faceted # don't use this if the plot doesn't have facet_wrap
  geom_vline(xintercept = c(as.POSIXct("2019-10-01"), as.POSIXct("2020-10-01")),
             color=c("#EF7D00","#EF7D00"),
             lty=c("1343", "1343") ,
             size=c(1,1),
             alpha=1) + 
  #annotate("text", x = as.POSIXct("2019-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2019-10'))), size=3, angle=90, hjust =-0.8, vjust=-2) +
  #annotate("text", x = as.POSIXct("2020-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2020-10'))), size=3, angle=90, hjust =-0.7, vjust=2)+
  faceted
pmi_4

dat6 <- melt(dat6[, c(1, 2, 3)], id.vars = 'Year')

pmi_3 <-ggplot(dat6, aes(x=Year, y=value, fill = variable)) + 
  geom_area(alpha=.7)+
  scale_fill_manual(values=c("#002A6C","#C2113A")) +
  labs(fill="Legend:", title="Number of bites per person per Night at Manchene (Not Sprayed)",
       x="",
       y="Human Bite Rate") +
  theme(
    axis.title.y=element_text(angle=0, hjust=2, vjust=6),
    plot.title=element_text(size=10, hjust=1.5)) +
  #  faceted # don't use this if the plot doesn't have facet_wrap
  geom_vline(xintercept = c(as.POSIXct("2019-10-01"), as.POSIXct("2020-10-01")),
             color=c("#EF7D00","#EF7D00"),
             lty=c("1343", "1343"),
             size=c(1,1),
             alpha=1) +
  annotate("text", x = as.POSIXct("2019-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2019-10'))), size=3.4, angle=90, hjust =-0.9, vjust=-0.5) +
  annotate("text", x = as.POSIXct("2020-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2020-10'))), size=3.4, angle=90, hjust =-0.9, vjust=-0.5) +
  faceted

pmi_3

plot_grid(pmi_3, pmi_4,
          nrows = 2,
          ncol = 1
)

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge HLC Manchene fg.png",
       #ggsave("viz/Malaria/Nchelenge HLC Manchene fg.png",
       device="png",
       #type="cairo",
       height=16,
       width=18)



