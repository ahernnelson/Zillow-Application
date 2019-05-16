pacman::p_load("dplyr","ggplot2","tidyr","lubridate")
data_1 <- read.csv("ZHVI.csv")
data_2 <- read.csv("P2RR.csv")
data_3 <- read.csv("BSI.csv")
data_4 <- read.csv("Price_Cut.csv")
colnames(data_1)[1] <- "ID"
colnames(data_2)[1] <- "ID"
colnames(data_3)[1] <- "ID"
colnames(data_4)[1] <- "ID"
data_1 %>% select(-one_of(c("ID","CountyName", "SizeRank"))) -> data_1
data_2 %>% select(-one_of(c("ID","CountyName", "SizeRank"))) -> data_2
data_3 %>% select(-one_of(c("ID", "SizeRank", "RegionType", "MSARegionID"))) %>% 
  rename(State = StateName, Metro=MSA) -> data_3
data_4 %>% select(-one_of(c("ID","County", "SizeRank"))) -> data_4
#### Merge Data
data_1 %>% gather(date, zhvi, -one_of(c("RegionName","City","State","Metro"))) %>%
  mutate(date=as.numeric(substr(date,2,5))) -> data_1
data_2 %>% gather(date, p2rr, -one_of(c("RegionName","City","State","Metro"))) %>%
  mutate(date=as.numeric(substr(date,2,5))) -> data_2
data_3 %>% gather(date, bsi, -one_of(c("RegionName","State","Metro"))) %>%
  mutate(date=as.numeric(substr(date,2,5))) -> data_3
data_4 %>% gather(date, pcut, -one_of(c("RegionName","City","State","Metro"))) %>%
  mutate(date=as.numeric(substr(date,2,5))) -> data_4

