# install.packages('recommenderlab')
# install.packages('data.table')
# install.packages('reshape2')
# install.packages('ggplot2')

library(recommenderlab)
library(data.table)
library(reshape2)
library(ggplot2)

# Read in the movies and ratings data sets
movies <- read.csv("data/movies.csv", stringsAsFactors = FALSE)
ratings <- read.csv("data/ratings.csv", stringsAsFactors = FALSE)

# Extract genre from movies data frame
genres <- as.data.frame(movies$genres, stringsAsFactors = FALSE)

genres <- as.data.frame(tstrsplit(genres[,1], '[|]', type.convert = TRUE), stringsAsFactors = FALSE)
colnames(genres) <- c(1:10)
genre_list <- c("Action", "Adventure", "Animation", "Children", 
                "Comedy", "Crime","Documentary", "Drama", "Fantasy",
                "Film-Noir", "Horror", "Musical", "Mystery","Romance",
                "Sci-Fi", "Thriller", "War", "Western") 

# Creates a matrix for the number of movies + 1 and the number of genres
genre_matrix <- matrix(0, 9126, 18)
# Set first row to genre list
genre_matrix[1,] <- genre_list
# Set column names to genre list
colnames(genre_matrix) <- genre_list

# Iterate through matrix
for (i in 1:nrow(genres)) {
  for (c in 1:ncol(genres)) {
    genmat_col = which(genre_matrix[1,] == genres[i,c])
    genre_matrix[i + 1,genmat_col] <- 1
  }
}

# Convert the matrix into a data frame
# Remove first row, which was the genre list
genre_matrix <- as.data.frame(genre_matrix[-1,], stringsAsFactors = FALSE) 
# Convert from characters to integers
for (c in 1:ncol(genre_matrix)) {
  genre_matrix[,c] <- as.integer(genre_matrix[,c])  
} 

# Create search matrix
search_matrix <- cbind(movies[,1:2], genre_matrix)

# Create ratings matrix. Rows = userId, Columns = movieId
rating_matrix <- dcast(ratings, userId~movieId, value.var = "rating", na.rm = FALSE)
# Remove userId's
rating_matrix <- as.matrix(rating_matrix[,-1])
# Convert rating matrix into a recommenderlab sparse matrix
rating_matrix <- as(rating_matrix, "realRatingMatrix")
rating_matrix

# Selecting relevant data
# Select minimum number of users per rated movie
# and the minimum views per user
ratings_movies <- rating_matrix[rowCounts(rating_matrix) > 50,
                            colCounts(rating_matrix) > 50]
ratings_movies

# Normalize the data
# Remove bias instances of data 
# Averages the rating for each user to 0
normalized_ratings_movies <- normalize(ratings_movies)
sum(rowMeans(normalized_ratings_movies) > 0.00001)


# Define training and set data
training <- sample(x = c(TRUE, FALSE), 
                      size = nrow(ratings_movies),
                      replace = TRUE, 
                      prob = c(0.8, 0.2))

training_data <- ratings_movies[training, ]
test_data <- ratings_movies[!training, ]

# Building the recommendation model
recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
recommender_models$IBCF_realRatingMatrix$parameters

recc_model <- Recommender(data = training_data, 
                          method = "IBCF",
                          parameter = list(k = 30))

recc_model

# Applying the recommender system on the original dataset

# No. of recommendations we want per user 
recommendations <- 10

prediction <- predict(object = recc_model, 
                          newdata = test_data, 
                          n = recommendations)
prediction

# Recommendations for the first user
user_1_recommendations <- prediction@items[[1]] 
movies_user_1 <- prediction@itemLabels[user_1_recommendations]
movies_user_2 <- movies_user_1
for (i in 1:10) {
  movies_user_2[i] <- as.character(subset(movies, 
                                          movies$movieId == movies_user_1[i])$title)
}
movies_user_2

# A matrix of recommendations for each user
recc_matrix <- sapply(prediction@items, 
                      function(x){ as.integer(colnames(ratings_movies)[x]) })
recc_matrix[,1:4]

