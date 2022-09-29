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
