#distance to forestedge (forest from spanish government)
library(sf)
library(dplyr)
library(terra)
source("Scripts/1prepare_rasters/functions/shp2raster.R")
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# create raster: distance_to_treeedge
#     1. create Forest 
#     2. combine Forest and Small Woody Features
#     3. create Treeedge
#     4. calculate distance
#     5. save results


# file paths
formaciones_forestales_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
Small_Woody_Features_path <- "env_variables/processed/Small_Woody_Features/Small_Woody_Features.tif"
Distance_to_Treeedge_path <- "env_variables/processed/Distance_to_Treeedge/Distance_to_Treeedge_Cabildo.tif"
# Create the output folder if it doesn't exist
if (!dir.exists(dirname(Distance_to_Treeedge_path))) {
  dir.create(dirname(Distance_to_Treeedge_path), recursive = TRUE)
}

#load data
Small_Woody_Features_raster <- rast(Small_Woody_Features_path)
formaciones_forestales <- st_read(formaciones_forestales_path)

# 1. find forests
forest_areas <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "BOSQUES Y ARBUSTEDAS")
# create raster
forest_raster <- shp2raster(forest_areas)
#plot(forest_raster)
#adjust Small_Woody_Features_raster to forest areas
Small_Woody_Features_raster_aligned <- resample(Small_Woody_Features_raster, forest_raster , method = "near")

# 2. combine forest and small woody features
# Create rasters (forest formations or small woody features)
Trees_raster <- mosaic(forest_raster, 
                       Small_Woody_Features_raster_aligned, 
                       fun = min)

# 3. Create treeedge
# Exclude 0 values to avoid calculating edges around non-forest areas
Trees_raster_filtered <- mask(Trees_raster, Trees_raster == 0, maskvalues = FALSE)
# Convert filtered raster into polygons
Trees_polygons <- as.polygons(Trees_raster_filtered, dissolve = TRUE)
# Convert terra polygons into an sf object
Trees_polygons_sf <- st_as_sf(Trees_polygons)
# Create multiple lines around the polygons
Treeedge_sf <- st_cast(Trees_polygons_sf, "MULTILINESTRING")
# plot(Treeedge_sf)


# 4. Calculate Euclidean distance to forest edge
# Ensure the distance raster has the same resolution and extent
Treeedge_raster <- rasterize(vect(Treeedge_sf), forest_raster, field = 0, background = 1)
# Calculate the Euclidean distance to the forest edge
Treeedge_distance <- distance_from_0(Treeedge_raster)
# Check results
# plot(Treeedge_distance)

# 5. Save the result
writeRaster(Treeedge_distance, 
            filename = Distance_to_Treeedge_path, 
            overwrite = TRUE)
