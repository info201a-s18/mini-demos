# First, install the keras R package from GitHub as follows:
devtools::install_github("rstudio/keras")

# The Keras R interface uses the TensorFlow backend engine by default.
# To install both the core Keras library as well as the TensorFlow backend use the install_keras() function:
library(keras)
install_keras()

# Load in a pretrained model: Using Inception V3 with ImageNet weights
model <- application_inception_v3(weights = "imagenet")

# Load in image from `imgs` directory. Images include that of an elephant, hamster, apples and oranges
# Feel free to add your own images to the directory to test the model
img_path <- "./imgs/elephant.jpg"
img <- image_load(img_path, target_size = c(299, 299))

# Convert img to an array for tensor calculations
img_array <- image_to_array(img)

# Ensure we have a 4d tensor with single element in the batch dimension
img_tensor <- array_reshape(img_array, c(1, dim(img_array)))

# Process the input so that it can be used for prediction
processed_tensor <- inception_v3_preprocess_input(img_tensor)

# Make a prediction based on the model
predictions <- model %>% predict(processed_tensor)
imagenet_decode_predictions(predictions, top = 10)[[1]]
