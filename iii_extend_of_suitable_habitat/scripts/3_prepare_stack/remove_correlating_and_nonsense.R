
library(terra)
library(corrplot) # corrplot()
library(caret)    # findCorrelation()



# load stack
all_stack <- rast("iii_extend_of_suitable_habitat/env_variables/stacks/all_stack.tif")


######### collect information about NA/ NaN values
# find layers with NA values
layers_with_na <- sapply(1:nlyr(all_stack), function(i) {
  any(is.na(values(all_stack[[i]])))
})
layer_names_with_na <- names(all_stack)[layers_with_na] #"NDMI"      "NDVI"      "SAVI"      "TC_Veg"    "TC_Wet"    "curvature"
#plot(is.na(all_stack[[1]]), main = "NA Values in NDMI") #"NDMI"      "NDVI"      "SAVI"      "TC_Veg"    "TC_Wet" --> NA values are in the ocean
#plot(is.na(all_stack$curvature), main = "NA Values in curvature") # mainly ocean is NA, but also some points within the islands.



######## extract pixel values (create a matrix) without NaN values
# Extract pixel values
# how many layers?
#nlyr(all_stack) #37
# at which places are the NaN?
matrix_NaN <- terra::as.matrix(all_stack[[layer_names_with_na]]) # all layers with NaN as matrix
# identifies rows that are without NaN 
no_NaN_rows <- apply(matrix_NaN, 1, function(row) {
  all(complete.cases(row))  
})
# create a vector demonstrating if is there are NaN (FALSE) or not (TRUE) in at least one of the layers
no_NaN <- as.logical(no_NaN_rows)

# create matrices including pixel without NaN only
matrix1_5   <- terra::as.matrix(all_stack[[1:5]]) # create matrix
matrix1_5_noNaN <- matrix1_5[no_NaN, ]            # only include complete cases

matrix6_10  <- terra::as.matrix(all_stack[[6:10]])
matrix6_10_noNaN <- matrix6_10[no_NaN, ]

matrix11_15 <- terra::as.matrix(all_stack[[11:15]])
matrix11_15_noNaN <- matrix11_15[no_NaN, ]

matrix16_20 <- terra::as.matrix(all_stack[[16:20]])
matrix16_20_noNaN <- matrix16_20[no_NaN, ]

matrix21_25 <- terra::as.matrix(all_stack[[21:25]])
matrix21_25_noNaN <- matrix21_25[no_NaN, ]

matrix26_30 <- terra::as.matrix(all_stack[[26:30]])
matrix26_30_noNaN <- matrix26_30[no_NaN, ]

matrix31_35 <- terra::as.matrix(all_stack[[31:35]])
matrix31_35_noNaN <- matrix31_35[no_NaN, ]

matrix36_37 <- terra::as.matrix(all_stack[[36:37]])
matrix36_37_noNaN <- matrix36_37[no_NaN, ]

# # check if they all have the same amount of rows
# row_counts <- sapply(list(matrix1_5_noNaN, 
#                           matrix6_10_noNaN, 
#                           matrix11_15_noNaN, 
#                           matrix16_20_noNaN, 
#                           matrix21_25_noNaN, 
#                           matrix26_30_noNaN, 
#                           matrix31_35_noNaN, 
#                           matrix36_37_noNaN), nrow)
# all(row_counts == row_counts[1])
# TRUE



# cleaning
# clean global environment
keep_objects <- ls(pattern = "_noNaN$")  # only keep objects ending with "_noNaN" 
rm(list = setdiff(ls(), keep_objects)) 
# clean RAM
gc() 

# combine
all_matrix <- cbind(matrix1_5_noNaN, 
                    matrix6_10_noNaN, 
                    matrix11_15_noNaN, 
                    matrix16_20_noNaN, 
                    matrix21_25_noNaN, 
                    matrix26_30_noNaN, 
                    matrix31_35_noNaN, 
                    matrix36_37_noNaN)


# ### CORRELATION  ###
# Compute correlation matrix
# package stats: pearson correlation
# plot(all_stack$d_abandoned_farms, all_stack$d_low_growing_woody_plants)
# plot(all_stack$d_treeedge_Copernicus, all_stack$d_coniferous_forest)
# yes, we can use a pearson correlation
correlation_matrix <- cor(all_matrix) 
# corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", tl.cex = 0.8) # visualisation


########### FILTERING ####
# find highly correlated variables
highly_correlated <- findCorrelation(correlation_matrix, cutoff = 0.8, names = TRUE)
# find a highly correlated pairs
highly_correlated_matrix <- correlation_matrix[highly_correlated, ]
higly_correlated_pairs <- which(abs(correlation_matrix[highly_correlated, ]) > 0.8, arr.ind = TRUE)
# find names
high_corr_vars <- data.frame(
  Variable1 = rownames(highly_correlated_matrix)[higly_correlated_pairs[, 1]],
  Variable2 = colnames(highly_correlated_matrix)[higly_correlated_pairs[, 2]],
  Correlation =highly_correlated_matrix[higly_correlated_pairs]
)
# print them without self correlation: 
high_corr_vars[high_corr_vars$Variable1 != high_corr_vars$Variable2, ]
# here it is very interesting to see that active and abandoned farms are highly correlating with distance to low growing woody features
# forestedge (Copernicus) is correlating very strong with coniferous forest, therefore it is nonsense to test for forest type and egde to forest/trees

remove_variables <- c("SAVI",                    # prefer NDVI, more common, could think about taking TC_Veg instead because it is more sensitive towards the helth of the plants
                      "TC_Veg",                  # "
                      "TC_Wet",                  # prefer NDMI, more common, also better because water in plants is considered as well
                      "d_active_farms",          # prefer distance to low growing woody features
                      "d_abandoned_farms",       # "
                      "d_forest_Copernicus",     # prefer forest edge, view RedList habitat description
                      "d_forest_Cabildo",        # prefer forest edge
                      "d_trees_Copernicus",      # prefer tree edge
                      "d_trees_Cabildo",         # prefer tree edge
                      "d_forestedge_Copernicus", # (very similar to tree edge: prefer tree edge, because they match the data better) 
                      "d_forestedge_Cabildo",    # (very similar to tree edge: prefer tree edge, because they match the data better)
                      "d_broadleaf_forest",      # distinction does not make sense, because forest edge is correlated to forest type
                      "d_coniferous_forest",     # distinction does not make sense, because forest edge is correlated to forest type
                      "d_pinar_cipreses",        # distinction does not make sense, because forest edge is correlated to forest type (pinar & cipreses are main components of coniferous forests)
                      "d_water_wetness",         # (does not make sense to include it from the beginning, I have fog included, much  better)
                      "d_imperviousness")        # (it is better to ask what the species needs and not what is does not need. imperviousness is determined by human preferences that could match the crickets in some ways, it would be hard to explain that with the model)


# save the filtered  stack
# load stack
all_stack <- rast("env_variables/stacks/all_stack.tif")
# Filter stack
stack_filtered1 <- all_stack[[!names(all_stack) %in% remove_variables]]
# Save filtered stack
writeRaster(stack_filtered1, "env_variables/stacks/stack_filtered1.tif", overwrite = TRUE)

# Check updated names
print(names(stack_filtered1))





