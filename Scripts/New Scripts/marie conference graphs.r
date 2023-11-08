source("scripts/r prep2.r")


# Load the necessary libraries if not already installed

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("scales", quietly = TRUE)) {
  install.packages("scales")
}

# Load the required libraries
library(ggplot2)
library(scales)
library(tidyr)

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
