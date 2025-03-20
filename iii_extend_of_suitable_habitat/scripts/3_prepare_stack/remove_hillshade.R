# > combined_data$hillshade
#  [1]  0.001656465  0.199816197  0.003042341  0.083328679 -0.569725990  0.080414481 -0.617163301 -0.195704520 -0.680474162 -0.307121217 -0.369735867
# [12] -0.167823493  0.366316736  0.374578029  0.783469498 -0.688120961 -0.451326996 -0.688120961  0.047493700  0.613200724 -0.452174217 -0.626182437
# [23] -0.490629762 -0.746661663  0.662148535  0.697792172 -0.331953138  0.151486069 -0.413477719  0.206669927  0.017258203 -0.283773005 -0.002912910
# [34] -0.427682579  0.325436920 -0.121392332  0.207090303  0.304601818  0.524084985 -0.167906657 -0.681935191 -0.476740927  0.078163542 -0.777871847
# > filtered_stack$hillshade
# class       : SpatRaster 
# dimensions  : 10187, 20308, 1  (nrow, ncol, nlyr)
# resolution  : 10, 10  (x, y)
# extent      : 187460, 390540, 3060760, 3162630  (xmin, xmax, ymin, ymax)
# coord. ref. : WGS 84 / UTM zone 28N (EPSG:32628) 
# source      : stack_filtered4.tif 
# name        :  hillshade 
# min value   : -0.9978132 
# max value   :  0.9991765 
# > mean(combined_data$hillshade)
# [1] -0.113831
# > 

# there is no obvious pattern, that's why I am going to remove hillshade from the model. All others seem to have a pattern! :)



library(terra)

# load stack
filtered_stack4 <- rast("env_variables/stacks/stack_filtered4.tif")

# remove hillshade
remove_variables <- c("hillshade")
# save the filtered  stack
# Filter stack
stack_filtered5 <- filtered_stack4[[!names(filtered_stack4) %in% remove_variables]]
names(stack_filtered5)

# Save filtered stack
writeRaster(stack_filtered5, "env_variables/stacks/stack_filtered5.tif", overwrite = TRUE)