# combine stacks
library(terra)


google_engine_plus_rest_stack <- rast("env_variables/stacks/google_engine_plus_rest_stack.tif")
source("Scripts/2combine_rasters/distances_stack.R")

# project all distance rasters to the same coordinate system and extend like google_engine_plus_rest_stack
d_abandoned_farms_reproj <- project(distance_stack$d_abandoned_farms, google_engine_plus_rest_stack) 
d_active_farms_reproj <- project(distance_stack$d_active_farms, google_engine_plus_rest_stack) 
d_fayal_brezal_reproj <- project(distance_stack$d_fayal_brezal, google_engine_plus_rest_stack) 
d_broadleaf_forest_reproj <- project(distance_stack$d_broadleaf_forest, google_engine_plus_rest_stack)
d_coniferous_forest_reproj <- project(distance_stack$d_coniferous_forest, google_engine_plus_rest_stack)
d_grassland_reproj <- project(distance_stack$d_grassland, google_engine_plus_rest_stack)
d_periodically_herb_reproj <- project(distance_stack$d_periodically_herb, google_engine_plus_rest_stack)
d_permanent_herb_reproj <- project(distance_stack$d_permanent_herb, google_engine_plus_rest_stack)
d_imperviousness_reproj <- project(distance_stack$d_imperviousness, google_engine_plus_rest_stack)
d_low_growing_woody_plants_reproj <- project(distance_stack$d_low_growing_woody_plants, google_engine_plus_rest_stack)
d_forest_Copernicus_reproj <- project(distance_stack$d_forest_Copernicus, google_engine_plus_rest_stack)
d_forest_Cabildo_reproj <- project(distance_stack$d_forest_Cabildo, google_engine_plus_rest_stack)
d_forestedge_Cabildo_reproj <- project(distance_stack$d_forestedge_Cabildo, google_engine_plus_rest_stack)
d_forestedge_Copernicus_reproj <- project(distance_stack$d_forestedge_Copernicus, google_engine_plus_rest_stack)
d_herbazales_reproj <- project(distance_stack$d_herbazales, google_engine_plus_rest_stack)
d_matorrales_reproj <- project(distance_stack$d_matorrales, google_engine_plus_rest_stack)
d_pinar_cipreses_reproj <- project(distance_stack$d_pinar_cipreses, google_engine_plus_rest_stack)
d_treeedge_Cabildo_reproj <- project(distance_stack$d_treeedge_Cabildo, google_engine_plus_rest_stack)
d_treeedge_Copernicus_reproj <- project(distance_stack$d_treeedge_Copernicus, google_engine_plus_rest_stack)
d_trees_Cabildo_reproj <- project(distance_stack$d_trees_Cabildo, google_engine_plus_rest_stack)
d_trees_Copernicus_reproj <- project(distance_stack$d_trees_Copernicus, google_engine_plus_rest_stack)
d_water_wetness_reproj <- project(distance_stack$d_water_wetness, google_engine_plus_rest_stack)

#stack them all together
google_rest_distance_stack <- c(google_engine_plus_rest_stack, 
                                d_abandoned_farms_reproj, 
                                d_active_farms_reproj, 
                                d_fayal_brezal_reproj, 
                                d_broadleaf_forest_reproj, 
                                d_coniferous_forest_reproj, 
                                d_grassland_reproj,
                                d_periodically_herb_reproj, 
                                d_permanent_herb_reproj, 
                                d_imperviousness_reproj, 
                                d_low_growing_woody_plants_reproj, 
                                d_forest_Copernicus_reproj, 
                                d_forest_Cabildo_reproj, 
                                d_forestedge_Cabildo_reproj, 
                                d_forestedge_Copernicus_reproj, 
                                d_herbazales_reproj, 
                                d_matorrales_reproj, 
                                d_pinar_cipreses_reproj, 
                                d_treeedge_Cabildo_reproj, 
                                d_treeedge_Copernicus_reproj, 
                                d_trees_Cabildo_reproj, 
                                d_trees_Copernicus_reproj, 
                                d_water_wetness_reproj)


# save the stack 
writeRaster(google_rest_distance_stack, "env_variables/stacks/google_rest_distance_stack.tif", overwrite = TRUE)
