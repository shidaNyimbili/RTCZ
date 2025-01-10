source("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Scripts/r prep.R")
dat <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge Confirmed Cases.xls")
pmi_data <- dat %>%
  mutate(name2=name)

#Malaria Nchelenge trend line 2014-2021 with campaigns

pmi_data %>%
  ggplot(aes(x=Year, y=Confirmed_Cases,group=name))+
  geom_line( dat=pmi_data %>% dplyr::select(-name), aes(group=name2), color="#BA0C2F", size=1, alpha=0.6) +
  geom_point(aes(color = name, group = name), color="#BA0C2F", size=3, alpha=6 ) +
  geom_vline(xintercept = c(vline1, vline2, vline3, vline4, vline5),color=c("#212721","#EF7D00", "#0067B9","#EF7D00","#198a00ff") ,lty=c("solid", "solid", "solid", "solid", "1343") ,size=c(5,5,5,5,1), alpha=0.5)+
  annotate("text", x = vline1, y = 0, label = "SBC", size=2, angle=90, hjust =-10) +
  annotate("text", x = vline2, y = 0, label = "Mass ITNS Distribution", size=2, angle=90, hjust =-2)+
  annotate("text", x = vline3, y = 0, label = "ICCM", size=2, angle=90, hjust =-8) +
  annotate("text", x = vline4, y = 0, label = "Mass ITN's Distribution", size=2, angle=90, hjust =-2)+
  scale_x_continuous(breaks=2014:2021) +
  scale_y_continuous(labels=comma) + #faceted
  labs(title="Nchelenge Confirmed Cases",
       x="",
       y="Confirmed cases") +
  theme(axis.title.y=element_text(angle=0, vjust=.5),
        plot.title=element_text(hjust=.5))+
  faceted
  #geom_point(size=3, colour="#002a6c")
  #scale_color_viridis(discrete = TRUE) +
  #theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11),
    panel.grid = element_blank()
  ) 
  # #ggtitle("Confirmed Malaria Cases") +
  # theme(plot.title=element_text(hjust=0.5))+
  #   facet_wrap(~name)+
  #   faceted
  

  
  ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases trendline with IRS campaigns.png",
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
  theme(axis.title.y=element_text(angle=0, vjust=.5),
        plot.title=element_text(hjust=.5))+
        faceted


ggsave("viz/Malaria/Nchelenge confirmed cases bar.png",
        device="png",
        type="cairo",
       height=6,
        width=10)
# #ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases bar.png",
#        device="png",
#        type="cairo",
#        height=4,
#        width=7)


#Malaria Nchelenge Monthly trend line 2014-2021

dat1 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge Confirmed Cases Monthly 2014-2021.xls")
monthly_data <- dat1 %>%
geom_line( dat1=monthly_data %>% dplyr::select(-name), aes(group=name2), color="#BA0C2F", size=1, alpha=0.6) +
geom_point(aes(color = name, group = name), color="#BA0C2F", size=3, alpha=6 ) +
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
theme(axis.title.y=element_text(angle=0, vjust=.5),
      plot.title=element_text(hjust=.5))+
faceted
geom_point(size=3, colour="#002a6c")
scale_color_viridis(discrete = TRUE) +
theme_ipsum() +
theme(
  legend.position="none",
  plot.title = element_text(size=11),
  panel.grid = element_blank()
)

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases trendline with IRS campaigns.png",
       device="png",
       type="cairo",
       height=4,
       width=7)


#Malaria Nchelenge Monthly trend line 2014-2021

dat1 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/Nchelenge Confirmed Cases Monthly 2014-2021.xls")
monthly_data <- dat1 %>%
  ggplot(aes(x=monthyr, y=Malaria_Confirmed_Cases))+
  geom_line(size=.4, color="#0067B9", alpha=.5) +
  geom_point(size=1, color="#0067B9", alpha=2.5)+
  #geom_text(aes(label=Malaria_Confirmed_Cases), vjust = 1.5, color="white", size=2) +
  scale_x_continuous(breaks=2014:2021) +
  scale_y_continuous(labels=comma) +
  labs(title="Nchelenge Monthly Confirmed Cases",
       x="",
       y="Malaria Confirmed Cases") +
  theme(axis.title.y=element_text(angle=0, vjust=.5),
        plot.title=element_text(hjust=.5))+
  faceted

ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge confirmed cases trendline with monthly1.png",
       device="png",
       type="cairo",
       height=4,
       width=7)

#Malaria Area Plot wiith Campaigns

#dat2 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/hlb.xls")
#dat3 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/shakall.xls")
dat3<- read_xls(here("data/Malaria/shakall.xls"))
dat2 <- read_xls(here("data/Malaria/hlb.xls"))

dat2
dat3

# dat <- dat2 %>%
#   pivot_longer(2:3,
#                names_to="variable",
#                values_to="value")

dat2<- melt(dat2[, c(1, 2, 3)], id.vars = 'Year')

dat2

sapply(dat2, mode)


pmi_1 <- ggplot(dat2, aes(x=Year, y=value, fill = variable)) + 
  geom_area(alpha=.7)+
  scale_fill_manual(values=c("#002A6C","#C2113A")) +
  labs(title="Number of bites per person per Night at Shikapande (Sprayed)",
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
  annotate("text", x = as.POSIXct("2019-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2019-10'))), size=3, angle=90, hjust =-0.8, vjust=-2) +
  annotate("text", x = as.POSIXct("2020-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2020-10'))), size=3, angle=90, hjust =-0.7, vjust=2)+
  faceted

dat3 <- melt(dat3[, c(1, 2, 3)], id.vars = 'Year')

pmi_2 <-ggplot(dat3, aes(x=Year, y=value, fill = variable)) + 
  geom_area(alpha=.7)+
  #  scale_fill_manual(values=c("#CFCDC9","#6C6463")) +
  scale_fill_manual(values=c("#002A6C","#C2113A")) +
  labs(#title="No. of bites per person per Night at Shikapande (Sprayed)",
    x="",
    y="Human Bite Rate") +
  theme(
    axis.title.y=element_text(angle=0, hjust=2, vjust=6, size=30),
    plot.title=element_text(size=20, hjust=1.5)) +
  #  faceted # don't use this if the plot doesn't have facet_wrap
  geom_vline(xintercept = c(as.POSIXct("2019-10-01"), as.POSIXct("2020-10-01")),
             color=c("#EF7D00","#EF7D00"),
             lty=c("1343", "1343") ,
             size=c(1,1),
             alpha=1) +
  #annotate("text", x = as.POSIXct("2019-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2019-10'))), size=3, angle=90, hjust =-0.8, vjust=-2) +
  #annotate("text", x = as.POSIXct("2020-10-01"), y = 0, label = substitute(paste(bold('ITNS Mass Dist. Campaigns:2020-10'))), size=3, angle=90, hjust =-0.7, vjust=2)+
  faceted


plot_grid(pmi_1, pmi_2, nrows=2, ncol=1)

#ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge HLC combo3.png",
ggsave("viz/Malaria/Nchelenge HLC combo2.png",
       device="png",
       #type="cairo",
       height=18,
       width=14)




