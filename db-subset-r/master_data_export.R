library(DBI)
library(RSQLite)

con = dbConnect(SQLite(), dbname="mxm_dataset.db")
dbListTables(con)

myQuery <- dbSendQuery(con, "SELECT * FROM master_data")
my_data <- dbFetch(myQuery, n = -1)

head(my_data)

library(dplyr)
# add column to dataset with the number of characters in the word
my_data_2 <- my_data %>% mutate(word_length = nchar(my_data$word))
tail(my_data_2) # looks good

# export with stemmed lyrics 
write.csv(my_data_2, "data_stemmed.csv")

# import unstemmed lyrics
library(readr)
unstemmed <- read_csv('unstemmed_lyrics.csv')
unstemmed <- data.frame(unstemmed)
head(unstemmed)

my_data_3 <- left_join(my_data_2,unstemmed,by=c("word"="stemmed"))
head(my_data_3)
View(my_data_3)

write.csv(my_data_3, "data.csv")
