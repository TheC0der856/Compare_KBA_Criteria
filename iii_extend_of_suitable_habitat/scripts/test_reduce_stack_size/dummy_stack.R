# creating dummy_stack
library(terra)

# load data
stack <- rast("env_variables/stacks/stack_filtered7.tif")

#change resolution to 50 x 50
stack_50x50 <- aggregate(stack, fact=5, fun=mean, na.rm=TRUE)

# save dummy file
writeRaster(stack_50x50, "0_test/stack_filtered7_50x50.tif", overwrite =TRUE )