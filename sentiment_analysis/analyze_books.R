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




##### DATA ANALYSIS + WRANGLING #####
# Read books data in 





# Map each word in the 'books' dataset to its dictionary-prescribed sentiment.





# Instead of having each individual word, count the number of positive/negative
# words in each chapter.





# A chapter's overarching feeling will be calculated by the number of positive
# words minus the number of negative words. Create a new column called 
# 'sentiment' with this value.





##### CREATE OUR VISUALIZATION #####
# Use ggplot to plot each chapter's sentiment by book.





