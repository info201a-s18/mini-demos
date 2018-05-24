# install.packages('dplyr')
# install.packages('stringr')
# install.packages('tidytext')
# install.packages('tidyr')
# install.packages('ggplot2')

library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)
library(ggplot2)

##### LEXICONS #####
# Use the get_sentiments() function to get your dictionary of positive
# and negative words. Use the lexicon which categorizes words into
# positive and negative.
bing_sentiments <- get_sentiments("bing")

##### DATA ANALYSIS + WRANGLING #####
# Read books data in 
books <- read.csv('./data/austen_books.csv', stringsAsFactors = FALSE)

# Map each word in the 'books' dataset to its dictionary-prescribed sentiment.
jane_austen_sentiment <- books %>%
  inner_join(bing_sentiments, by = "word")


# Instead of having each individual word, count the number of positive/negative
# words in each chapter.
jane_austen_sentiment <- jane_austen_sentiment %>%
  count(book, chapter, sentiment) %>%
  spread(sentiment, n, fill = 0)


# A chapter's overarching feeling will be calculated by the number of positive
# words minus the number of negative words. Create a new column called 
# 'sentiment' with this value.
jane_austen_sentiment <- jane_austen_sentiment %>%
  mutate(sentiment = positive - negative)


##### CREATE OUR VISUALIZATION #####
# Use ggplot to plot each chapter's sentiment by book.
ggplot(jane_austen_sentiment, aes(chapter, sentiment, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = 'free_x')
