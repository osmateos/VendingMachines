# TODO: 1. Load packages needed for operationalization
# TODO: 1. Load packages needed for operationalization
usePackage <- function(p) {
    if (!is.element(p, installed.packages()[, 1]))
        install.packages(p, dep = TRUE)
    library(p, character.only = TRUE)
}
usePackage("curl")
usePackage("ggplot2")
usePackage("mrsdeploy")
usePackage("RevoScaleR")




# TODO: 2. Configure remote login
# Connect to R Server VM using remoteLogin
# TODO: 2. Configure remote login
remoteLogin(
deployr_endpoint = "http://52.179.185.37:12800",
username = "admin",
password = "Password.1az"
)
pause()


# Wrap model in an R function
apiPredictPurchasePrice <- function(age, gender, productSelected) {
    require(RevoScaleR);
    genders <- factor(c("M", "F"))
    products <- factor(c("coconut water", "soda", "water"))
    myInput <- data.frame(age = as.numeric(age),
                        purchasePrice = 1,
                        gender = genders[2],
                        productSelected = products[3]
    )
    myInput[1,]$age <- age
    myInput[1,]$gender <- gender
    myInput[1,]$productSelected <- productSelected
    prediction <- rxPredict(modelObject = pricingModel, data = myInput)
    purchasePrice <- prediction$purchasePrice_Pred
}

##########################################################
#             Publish Model as a Service                 #
##########################################################

# Generate a unique service name and assign to variable serviceName
serviceName <- "apiPredictPurchasePrice"

# Set `data-dir` to NULL, which will make the model file path
# below based off the PricingModel project path
serviceOption()$set("data-dir", NULL)

# Publish as service using publishService() function from 
# mrsdeploy package. Name service and provide unique
# version number. Assign service to the variable `api`
try(deleteService(serviceName, "1.0"))
api <- publishService(
     serviceName,
     code = apiPredictPurchasePrice,
     model = "pricingModel.RData",
     inputs = list(age = "numeric", gender = "character", productSelected = "character"),
     outputs = list(purchasePrice = "numeric"),
     v = "1.0"
)

print("Published service")

# TODO: 3. Consume the API as a test
# Get the published API service (getService), execute apiPredictPurchasePrice with variables
# and print the result's "answer" output.
# TODO: 3. Consume the API as a test
services <- listServices("apiPredictPurchasePrice")
serviceName <- services[[1]]
api <- getService(serviceName$name, serviceName$version)
result <- api$apiPredictPurchasePrice(30, "F", "coconut water")
print("Result: ")
print(result$output("answer"))
result


# TODO: 4. Generate the Swagger JSON file for the API
# Save the generated JSON file to the project directory

swagger <- api$swagger()
cat(swagger, file = "swagger.json", append = FALSE)
