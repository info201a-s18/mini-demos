#load library
library(class) #Has the knn function

#loading data
data("iris")

#Set the seed for reproducibility
set.seed(4948493) 

#Sample the Iris data set (70% train, 30% test)
ir_sample <- sample(1:nrow(iris),size=nrow(iris)*.7)
ir_train <- iris[ir_sample,] #Select the 70% of rows
ir_test <- iris[-ir_sample,] #Select the 30% of rows


#Find Accuracy of Prediction
accuracy = function(actual, predicted) {
  mean(actual == predicted)
}

#test for single k
pred <- knn(train = scale(ir_train[,-5]), 
           test = scale(ir_test[,-5]), 
           cl = ir_train$Species, 
           k = 40)

accuracy(ir_test$Species, pred)

#LOOP FOR MULTIPLE K's
k_to_try = 1:100
acc_k = rep(x = 0, times = length(k_to_try))

for(i in seq_along(k_to_try)) {
  pred <- knn(train = scale(ir_train[,-5]), 
             test = scale(ir_test[,-5]), 
             cl = ir_train$Species, 
             k = k_to_try[i])
  acc_k[i] <- accuracy(ir_test$Species, pred)
}

plot(acc_k, type = "b", col = "dodgerblue", cex = 1, pch = 20, 
     xlab = "k, number of neighbors", ylab = "classification accuracy",
     main = "Accuracy vs Neighbors")

# add lines indicating k with best accuracy
abline(v = which(acc_k == max(acc_k)), col = "darkorange", lwd = 1.5)

# add line for max accuracy seen
abline(h = max(acc_k), col = "grey", lty = 2)

