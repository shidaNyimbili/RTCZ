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

# Create a data frame with the provided data
data <- data.frame(
  Quarters = c("FY21Q1", "FY21Q2", "FY21Q3", "FY21Q4", "FY22Q1", "FY22Q2", "FY22Q3", "FY22Q4","FY23Q1", "FY23Q2", "FY23Q3"),
  Total_HTS_TST_POS = c(5609, 6797, 7543, 5310, 7242, 8299, 8382, 6561, 4929, 4305, 3981),
  Total_HTS_TST = c(64080, 71500, 75606, 66583, 89528, 105966, 126165, 182051, 133504, 141818, 162085),
  Linkage_Percentage = c(100, 98, 98, 97, 97, 100, 101, 100, 99, 98, 96)
)

df <- gather(df, indicators, total, Total_HTS_TST_POS:Total_HTS_TST) #Create long format

data


# Create the combo graph with bars and a secondary axis for percentages
ggplot(data, aes(x = Quarters)) +
  geom_bar(aes(y = Total_HTS_TST_POS, fill = "Total HTS Tests Positive"), position ='dodge' , stat = "identity") +
  geom_bar(aes(y = Total_HTS_TST, fill = "Total HTS Tests"), stat = "identity",position ='dodge') +
  #geom_line(aes(y = Linkage_Percentage*1101, group = 1, fill= "Linkage (%) Overall"), size = 1) +
  #scale_y_continuous(sec.axis = sec_axis(~.*0.00001, 
                                         ##labels = percent)) +
  labs(title = "",
       x = "Quarters",
       y = "Values",
       fill = "Legend",
       caption = "Data source: Action HIV Project") +
  scale_fill_manual(values = c("Total HTS Tests Positive" = light_blue, "Total HTS Tests" = web_blue, "Linkage (%) Overall" = rich_black)) +
  scale_color_manual(values = c("Linkage (%) Overall" = rich_black)) +
  theme_minimal() +
  theme(legend.position = "top")

