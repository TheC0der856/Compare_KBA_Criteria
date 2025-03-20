# Define paths to vegetation and moisture indices
google_engine_directory <- "env_variables/originals/vegetation_n_moisture_indices/"
google_engine_file_names <- c(# "EVI_Mean_2015_2024.tif", # plot(google_fogwindcanopy_stack$EVI) the values are mostly 0, something is weared
                              "NDMI_Mean_2015_2024.tif", 
                              "NDVI_Mean_2015_2024.tif",
                              "SAVI_Mean_2015_2024.tif", 
                              "TC_Veg_Mean_2015_2024.tif",
                              "TC_Wet_Mean_2015_2024.tif")
google_engine_paths <- file.path(google_engine_directory, google_engine_file_names)

# Load rasters
google_engine_rasters <- lapply(google_engine_paths, rast)

# Stack rasters
google_engine_stack <- do.call(c, google_engine_rasters)

# Check stack
#names(google_engine_stack)