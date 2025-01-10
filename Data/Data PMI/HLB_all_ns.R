source("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Scripts/r prep.R")
#source("scripts/r prep.r")

dat2 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/hlb.xls")
dat3 <- read_xls("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Data PMI/shakall.xls")
#dat2 <- read_xls(here("data/hlb.xls"))
#dat2

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
  
ggsave("C:/Users/NyimbiliShida/Documents/MSI/GIS & Visuals/R Data/Visuals Exports/Nchelenge HLC combo2.png",
#ggsave("viz/Nchelenge HLC.png",
         device="png",
         #type="cairo",
         height=8,
         width=14)



