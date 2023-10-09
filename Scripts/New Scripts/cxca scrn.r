source("scripts/r prep2.r")

si <- read_xlsx("Data/general/rdata.xlsx")

si  <- si  %>%
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


names(si)

si.1 <- si %>%
select(1,3,9)

si.1

#'*CXCA Sreenings Jan-Apr23*
names(si.1)
si.1 <- si.1 %>%
  rename(prov=1,
         val=2)

si.1

ggplot(si.1, aes(x=mnthyr, y=val, colour=usaid_blue)) + 
  geom_point(alpha=.6, size=1.5) + 
  #geom_line(size=1) +
  geom_smooth(method = loess, size = .8, se=FALSE) +
  facet_wrap(~prov) +
  faceted +
  scale_y_continuous(labels=comma) +
  scale_x_date(date_labels="%b %y",date_breaks="2 months") +
  labs(x="", y="Number of Women screened", caption="Data Source: RTCZ Insight", title="Monthly numbers of Women screened for CXCA has increased \nin the last two months in Luapula province, while in Muchinga & Northern they have declined") +
  scale_color_manual(name ="",
                     values = usaid_blue,
                     labels ="Women of reproductive age visted by CHA") + 
  baseX
ggsave("Viz/RTC/project CXCA scrns facet_wrap plus faceted.png",
       device="png",
       type="cairo",
       height=7,
       width=11)


###Stacked Bar Charts

# Create the bar chart
# ggplot(si.1, aes(x = mnthyr, y = val, fill = prov)) +
#   geom_bar(stat = "identity") +
#   scale_y_continuous(labels = comma) +
#   scale_x_date(date_labels = "%b %y", date_breaks = "2 months") +
#   labs(x = "", y = "Number of Women screened", caption = "Data Source: RTCZ Insight", title = "Monthly numbers of Women screened for CXCA") +
#   theme_minimal()


#Bar charts with usaid colours
#Bar Charts without labels
ggplot(si.1, aes(x = mnthyr, y = val, fill = prov)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = usaid_palette) + # Specify custom colors
  scale_y_continuous(labels = comma) +
  scale_x_date(date_labels = "%b %y", date_breaks = "1 months") +
  labs(x = "", y = "Number of Women screened", caption = "Data Source: RTCZ Insight", title = "Monthly numbers of Women screened for CXCA has increased \nin the last two months in Luapula province, while in Muchinga & Northern they have declined") +
  #theme_minimal()
  #baseC
  basem



#Create the grouped bar chart with custom colors and labels on top
#Bar Charts without labels
ggplot(si.1, aes(x = mnthyr, y = val, fill = prov)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = val), vjust = 1, size = 3, position = position_dodge(width = 0.9)) + # Adjust vjust to place labels on top of bars
  scale_fill_manual(name = "Provinces:", values = usaid_palette6) + # Specify custom colors
  scale_y_continuous(labels = comma) +
  faceted +
  scale_x_date(date_labels = "%b %y", date_breaks = "1 months") +
  labs(x = "", y = "Number of Women screened", caption = "Data Source: RTCZ Insight", title = "Monthly numbers of Women screened for CXCA has increased \nin the last two months in Luapula province, while in Muchinga & Northern they have declined") +
  base
  #theme_minimal()

ggsave("Viz/RTC/project CXCA scrns barcharts without labels.png",
       device="png",
       type="cairo",
       height=7,
       width=12)

###Put labels on all bar charts
ggplot(si.1, aes(x = mnthyr, y = val, fill = prov)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = val, group = prov), position = position_dodge(width = 2), vjust = -0.5, size = 3) + # Use position_dodge() to align labels with dodged bars
  scale_fill_manual(name = "Provinces:", values = usaid_palette6) + # Specify custom colors
  scale_y_continuous(labels = comma) +
  scale_x_date(date_labels = "%b %y", date_breaks = "1 months") +
  labs(x = "", y = "Number of Women screened", caption = "Data Source: RTCZ Insight", title = "Monthly numbers of Women screened for CXCA has increased \nin the last two months in Luapula province, while in Muchinga & Northern they have declined") +
  theme_minimal()



###Trend line
# Load required libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(scales)

# Read data from Excel file
si <- read_xlsx("Data/general/rdata.xlsx")

# Data preprocessing
si <- si %>%
  mutate(month_chr = str_sub(periodname,
                             start = 1,
                             end = nchar(periodname) - 5),
         month = factor(month_chr,
                        levels = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")),
         month_code = as.numeric(month),
         year = str_sub(periodname,
                        start = nchar(periodname) - 4,
                        end = nchar(periodname)),
         monyr = paste(month_code, year, sep = "-"),
         mnthyr = my(monyr))

# Select relevant columns
si.1 <- si %>%
  select(1, 3, 9) %>%
  rename(Provinces = 1,
         val = 2)

# Create a summary table of performance metrics for each province
summary_table <- si.1 %>%
  group_by(Provinces) %>%
  summarise(Total_Screened = sum(val),
            Avg_Screened = mean(val),
            Max_Screened = max(val),
            Min_Screened = min(val))

# Print the summary table
print(summary_table)

# Create a trend line plot for each province
ggplot(si.1, aes(x = mnthyr, y = val, group = Provinces, color = Provinces)) +
  geom_line() +
  geom_point()+
  facet_wrap(~Provinces) +
  faceted +
  scale_y_continuous(labels = comma) +
  scale_x_date(date_labels = "%b %y", date_breaks = "2 months") +
  labs(x = "", y = "Number of Women screened", caption = "Data Source: RTCZ Insight", title = "Monthly numbers of Women screened for CXCA has increased \nin the last two months in Luapula province, while in Muchinga & Northern they have declined") +
  baseX
  #theme_minimal()

