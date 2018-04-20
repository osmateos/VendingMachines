
# Load the trained model and input example
load("pricingModel.RData")
load("inputExample.RData")

# TODO: 1. Prepare the input (age, gender and productSelected) to use for prediction

inputExample[1,]$age <- 30
inputExample[1,]$gender <- "M"
inputExample[1,]$productSelected <- "coconut water"


# TODO: 2. Execute the prediction
prediction <- rxPredict(pricingModel, data = inputExample)
print(prediction)