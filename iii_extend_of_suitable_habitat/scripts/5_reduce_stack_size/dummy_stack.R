# creating dummy_stack
library(terra)

# load data
stack <- rast("env_variables/stacks/stack_filtered6.tif")

#change resolution to 20 x 20 m
stack_20x20 <- aggregate(stack, fact=2, fun=mean, na.rm=TRUE)

# save dummy file
writeRaster(stack_20x20, "0_test/stack_filtered6_20x20.tif", overwrite =TRUE)