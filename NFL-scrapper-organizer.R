library(tidyverse)


setwd("/Users/gather3/Documents/General Coding/NFLscraping/NFLscraping")
NFL <- read.csv("1.csv")


NFL$Bornplace <- gsub(": ", "", NFL$Bornplace  )
NFL$Bornplace <- gsub("(\\n|\\t)", "", NFL$Bornplace  )
NFL$Bornplace <- gsub(": ", "", NFL$Bornplace  )
NFL$Bornplace <- gsub("(^[0-9]{1,2})\\/([0-9]{1,2})\\/([0-9]{4})", "\\2\\/\\1\\/\\3 ,", NFL$Bornplace)
NFL$Bornplace <- gsub("(.*?) , (.*) {2,}(.*)$", "\\1 , \\2 , \\3",  NFL$Bornplace)

NFL$College <- gsub(": ", "", NFL$College  )
NFL$College <- gsub("\\(.*\\)", "", NFL$College )
NFL$Experience <- gsub(": ", "", NFL$Experience  )
NFL$HS <- gsub(": ", "", NFL$HS  )
NFL$HOF <- gsub(": ", "", NFL$HOF  )

NFL <- NFL %>% separate(Bornplace, c('Date_Birth', 'Place_Birth', "State"), sep = " , " )

write.csv(NFL, file = "NFL-player-bio.csv", row.names = F)



Income <- read.csv('kaggle_income.csv')
