# remove grassland & periodically herbaceous (mainly crops)

library(terra)

# load stack
filtered_stack2 <- rast("env_variables/stacks/stack_filtered2.tif")
names(filtered_stack2)

remove_variables <- c("d_grassland",                   
                      "d_periodically_herb")       

# save the filtered  stack
# Filter stack
stack_filtered3 <- filtered_stack2[[!names(filtered_stack2) %in% remove_variables]]
names(stack_filtered3)
names(stack_filtered3) <- c("NDMI", "NDVI", 
                            "fog", "wind_speed", 
                            "canopy_height", "tree_density",
                            "dist_fayal_brezal", "dist_wild_grass",
                            "dist_shrubs", "dist_tree_edge",
                            "aspect", "curvature", 
                            "DEM", "hillshade", 
                            "slope", "TRI")
# Save filtered stack
writeRaster(stack_filtered3, "env_variables/stacks/stack_filtered3.tif", overwrite = TRUE)

