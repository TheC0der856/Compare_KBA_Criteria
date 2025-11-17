# range needs to be created newly, because occurence points are not matching the RedList file!
# crs = 32628

library(sf)
library(dplyr)
library(terra)

# intersect of fayal brezal + 150m , tree edge buffer 500, occurrences buffer (750)

# occurrence buffer:
# load occurrence data
occ_data <-  read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv", sep = ",")
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
# load them sf object
occurrences_sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
#transform coordinate system
occurrences_sf <- st_transform(occurrences_sf, crs = 32628)
# Create a buffer around occurrences_sf with a radius of 4km 
occurrences_buffer <- st_buffer(occurrences_sf, dist = 4000)
# Merge (union) all the buffer polygons into one single polygon
united_occurrences_buffer <- st_union(occurrences_buffer)
#plot(united_occurrences_buffer)

#fayal-brezal buffer
# paths
formaciones_forestales_path = "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
# Load data
formaciones_forestales <- st_read(formaciones_forestales_path)
# extrakt fayal brezal areas
fayal_brezal_areas <- formaciones_forestales %>%
  filter(formaciones_forestales$accurate_vegetation_classification == "Fayal_brezal")
# megre them
fayal_brezal_merged <- st_union(fayal_brezal_areas)
# one row
fayal_brezal_sf <- st_sf(geometry = fayal_brezal_merged)
#transform coordinate system
fayal_brezal_sf <- st_transform(fayal_brezal_sf, crs = 32628)
#plot(fayal_brezal_sf)
fayal_brezal_buffer <- st_buffer(fayal_brezal_sf, dist = 200)
#plot(fayal_brezal_buffer)

# tree edge buffer 
# Paths
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Small_Woody_Features_path = "env_variables/processed/Small_Woody_Features/Small_Woody_Features.tif"
# Load raster
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
Small_Woody_Features_raster <- rast(Small_Woody_Features_path)
# 1. Create forest data
# 1.1 Copernicus forest: Reclassify the raster to have two values: 0 = no forest, 1 = forest
Forest_raster <- classify(Dominant_Forest_Type_raster, cbind(2, 1))
# 2. Combine both rasters
# Align Small Woody Features to the Dominant Forest Type raster
Small_Woody_Features_raster_aligned <- resample(Small_Woody_Features_raster, Forest_raster, method = "near")
# Create the combined raster (forest or small woody features)
Trees_raster <- mosaic(Forest_raster, 
                       Small_Woody_Features_raster_aligned, 
                       fun = max)
# switch values, so forestedge will be 0 in the end
Trees_raster[Trees_raster == 0] <- 2
Trees_raster[Trees_raster == 1] <- 0
Trees_raster[Trees_raster == 2] <- 1
# 3. Create forest edge
# exclude 0 values, otherwise the edge of 0 values is calculated
Trees_raster_filtered <- mask(Trees_raster, Trees_raster == 0, maskvalues = FALSE)
# convert into polygons
Trees_polygons <- as.polygons(Trees_raster_filtered, dissolve = TRUE)
# convert terra-polygons into sf-object
Trees_polygons_sf <- st_as_sf(Trees_polygons)
#it needs to be simplified otherwise it is calculating to long, and we have a very huge buffer zone, no need for details
Trees_polygons_sf_simplified <- st_simplify(Trees_polygons_sf, dTolerance = 100) # could be changed to 50?
# create multiple lines around the polygons
Treeedge_sf <- st_cast(Trees_polygons_sf_simplified, "MULTILINESTRING")
#transform coordinate system
Treeedge_sf <- st_transform(Treeedge_sf, crs = 32628)
#merge the lines
Treeedge_sf_merged <- st_union(Treeedge_sf)
# create buffer
tree_edge_buffer <- st_buffer(Treeedge_sf_merged , dist = 200) 
#plot(tree_edge_buffer)


# create the intersection
intersection_buffer <- st_intersection(united_occurrences_buffer, fayal_brezal_buffer, tree_edge_buffer)
#plot(intersection_buffer)
# the buffer calculation would be to calculation intensive thats why we have to simplify
intersection_simplified <- st_simplify(intersection_buffer, dTolerance = 200)
#plot(intersection_simplified)
# this distance has to be picked otherwise not all occurrence points are inside
simple_intersection_buffer <- st_buffer(intersection_simplified, dist = 900)
#plot(simple_intersection_buffer)


# part of the buffer is outside of the Islands (in the ocean)
# solution: include the DEM 
filtered_stack <- rast("env_variables/stacks/stack_filtered5.tif")
DEM <- filtered_stack$DEM
# Filter the DEM raster for values between: (500 -1500)
dem_filtered <- DEM >= 500 & DEM <= 1500
# Convert the filtered raster into polygons (this will create a vector layer)
dem_polygons <- as.polygons(dem_filtered)
# Convert the polygons to an `sf` object
dem_sf <- st_as_sf(dem_polygons)
# only keep the area which is 1
dem_sf_filtered <- dem_sf[dem_sf$DEM == 1, ]
# create a buffer around the filtered DEM
#dem_buffer <- st_buffer(dem_sf_filtered, dist = 200)
# Perform intersection between the buffer and DEM polygons
intersection_with_dem <- st_intersection(simple_intersection_buffer, dem_sf_filtered)
#plot(intersection_with_dem)

# one occurrence point is not included at El Hierro
# solution buffer the intersection with the dem with a distance of 100m
range_plusareas <- st_buffer(intersection_with_dem, dist= 100)


# the range has to be adjusted to the occurrence points there are a few "islands" of range which do not have an occurrence point in them, 
# they have to be removed
range_single_polygons <- st_cast(range_plusareas, "POLYGON")
# transform to sf object
range_single_polygons_sf <- st_sf(geometry = range_single_polygons)
# Calculate the area of each polygon
range_single_polygons_sf$area <- st_area(range_single_polygons_sf)
# Sort the sf object by area in ascending order
range_single_polygons_sf_sorted <- range_single_polygons_sf[order(range_single_polygons_sf$area), ]
#plot(range_single_polygons_sf_sorted)
# Remove the 6 smallest polygons
range <- range_single_polygons_sf_sorted[-(1:3), ]
range <- st_union(range)
#plot(range)


# now we additionally select an area within the range that would be prioritized for natural protection
# we prioritize the hugest area:
selected_range <- range[-(1:6), ]
selected_range <- st_union(selected_range)

# Save as range as shapefile
st_write(range, "C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/iv_range/range.shp", append = FALSE)
st_write(range_selected, "C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/iv_range/selected_range.shp", append = FALSE)




# # load range again:
# range <- st_read("C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/iv_range/range.shp")
# 
# # separate the multipolygon into single polygons
# range_areas <- st_cast(range, "POLYGON")
#
# # calculate the area:
# range_areas$Area_m2 <- st_area(range_areas)
# range_areas$Area_km2 <- range_areas$Area_m2 / 1e6  
# # [1]  50.70137  32.72046 139.31562 106.13386 116.67603  49.95542  16.17021
# 
# # calculate percentages:
# total_area <- sum(range_areas$Area_km2)
# range_areas$Percentage <- (range_areas$Area_km2 / total_area) * 100
# # 9.908941  6.394800 27.227473 20.742518 22.802851  9.763154  3.160264
# # La Gomera, Teno and Lagunetas area is more than 10% and can be protected
