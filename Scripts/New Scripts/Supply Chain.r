#Load Packages
source("scripts/r prep2.r")

#'*Stock availability*
stk <- read_xlsx("Data/RTC/Supply Chain/determine_TLD 29.09.2022.xlsx")
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
                     labels = percent,
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
