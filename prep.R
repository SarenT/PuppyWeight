library(tidyr)
library(lubridate)

day_of_birth = as.Date("2024-03-02")

ws = read.csv("~/git/puppies/weights_new.csv", header = F) %>% as_tibble()
colnames(ws) = unname(as.character(ws %>% filter(V1 == "days")))
ws = ws %>% filter(days != "days") 

colnames(ws)[1] = "name"

ws = ws %>% pivot_longer(cols = !name, names_to = "date", values_to = "weight", names_repair = "unique", values_drop_na = T)

ws = ws %>% mutate(date = days(date) + day_of_birth)

write.csv(ws, "~/git/puppies/weights_long.csv", row.names = F)