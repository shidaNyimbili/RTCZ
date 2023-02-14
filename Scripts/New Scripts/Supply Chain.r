#Load Packages
source("scripts/r prep2.r")

#'*Stock availability*
stk <- read_xlsx("Data/RTC/Supply Chain/determine_TLD.xlsx")
stk  <- stk  %>%
  mutate(month_chr = str_sub(period,
                             start=1,
                             end=nchar(period)-5),
         month = factor(month_chr,
                        levels=c("January","February","March","April","May","June","July","August","September","October","November","December")),
         month_code = as.numeric(month), 
         year = str_sub(period, 
                        start=nchar(period)-4,
                        end=nchar(period)),
         monyr = paste(month_code, year, sep="-"),
         mnthyr = my(monyr))

sum(stk$month_chr!=stk$month) # expecting 0 if vars same

stk

# install.packages("scales")

###Rename the cell names of provinces
stk$Province_Determine <- gsub("Luapula _% Availability","Luapula", stk$Province_Determine)
stk$Province_Determine <- gsub("Muchinga_% Availability","Muchinga", stk$Province_Determine)
stk$Province_Determine <- gsub("Northern_% Availability","Northern", stk$Province_Determine)

stk
names(stk)

stk1 <- stk %>%
  select(2, 3, 4, 5, 6, 12)

names(stk1)

stk2 <- stk1 %>%
  rename(trgt.Dtmine=1,
         dtmine.avail=2,
         prov=3,
         trgt.TLD=4,
         TLD.Avail=5,
         mth=6)
stk2
names(stk2)

####plot Determine

dtmin <- stk2 %>%
  select(1,2,3,6)

TLD <- stk2 %>%
  select(1,2,3,5,6)

TLD



names(dtmin)

###For the Target Line

target <- as.Date("2021-10-01")

dtmin <- dtmin %>% 
  gather(key = subpop , value = rate, c(dtmine.avail))

dtmin_plt <- ggplot(dtmin, aes(x = mth, y = rate, group = subpop, colour = subpop)) +
  geom_point(alpha=.6, size=1) + 
  geom_smooth(method = loess, size = .8, se=FALSE) +
  scale_y_continuous(limits = c(0,1),
                     labels = percent(y, accuracy = 0),
                     breaks = c(.2, .4, .6, .8, 1)) +
  scale_x_date(date_labels="%b %y",date_breaks="2 months") +
  facet_wrap(~prov) + faceted +
  labs(x="", y="", caption="Data Source: HMIS", title="") +
  scale_color_manual(name ="",
                     values = usaid_palette,
                     labels = c("Determine Stock availability")) + 
  geom_hline(yintercept = .95 ,color=usaid_red ,
             lty="longdash",size=.7, alpha=.6) +
  geom_text(aes(target, .95, 
                label = "95% : Target Determine Stock Availability", 
                vjust = -0.7, hjust=0.05),color=usaid_red, size=3) + 
  basey

dtmin_plt

plot_layout(dtmin_plt, guides = "collect")

ggsave("Viz/RTC/Supply Chain/Det Draft.png",
       device="png",
       type="cairo",
       height = 6.5,
       width = 13)

####TLD Trends
tld <- read_xlsx("Data/RTC/Supply Chain/TLD trends.xlsx")
tld  <- tld  %>%
  mutate(month_chr = str_sub(period,
                             start=1,
                             end=nchar(period)-5),
         month = factor(month_chr,
                        levels=c("January","February","March","April","May","June","July","August","September","October","November","December")),
         month_code = as.numeric(month), 
         year = str_sub(period, 
                        start=nchar(period)-4,
                        end=nchar(period)),
         monyr = paste(month_code, year, sep="-"),
         mnthyr = my(monyr))

sum(tld$month_chr!=tld$month) # expecting 0 if vars same

# ###Perinatal MOrtality Rate MOnthly Trend
# pd <- read_xls("C:/Users/snyimbili/Documents/RTCZ/Data Analytics & GIS/General Datasets/New Born R/Still&Mecerated Rates.xls")
# 
# 
# pd <- melt(pd[c(1, 2, 3)], id = 'period')
# 
# 
# pd$period <- as.Date(pd$period)

tld
names(tld)

tld1 <- tld %>%
  select(2,3,4,10)

tld1

# tld1 <- melt(tld1[c(1, 2, 3,4)], id = 'mnthyr')

# fmsb <- ggplot(tld1, aes(x=mnthyr, y=value , fill=variable), alpha=0.6)+ 
#   stat_smooth(method = "loess", size = 1, se=F) + geom_point(size=1, colour=usaid_red) +
  #geom_bar(stat="identity", position="dodge") +
  #geom_area(position=position_dodge(), color="#CFCDC9") +
  # geom_area(alpha=.7, fill="#BA0C2F", alpha=0.6, position=position_dodge()) +
  # scale_x_date(date_breaks = "2 months", date_labels = "%b %y") +
  # scale_fill_manual(values=c("#8AC3BC", "#002F6C")) + 
  # basey +
  # labs(fill="Legend:", title="Fresh still rate and Macerated still births",
  #      x="",
  #      y="Rate")

tld1 <- tld1 %>%
  rename(tx_curr = 1,
         tld_curr = 2,
         tld.cov= 3,
         mnth = 4)

tld1


tld2 <- tld1 %>% 
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

fmsb


######HTS
hts <- read_xlsx("Data/RTC/HTS/HTS.xlsx")
hts  <- hts %>%
  mutate(month_chr = str_sub(period,
                             start=1,
                             end=nchar(period)-5),
         month = factor(month_chr,
                        levels=c("January","February","March","April","May","June","July","August","September","October","November","December")),
         month_code = as.numeric(month), 
         year = str_sub(period, 
                        start=nchar(period)-4,
                        end=nchar(period)),
         monyr = paste(month_code, year, sep="-"),
         mnthyr = my(monyr))

sum(stk$month_chr!=stk$month) # expecting 0 if vars same

hts
names(hts)

hts <- hts %>%
  select(2,3,4,10)
hts

hts1 <- hts %>%
  rename(prov=1,
         adults=2,
         peads=3,
         mnth=4)
hts1

hts1 <- hts1 %>% 
  gather(key = substat , value = rate, c(adults,peads))

dtmin_plt <- ggplot(hts1, aes(x = mnth, y = rate, group = substat, colour = substat)) +
  geom_point(alpha=.6, size=1.2) + 
  geom_smooth(method = loess, size = 1, se=FALSE) +
  scale_y_continuous(labels=comma,
                     breaks = c(100, 400, 800, 1200)) +
  scale_x_date(date_labels="%b %y",date_breaks="2 month") +
  facet_wrap(~prov) + faceted +
  labs(x="", y="", caption="Data Source: USAID ACTION HIV", title="HTS TST Performance Trends") +
  scale_color_manual(name ="",
                     values = c(usaid_red, usaid_blue),
                     labels = c("Adults HTS TST Performance", "Peads HTS TST Performance"))+ 
  basey

dtmin_plt


ggsave("C:/Users/snyimbili/Desktop/Conference/HTS.png",
       device="png",
       type="cairo",
       height = 5,
       width = 10)

