#Load packages
source("scripts/r prep2.r")

#Creating graph for disabilities by gender
# Create the data frame
data <- data.frame(
  Category = c("Mobility", "Spinal Cord", "Head Injuries", "Hearing", "Speech", "Cognitive", "Psychological", "Invisible"),
  Female = c(28, 11, 6, 8, 9, 9, 7, 7),
  Male = c(36, 9, 8, 8, 9, 9, 9, 7)
)

# Reshape the data to long format
data <- gather(data, key = "Gender", value = "Percent", -Category)

# Create the plot
plot <- ggplot(data, aes(x = Category, y = Percent, fill = Gender)) +
  geom_bar(stat = "identity", position = 'dodge') +
  geom_text(aes(label = paste0(Percent, "%"), vjust = -0.5), position = position_dodge(0.9)) +
  labs(
    #title = "Proportion of Disabilities of Participant by Gender",
    x = "Type of Disability",
    y = "Percent of Participants",
    fill = "Gender",
    #caption = "Data source: Provided"
  ) +
  scale_fill_manual(values = c(usaid_blue,light_blue)) +
  baseyNoGrid

# Display the plot
plot

ggsave("Viz/research/Disability.png",
       device="png",
       type="cairo",
       height=7,
       width=12)

#Creating graph for vaccinated & Not Vaccinated
# Create the data frame
data <- data.frame(
  Category = c("Mobility", "Spinal Cord", "Head Injuries", "Hearing", "Speech", "Cognitive", "Psychological", "Invisible"),
  Vaccinated = c(76, 20, 14, 25, 17, 16, 14, 14),
  Not_Vaccinated = c(71, 23, 16, 25, 20, 22, 18, 15)
)

# Reshape the data to long format
data <- gather(data, key = "Gender", value = "Percent", -Category)

# Create the plot
plot <- ggplot(data, aes(x = Category, y = Percent, fill = Gender)) +
  geom_bar(stat = "identity", position = 'dodge') +
  geom_text(aes(label = paste0(Percent, "%"), vjust = -0.5), position = position_dodge(0.9)) +
  labs(
    #title = "Proportion of Vaccinations among Participants",
    x = "Type of Disability",
    y = "Proportion of the uptake and \nnon-uptake of the COVID-19 Vaccine",
    fill = "Gender",
    #caption = "Data source: Provided"
  ) +
  scale_fill_manual(values = c(usaid_blue,light_blue)) +
  baseyNoGrid

# Display the plot
plot

ggsave("Viz/research/vaccination.png",
       device="png",
       type="cairo",
       height=7,
       width=12)
