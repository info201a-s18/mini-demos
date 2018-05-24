##### DATA TRANSFORMATION #####
# Code used to transform/tokenize books data for analyzing data in
# `analyze_books.R` exercise. You don't need to touch this file! :)

library(janeaustenr)
library(dplyr)
library(stringr)
library(tidytext)

books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", 
                                                 ignore_case = TRUE)))) %>%
  ungroup() %>%
  unnest_tokens(word, text)
write.csv(books, './austen_books.csv', row.names = FALSE)
