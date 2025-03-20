#load library
library(terra)

# Load data
filtered_stack <- rast("env_variables/stacks/stack_filtered6.tif")
occ_data <- read.csv("occurences/Ariagona_margaritae_Alles.csv", sep = ",")  


#filter data for 2023
# occ_data <- occ_data %>%
#   mutate(collection_date = as.Date(collection_date, format = "%d.%m.%Y"))
#occ_data23 <- occ_data %>%
#  filter(collection_date >= as.Date("2023-07-01") & collection_date <= as.Date("2023-08-31"))


# Extract and clean coordinates 
# only for rows which are not potential collection points and have exact coordinates
occ.std <- occ_data[!is.na(occ_data$Specimen_ID) & occ_data$Specimen_ID != "", c("WGS84_X", "WGS84_Y")]
# Remove duplicate coordinate pairs
occ.std <- occ.std[!duplicated(occ.std),]                            
# Replace commas with dots and convert to numeric values
occ.std$WGS84_X <- as.numeric(sub(",", ".", occ.std$WGS84_X))
occ.std$WGS84_Y <- as.numeric(sub(",", ".", occ.std$WGS84_Y))
# Remove rows with missing values (NA)
occ.std <- occ.std[complete.cases(occ.std), ]

#transform to same crs
# Create a SpatVector from point coordinates with WGS84 as the original CRS
occ.std_sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
# Transform the point coordinates to the same CRS as the raster (UTM Zone 28N)
occ.std_utm_sf <- st_transform(occ.std_sf, crs = 32628)

# Extract the transformed coordinates as a matrix for terra::extract()
occ.std_matrix <- st_coordinates(occ.std_utm_sf)

# Extract raster cell numbers and values
occs.cells <- terra::extract(filtered_stack, occ.std_matrix, cells = TRUE)
occs.values <- terra::extract(filtered_stack, occ.std_matrix)

# Combine coordinates, extracted cell numbers, and raster values
combined_data <- cbind(occ.std_matrix, occs.cells[, "cell", drop = FALSE], occs.values)

# Print the result to check if extraction worked
head(combined_data)

# Save combined data to CSV
write.csv(combined_data, "occurences/Ariagona_in_env.csv", row.names = FALSE)


