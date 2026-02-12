library(dplyr)
edu_byregion <- TenderosFU03_Publica %>%
group_by(Munic_Dept) %>%
  summarise(internet= mean(uso_internet))
