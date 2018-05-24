# Student sentence analysis - look at sentiments of students' sentences

# install.packages('syuzhet')
library(syuzhet)

# Create a vector of emotional sentences. 
# Add some happy ones, angry ones - you name it!
student_sentences <- c('I really like the pie you gave me this morning.', 
                       'Your shoes suck and are just plain ugly.',
                       'I\'d really truly love going out in this weather!'
                       )

# Analyze sentiment for student sentences
student_sentiments <- data.frame(sentiment = get_sentiment(student_sentences, 
                                                  method='syuzhet'))
student_analysis <- cbind(sentences = student_sentences, student_sentiments)
