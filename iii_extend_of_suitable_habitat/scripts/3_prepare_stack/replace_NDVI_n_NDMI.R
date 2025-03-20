# NDVI and NDMI are replaced
# load rasters
NDVI <- rast("env_variables/originals/vegetation_n_moisture_indices2/NDVI_Mean_2015_2024.tif")
NDMI <- rast("env_variables/originals/vegetation_n_moisture_indices2/NDMI_Mean_2015_2024.tif")
filtered_stack5 <- rast("env_variables/stacks/stack_filtered5.tif")

# remove NDVI and NDMI from filtered_stack5
remove_variables <- c("NDMI", "NDVI")
stack_without_NDindices <- filtered_stack5[[!names(filtered_stack5) %in% remove_variables]]

# adjust NDVI and NDMI to the size of stack_without_NDindices 
NDVI_projected <-  project(NDVI, stack_without_NDindices$fog)
NDMI_projected <-  project(NDMI, stack_without_NDindices$fog)

# combine the stack with the new indices
filtered_stack6 <- c(stack_without_NDindices, NDVI_projected, NDMI_projected)

# save the new stack
writeRaster(filtered_stack6, "env_variables/stacks/stack_filtered6.tif", overwrite = TRUE)