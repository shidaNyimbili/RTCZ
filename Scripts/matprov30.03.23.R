source("scripts/r prep2.r")


#'Provincial Maternal Mortality Ratio and Reporting Rates
matprv1 <- read_xls("Data/Malaria/Maternal Mortality Ratio and Reporting rates_ (2019 to 2022).xls")


matprv  <- matprv1  %>%
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

matprv

names(matprv)


matprv
matprv1 <- matprv %>%
  select(1,3,4,10)

matprv1
matprv3 <- matprv1 %>%
  rename(prov = 1,
         yr = 4,
         mr = 2,
         hrr = 3)


matprv3

matprv4 <- gather(matprv3, key = variable , value = rate, c(mr))
matprv4$variable <- factor(matprv4$variable, levels = unique(matprv4$variable)) # transform into factor
levels(matprv4$variable)

matprv4

write_xlsx(matprv4,"C:/Users/SNyimbili/OneDrive - Right to Care/Documents/RTCZ/matprv3.xlsx")


mt_plt <- ggplot(matprv4, aes(x = yr, y = rate, group = variable)) +
  geom_bar(position ='dodge', stat = "identity", fill=usaid_blue) +
  stat_smooth(method = "loess", size=0.98, se=F, color=usaid_red) + facet_wrap(~prov) +
  faceted+
  scale_y_continuous(sec.axis = sec_axis(~ .*0.0045, name="HIA2 Reporting rate",labels = scales::label_percent())) +
  labs(x="", y="Mortality Ratio", caption="Data Source: HMIS",title="Maternal mortality Ratio and reporting rates, 2019-2022") +
  scale_color_manual(name ="",
                     values = usaid_red,
                     labels = c("HIA2 Reporting rate (%)")) + 
  basem

mt_plt
ggsave("Viz/Matprov2.png",
       device="png",
       type="cairo",
       height = 8.2,
       width=14)



#Bars & lines

matprv3
ggplot(matprv3, aes(x=yr, y=mr)) +
  geom_col(stat="identity", position=position_dodge(), fill=usaid_blue) +
  geom_line(aes(x = yr, y = hrr*2.2, color=usaid_red)) +
  # geom_point(aes(aes(x= yr, y= hrr*2.2),color=usaid_red, size=3)) +
  facet_wrap(~prov) +
  faceted +
  scale_y_continuous(sec.axis = sec_axis(trans = ~ .*0.0045,name = "Reporting rate", labels = scales::label_percent())) +
  labs(x="", y="Mortality Ratio", caption="Data Source: HMIS",title="Maternal mortality Ratio and reporting rates, 2019-2022") +
  scale_color_manual(name ="",                     values = usaid_red,
                     labels = c("HIA2 Reporting rate (%)")) + 
  basem + geom_label(aes( x= yr, y = hrr*2.2,label=hrr), fontface = "bold", hjust=0.9, vjust = 0.8)

ggsave("Viz/bars.png",
       device="png",
       type="cairo",
       height = 7.5,
       width=14)


#Malaria modification
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

id_plt + geom_label(aes(x=mont, y=Malaria/1200),
                    label=mallbs, color = c("#002A6C","#002A6C","#002A6C","#002A6C","#002A6C", "#CFCDC9","#CFCDC9", "#A7C6ED"), fontface = "bold", hjust=0.5, vjust = 1.6)
