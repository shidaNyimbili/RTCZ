source("scripts/r prep2.r")
kc <- read_xls("C:/Users/snyimbili/Desktop/Conference/kc.xls")
peads <- read_xlsx("C:/Users/snyimbili/Desktop/Conference/peads.xlsx")
peads

peads  <- peads  %>%
  mutate(month_chr = str_sub(Period,
                             start=1,
                             end=nchar(Period)-5),
         month = factor(month_chr,
                        levels=c("January","February","March","April","May","June","July", "August","September","October","November","December")),
         month_code = as.numeric(month), 
         year = str_sub(Period, 
                        start=nchar(Period)-4,
                        end=nchar(Period)),
         monyr = paste(month_code, year, sep="-"),
         mnthyr = my(monyr))

sum(peads$month_chr!=peads$month) # expecting 0 if vars same

colnames(peads)

viz1 <- peads %>%
select(15,2,3)

names(viz)

viz <- viz1 %>% 
rename(mth=1,
       hts_tst_u15=2,
       hts_tst_pos_u15=3)

viz

viz2 <- viz %>% 
  gather(key = subpop , value = rate, c(hts_tst_u15))

viz2

kc

kc$Start <- as.Date(kc$Start)
kc$End <- as.Date(kc$End)

Start <- as.Date(NULL)
End <- as.Date(NULL)

bf <- as.Date("2022-01-01")
# dt1 <- as.Date("2018-10-01")

ggplot(viz2, aes(x = mth, y = rate)) +
  #geom_area(alpha=0.6, position = position_dodge()) +
  geom_point(alpha=.6, size=1, colour=usaid_red) + 
  #geom_area(alpha=.3, size=.8, color=usaid_blue, fill=light_blue) + 
  #geom_line(size=1) +
  geom_smooth(method = loess, size = .8, se=FALSE, color=usaid_red)  + 
  geom_rect(data=kc, aes(NULL, NULL, xmin=Start, xmax=End, fill=title),
            ymin=0,ymax=16986, size=0.6, alpha=0.2, lty="dotted") +
  scale_y_continuous(labels=comma,
                     # limits=c(0,16000),
                     breaks = c(0,4000,8000,12000,16000)) +
  scale_x_date(date_labels="%b %y",date_breaks = "1 month") +
  labs(x ="", y="", caption = "Data Source: Action HIV") +
  ggtitle("Pediatrics Surge Testing Trends Progress") +
  scale_color_manual(name= "", values = usaid_red,
                     labels = c("HIV Tests Under 15 yrs")) + basey 
  #geom_vline(xintercept = bf,color=c("#EF7D00") ,lty=c("longdash") ,size=1, alpha=1)

# +
#   annotate("text", x = bf, y = 0, label = substitute(paste(bold('Before Knowledge Cafe'))), size=4, angle=0, hjust =1.7, vjust=-16, color=rich_black) +
#annotate("text", x = bf, y = 0, label = substitute(paste(bold('HIV Tests Under 15 yrs'))), size=4, angle=0, hjust =-2.7, vjust=-18, color=rich_black)


ggsave("C:/Users/snyimbili/Desktop/Conference/Peads trends.png",
       device="png",
       type="cairo",
       height = 5.5,
       width = 11)

####HSTvsTX_Curr

colnames(peads)

viz3 <- peads %>%
  select(15,3,4)

names(viz1)

viz <- viz3 %>% 
  rename(mth=1,
         hts_tst_pos_u15=2,
         tx_new_u15=3)

viz

viz4 <- viz %>% 
  gather(key = subpop , value = rate, c(hts_tst_pos_u15,tx_new_u15))

viz4

bf <- as.Date("2022-01-01")

ggplot(viz4, aes(x = mth, y = rate, colour=subpop)) +
  geom_smooth(method = loess, size = .8, se=FALSE)  + 
  geom_point(alpha=.6, size=1) +
  scale_x_date(date_labels="%b %y",date_breaks = "1 month") +
  labs(x ="", y="", caption = "Data Source: USAID Action HIV") +
  ggtitle("Pediatrics Surge HIV Testing Trends") +
  scale_colour_manual(name= "", values = usaid_palette,
                     labels = c("HIV Tests Positive Under 15 yrs", "TX New Under 15 yrs")) + basey +
  geom_vline(xintercept = bf,color=zamOrange ,lty=c("longdash") ,size=1, alpha=1) +
  annotate("text", x = bf, y = 0, label = substitute(paste(bold('Before Knowledge Café Implementation'))), size=4, angle=0, hjust =1.2, vjust=-10, color=light_blue) +
  annotate("text", x = bf, y = 0, label = substitute(paste(bold('After Knowledge Café Implementation'))), size=4, angle=0, hjust =-0.5, vjust=-10, color="Pink")
  
  
ggsave("C:/Users/snyimbili/Desktop/Conference/Peads pos.png",
       device="png",
       type="cairo",
       height = 5,
       width = 10)

###Linkage vs Suppression
colnames(peads)

viz5 <- peads %>%
  select(15,5,9)

names(viz5)

viz6 <- viz5 %>% 
  rename(mth=1,
         linkage=2,
         suppresssion=3)

viz6

viz7 <- viz6 %>% 
  gather(key = subpop , value = rate, c(linkage,suppresssion))

viz7

bf <- as.Date("2022-01-01")

ggplot(viz7, aes(x = mth, y = rate, colour=subpop)) +
  geom_smooth(method = loess, size = .8, se=FALSE)  + 
  geom_point(alpha=.6, size=1) +
  scale_x_date(date_labels="%b %y",date_breaks = "1 month") +
  labs(x ="", y="Percentage", caption = "Data Source: USAID Action HIV") +
  ggtitle("Linkage and Viral Load Suppression Trends") +
  scale_y_continuous(limits = c(0,1.08),
                     labels = percent,
                     breaks = c(.2,.4,.6,.8, 1.08)) +
  scale_colour_manual(name= "", values = usaid_palette,
                      labels = c("Linkage", "Suppression")) + basey +
  geom_vline(xintercept = bf,color=zamOrange ,lty=c("longdash") ,size=1, alpha=1) +
  annotate("text", x = bf, y = 0, label = substitute(paste(bold('Before Knowledge Café Implementation'))), size=4, angle=0, hjust =1.1, vjust=-10, color=light_blue) +
  annotate("text", x = bf, y = 0, label = substitute(paste(bold('After Knowledge Café Implementation'))), size=4, angle=0, hjust =-0.5, vjust=-10, color="Pink")


ggsave("C:/Users/snyimbili/Desktop/Conference/Peads linkVL.png",
       device="png",
       type="cairo",
       height = 5,
       width = 10)


###Suppression
colnames(peads)

vit <- peads %>%
  select(15,7,8,9)

names(vit)

vit1 <- vit %>% 
  rename(mth=1,
         tx_pvls_d_u15=2,
         tx_pvls_d_o15=3,
         suppression=4)

vit1

# vit1
# 
# vit2 <- vit1 %>% 
#   gather(key = subpop , value = rate, c(linkage,suppresssion))
# 
# viz7

bf <- as.Date("2022-01-01")

ggplot(vit1, aes(x = mth, y = tx_pvls_d_u15)) +
  geom_bar(stat = "identity", position = "dodge")

