
library("tidyverse")
library("lubridate")

tdb_data <- read_csv("Stata 4.csv")

unique(tdb_data)

glimpse(tdb_data)

tdb_data.r <- tdb_data %>%
  select(province, facility_name, tdb_creation_date, user_ips, most_recent_interaction_date)

tdb_data.r <- tdb_data.r %>%
  filter(complete.cases(.))

#tdb_data.r$creation_date <- mdy(tdb_data.r$tdb_creation_date)

tdb_data.r

tdb_data.r <- tdb_data.r %>%
  mutate(province=as.factor(province), facility_name=as.factor(facility_name), user_ips=as.factor(user_ips), 
         tdb_creation_date=as.Date(tdb_creation_date, format = "%m/%d/%Y"), 
         most_recent_interaction_date=as.Date(most_recent_interaction_date, format = "%m/%d/%Y"))

tdb_data.r

tdb_data.r <- tdb_data.r %>%
  mutate(month_tdb_created=month(tdb_creation_date))

tdb_data.r <- tdb_data.r %>%
mutate(tdb_creation_date = str_sub(tdb_creation_date,
                          # start=1,
                          # end=nchar(tdb_creation_date)-5),
       month = factor(tdb_creation_date,
                      levels=c("January","February","March","April","May","June","July","August","September","October","November","December")),
       month_code = as.numeric(month), 
       year = str_sub(tdb_creation_date, 
                      start=nchar(tdb_creation_date)-4,
                      end=nchar(tdb_creation_date)),
       monyr = paste(month_code, year, sep="-"),
       mnthyr = my(monyr))

tdb_data.r <- tdb_data.r %>%
  mutate(month_tdb_created=as.factor(month_tdb_created))

tdb_data.r

grph_province_ip <- ggplot(data = tdb_data.r) +
  geom_bar (mapping=aes(x=province, fill=user_ips))

#grph_ip_province <- ggplot(data = tdb_data.r) +
  #geom_bar (mapping=aes(x=user_ips, fill=province)) +
  #ggtitle("TDB Submission by Province & Implementing Partner | November 2022 Submission",
          #subtitle = "Source: TDB Submission Portal")

 ggplot(data = tdb_data.r) +
  geom_bar (mapping=aes(x=province, fill=user_ips)) +
  ggtitle("TDB Submission by Province & Implementing Partner | January 2023 Submission",
          subtitle = "Source: TDB Submission Portal") +
  ylab("Number of TDBs") +
  xlab("Province") 

ggplot(data = tdb_data.r) +
  geom_bar (mapping=aes(x=user_ips, fill=month_tdb_created)) +
  ggtitle("TDB Submission by Implementing Partner & Creation Month | January 2023 Submission",
          subtitle = "Source: TDB Submission Portal") +
  ylab("Number of TDBs") +
  xlab("Implementing Partner") 

grph_province_ip

grph_ip_creation_month

old_tdb_r <- tdb_data.r %>%
  filter(most_recent_interaction_date < "2022-11-21") %>%
  mutate(month_most_recent_interact_date=month(most_recent_interaction_date)) %>%
  mutate(month_most_recent_interact_date=as.factor(month_most_recent_interact_date)) 

old_tdb_r <- old_tdb_r %>%
  filter(most_recent_interaction_date > "1900-01-02")
  

old_tdb_r$month_most_recent_interact_date

glimpse(old_tdb_r)

#fct_recode(month_tdb_created, Jan = "1", Sep = "9", Oct = "10", Nov = "11", Dec = "12")

ggplot(data = old_tdb_r) +
  geom_bar (mapping=aes(x=user_ips, fill=month_most_recent_interact_date)) +
  ggtitle("Old TDBs by IP and Month of Last Interaction | January 2023 Submission", 
          subtitle = "Source: TDB Submission Portal") +
  ylab("Number of Old TDBs") +
  xlab("Implementing Partner") 

ggplot(data = old_tdb_r) +
  geom_bar (mapping=aes(x=user_ips, fill=facility_name)) +
  ggtitle("Old TDBs by IP and Facility | November 2022 Submission", 
          subtitle = "Source: TDB Submission Portal") +
  ylab("Number of Old TDBs") +
  xlab("Implementing Partner") 


old_tdb_r$most_recent_interaction_date
