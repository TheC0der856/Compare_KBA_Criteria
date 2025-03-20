# Load the terra package
library(terra)
library(sf)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# create raster: distance_to_treeedge
#     1. create Forest 
#     2. combine Forest and Small Woody Features
#     3. create Treeedge
#     4. calculate distance
#     5. save results



# Paths
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Small_Woody_Features_path = "env_variables/processed/Small_Woody_Features/Small_Woody_Features.tif"
Distance_to_Treeedge_path = "env_variables/processed/Distance_to_Treeedge/Distance_to_Treeedge_Copernicus.tif"
if (!dir.exists(dirname(Distance_to_Treeedge_path))) {
  dir.create(dirname(Distance_to_Treeedge_path), recursive = TRUE)
}

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
# create multiple lines around the polygons
Treeedge_sf <- st_cast(Trees_polygons_sf, "MULTILINESTRING")
#plot(Treeedge_sf)

# 4. Calculate Euclidean distance to forest edge
# definie a raster, to have the same resolution and extend like the original
template_raster <- rast(Forest_raster)
# Treeedge_sf has to be converted into a raster
Treeedge_raster <- rasterize(vect(Treeedge_sf), template_raster, field = 0, background = 1)
#plot(Treeedge_raster)
# Calculate the Euclidean distance to the lines
Treeedge_distance <- distance_from_0(Treeedge_raster)
#plot(Treeedge_distance)

# 5. Save results
writeRaster(Treeedge_distance, 
            filename = Distance_to_Treeedge_path, 
            overwrite = TRUE)

