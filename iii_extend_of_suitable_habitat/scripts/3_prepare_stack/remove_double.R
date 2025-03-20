library(terra)

# load stack
filtered_stack1 <- rast("env_variables/stacks/stack_filtered1.tif")
names(filtered_stack1)

remove_variables <- c("d_herbazales",                   
                      "d_matorrales",                  
                      "d_treeedge_Cabildo")       

# save the filtered  stack
# Filter stack
stack_filtered2 <- filtered_stack1[[!names(filtered_stack1) %in% remove_variables]]
names(stack_filtered2)
# Save filtered stack
writeRaster(stack_filtered2, "env_variables/stacks/stack_filtered2.tif", overwrite = TRUE)

