
library(terra)


# load stack
filtered_stack <- rast("env_variables/stacks/stack_filtered3.tif")

# NA values?
# plot(is.na(filtered_stack$curvature))
# yes, there are NA values!
# the ocean is NA, which is flat and should be 0
# negative values (< 0) → concave curvature (hollows, depressions, valleys)
# positive values (> 0) → convex curvature (ridges, crests, hills)
# flat or constant areas can lead to the division of 0, which can lead to NA values
# therefore we replace them with 0 

filtered_stack$curvature[is.na(filtered_stack$curvature)] <- 0


# Save filtered stack
writeRaster(filtered_stack, "env_variables/stacks/stack_filtered4.tif", overwrite = TRUE)
