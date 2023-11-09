source("scripts/r prep2.r")


##HTS_TST Performance by province Before & After Lynx rollout - Selected Districts 
# Create a data frame with the provided data
data <- data.frame(
  Period = c("2019", "2020", "2021"),
  Luapula = c(0.08, 0.12, 0.15),
  Muchinga = c(0.06, 0.11, 0.12),
  Northern = c(0.07, 0.09, 0.14)
)

library(tidyr)

# Check the structure of your dataframe
str(data)

# Use gather to create a long format
data <- gather(data, indicators, value, Luapula:Muchinga:Northern)

data

dt <- as.Date("2020-01-01")

plot <- ggplot(data, aes(Period, value, fill = indicators))
plot <- plot +
  geom_bar(stat = "identity", position = 'dodge') +
  geom_text(aes(label = scales::percent(value), vjust = -0.5), position = position_dodge(0.9)) +  # Add labels
  #geom_vline(xintercept = dt, linetype = "dashed", color = "red") +  # Add vertical line
  # annotate("text", x = 1.5, y = 0.19, label = "Pre-Lynx rollout", color = "red", size = 4) +  # Label before 2020
  # annotate("text", x = 2.5, y = 0.19, label = "Post-Lynx rollout", color = "red", size = 4) +  # Label after 2020
  labs(
    title = "HTS TST Performance by province Before & After Lynx rollout - Selected Districts",
    x = "Period",
    y = "Values",
    fill = "Legend",
    caption = "Data source: Action HIV Project"
  ) +
  scale_fill_manual(values = c(usaid_blue, usaid_red, light_blue)) +
  scale_y_continuous(labels = percent) + basey

plot

# # Create the combo graph with bars and a secondary axis for percentages
# ggplot(data, aes(x = Quarters)) +
#   geom_bar(aes(y = Total_HTS_TST_POS, fill = "Total HTS Tests Positive"), position ='dodge' , stat = "identity") +
#   geom_bar(aes(y = Total_HTS_TST, fill = "Total HTS Tests"), stat = "identity",position ='dodge') +
#   #geom_line(aes(y = Linkage_Percentage*1101, group = 1, fill= "Linkage (%) Overall"), size = 1) +
#   #scale_y_continuous(labels = percent)) +


ggsave("Viz/RTC/LynxHTS.png",
       device="png",
       type="cairo",
       height=7,
       width=12)


##Overall HTS_TST Performance Trend Before & After Lynx rollout

data <- data.frame(
  Period = c("2019", "2020", "2021"),
  HTS_TST = c(140808,113779,89266),
  HTS_TST_POS = c(9856,12519,12702),
  HIV_POS_YIELD = c(0.07, 0.11, 0.14)
)


library(tidyr)

# Check the structure of your dataframe
str(data)

# Use gather to create a long format
data <- gather(data, indicators, value, HTS_TST:Muchinga:Northern)

data

dt <- as.Date("2020-01-01")

plot <- ggplot(data, aes(Period, value, fill = indicators))
plot <- plot +
  geom_bar(stat = "identity", position = 'dodge') +
  geom_text(aes(label = scales::percent(value), vjust = -0.5), position = position_dodge(0.9)) +  # Add labels
  #geom_vline(xintercept = dt, linetype = "dashed", color = "red") +  # Add vertical lineHT
  # annotate("text", x = 1.5, y = 0.19, label = "Pre-Lynx rollout", color = "red", size = 4) +  # Label before 2020
  # annotate("text", x = 2.5, y = 0.19, label = "Post-Lynx rollout", color = "red", size = 4) +  # Label after 2020
  labs(
    title = "HTS TST Performance by province Before & After Lynx rollout - Selected Districts",
    x = "Period",
    y = "Values",
    fill = "Legend",
    caption = "Data source: Action HIV Project"
  ) +
  scale_fill_manual(values = c(usaid_blue, usaid_red, light_blue)) +
  scale_y_continuous(labels = percent) + basey

plot


##Overall HTS_TST Performance Trend Before & After Lynx rollout------------WORKING
# Load the required libraries
library(tidyr)
library(ggplot2)
library(scales)

# Create the data frame
data <- data.frame(
  Period = c("2019", "2020", "2021"),
  HTS_TST = c(140808, 113779, 89266),
  HTS_TST_POS = c(9856, 12519, 12702),
  HIV_POS_YIELD = c(7, 11, 14)
)

# Reshape the data to long format
data <- gather(data, key = "indicators", value = "value", -Period)

data

# Create a combo graph
plot <- ggplot(data, aes(x = Period, y = value, fill = indicators)) +
  geom_bar(stat = "identity", position = "dodge") +
  #geom_text(aes(label = ifelse(indicators == "HIV_POS_YIELD", scales::percent(value / 100), scales::comma(value)), vjust = -0.5), position = position_dodge(0.9)) +
  geom_point(data = data[data$indicators == "HIV_POS_YIELD", ], aes(x = Period, y = value * 6000), color = light_blue, size = 3) +
  geom_text(aes(label = ifelse(indicators != "HIV_POS_YIELD", scales::comma(value), "")), vjust = -0.5, position = position_dodge(0.9)) +
  geom_line(data = data[data$indicators == "HIV_POS_YIELD", ], aes(x = Period, y = value * 6000, group = 2, label = scales::percent(value /100)), color = light_blue,size=1) +
  labs(
    title = "Overall HTS_TST Performance Trend Before & After Lynx rollout",
    x = "Period",
    y = "Values",
    fill = "Legend",
    caption = "Data source: Action HIV Project"
  ) +
  scale_fill_manual(values = c("HTS_TST" = usaid_blue, "HTS_TST_POS" = usaid_red, "HIV_POS_YIELD" = light_blue)) + 
  scale_y_continuous(labels=comma,
                     sec.axis = sec_axis(
                       ~ . / 6000,
                       name = "HIV_POS_YIELD %",
                       labels = scales::percent_format(scale = 1)
                     )
  ) + basey

# Display the plot
print(plot)


ggsave("Viz/RTC/overallHTS2.png",
       device="png",
       type="cairo",
       height=7,
       width=12)


Legend##Last one
#'*Last one*
data <- data.frame(
Facility =c("Chinsali_DH","Buntungwa","Chembe","Kabuta","Senama","Kashikishi","Samfya_StageII","Nchelenge","Munkanta","Kazembe","StPaulsMission","Namukolo","Mansa_GH","Chisanga","Central_Clinic","Mbereshi_Mission","Tazara_Res","Kawambwa_DH","Mpepo"),
HIV_Pos_yield_2019 =c(38,17,35,24,24,26,29,25,21,27,6,20,13,13,20,16,16,2,8),
HIV_Pos_Yield_2022 =c(75,67,63,55,49,40,39,35,35,34,26,25,23,22,22,21,20,19,16)
)

data <- gather(data, key = "indicators", value = "value", -Facility)
data

plot <- ggplot(data, aes(x = Facility, y = value, fill = indicators)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = ifelse(indicators == "HIV_Pos_Yield_2022", scales::comma(value), "")), vjust = -0.5, position = position_dodge(0.9)) +
  #geom_line(data = data[data$indicators == "HIV_POS_YIELD", ], aes(x = Period, y = value * 6000, group = 2, label = scales::percent(value /100)), color = light_blue,size=1) +
  labs(
    title = "HTS_TST Performance Trend - Selected facilities - Lynx Implementation",
    x = "Period",
    y = "Values",
    fill = "Legend",
    caption = "Data source: Action HIV Project"
  ) +
  scale_fill_manual(values = c("HIV_Pos_yield_2019" = usaid_blue, "HIV_Pos_Yield_2022" = usaid_red)) + 
  scale_y_continuous(labels=comma) + basey

plot

ggsave("Viz/RTC/HTS_TST_Per.png",
       device="png",
       type="cairo",
       height=7,
       width=12)


####Performance
# Load the required libraries


# Load the required libraries
library(ggplot2)
library(scales)

# Create the data frame
data <- data.frame(
  Facility = c("Chinsali_DH", "Buntungwa", "Chembe", "Kabuta", "Senama", "Kashikishi", "Samfya_StageII", "Nchelenge", "Munkanta", "Kazembe", "StPaulsMission", "Namukolo", "Mansa_GH", "Chisanga", "Central_Clinic", "Mbereshi_Mission", "Tazara_Res", "Kawambwa_DH", "Mpepo"),
  HIV_Pos_yield_2019 = c(38, 17, 35, 24, 24, 26, 29, 25, 21, 27, 6, 20, 13, 13, 20, 16, 16, 2, 8),
  HIV_Pos_Yield_2022 = c(75, 67, 63, 55, 49, 40, 39, 35, 35, 34, 26, 25, 23, 22, 22, 21, 20, 19, 16)
)

# Reshape the data to long format
data_long <- gather(data, key = "Year", value = "Value", -Facility)

# Create a bar chart
plot <- ggplot(data_long, aes(x = Facility, y = Value, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = scales::percent(Value / 100), vjust = -0.5), position = position_dodge(0.9)) +
  labs(
    title = "HIV Positivity Yield Trend - Selected Facilities",
    x = "Facility",
    y = "Values",
    fill = "Year",
    caption = "Data source: Action HIV Project"
  ) +
  scale_fill_manual(values = c("HIV_Pos_yield_2019" = usaid_blue, "HIV_Pos_Yield_2022" = usaid_red)) +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) + Angle

# Display the plot
print(plot)

ggsave("Viz/RTC/HTS_TST_Per.png",
       device="png",
       type="cairo",
       height=7,
       width=12)

# Load the required libraries
library(ggplot2)
library(scales)

# Create the data frame
data <- data.frame(
  Facility = c("Chinsali_DH", "Buntungwa", "Chembe", "Kabuta", "Senama", "Kashikishi", "Samfya_StageII", "Nchelenge", "Munkanta", "Kazembe", "StPaulsMission", "Namukolo", "Mansa_GH", "Chisanga", "Central_Clinic", "Mbereshi_Mission", "Tazara_Res", "Kawambwa_DH", "Mpepo"),
  HIV_Pos_yield_2019 = c(38, 17, 35, 24, 24, 26, 29, 25, 21, 27, 6, 20, 13, 13, 20, 16, 16, 2, 8),
  HIV_Pos_Yield_2022 = c(75, 67, 63, 55, 49, 40, 39, 35, 35, 34, 26, 25, 23, 22, 22, 21, 20, 19, 16)
)

# Reshape the data to long format
data_long <- gather(data, key = "Year", value = "Value", -Facility)

# Create a bar chart with rotated x-axis labels
plot <- ggplot(data_long, aes(x = Facility, y = Value, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = scales::percent(Value / 100), vjust = -0.5), position = position_dodge(0.9)) +
  labs(
    title = "HIV Positivity Yield Trend - Selected Facilities",
    x = "Facility",
    y = "Values",
    fill = "Year",
    caption = "Data source: Action HIV Project"
  ) +
  scale_fill_manual(values = c("HIV_Pos_yield_2019" = "blue", "HIV_Pos_Yield_2022" = "red")) +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels by 45 degrees

# Display the plot
print(plot)

