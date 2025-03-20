#################### What was done? ###############################
# 1. run the google engine script and save the raster files
# there are two google engine scripts: one script was used for the correlations between all variables
# in this script the ocean was cut out, so the island area only was used for correlations (Google_Engine_Download)
# for the model calculation we had to use another script where the ocean is not cut, because the country border is not very exact and it would cut some occurrence points away (Google_Engine_Download2)

# 2. install packages
source("Scripts/package_installer.R")

# 3. prepare rasters for the model: 
# combine both canopy height tif files into one
source("Scripts/1prepare_rasters/merge_Canopy_height.R") 
# create two columns for inaccurate and accurate vegetation classification by the Spanish government
source("Scripts/1prepare_rasters/edit_formaciones_forestales.R") 
# Copernicus values are changed into 0 if outside the area
source("Scripts/1prepare_rasters/edit_values_Copernicus_data_sets.R") # information_on_Copernicus_data_sets.R describes the original values and changes in ()
# Calculate distances
  # distance to forestedge
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_treeedge_cabildo.R") # forest data from the Spanish government: formaciones forestales, in inaccurate vegetation classification
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_treeedge_Copernicus.R") # forest data from Copernicus: Dominant Forest Type
  # distance to fayal-brezal 
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_fayal_brezal.R")
  # distance to imperviousness
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_Imperviousness.R")
  # distance to grassland
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_grassland.R")
  # distance to low-growing woody plants
  source("Scripts/prepare_rasters/Calculate_distances/distance_to_low_growing_woody_plants.R")
  # distance to forest
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_forest.R")
  # distance to trees
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_trees.R")
  # distance to forest type
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_foresttype.R")
  # distance to water/wetness
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_water_wetness.R")
  # distance to permanent or periodically herbaceous
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_herb_type.R")
  # distance to herbs, bushes, pines and cypresses
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_herbazales_matorrales_pinar_y_cipreses.R")
  # distance to farmland (active and abandoned)
  source("Scripts/1prepare_rasters/Calculate_distances/distance_to_abandoned_farms.R")
# calculate variables related to elevation, and combine elevation
source("Scripts/1prepare_rasters/process_DEM.R")

# 4. combine rasters
source("Scripts/2combine_rasters/rest_stack.R")
source("Scripts/2combine_rasters/combine_rest_googleengine_distance.R")
source("Scripts/2combine_rasters/combine_all.R")

# 5. prepare stack
source("Scripts/3prepare_stack/remove_correlating_and_nonsense.R")
# correlating:
# prefer NDVI, more common, could think about taking TC_Veg instead because it is more sensitive towards the helth of the plants, SAVI does not make sense because no bare ground
# prefer NDMI, more common, also better because water in plants is considered as well over farmland
# prefer tree edge than trees, (forest, forestedge) because RedList description of edge and I saw in ArcGIS the combination with Small Woody Features makes a difference
# removed all forest type distinctions, because they are correlating with edge
# removed, because non sense:
# water, because the cricket is not depending on water bodies (to less water bodies, not close to their habitat)
# distance to imperviousness (I think, I don't have to explain this, but a explanation found in the script)
source("Scripts/3prepare_stack/remove_double.R")
# data I had twice
# tree edge Copernicus, tree edge Cabildo
# grassland (Copernicus), herbazales (meadow, Cabildo)
# low growing woody features (shrubs, Copernicus), matorrales (shrubs, Cabildo)
# I decided to use the data of Copernicus, because all data of the Cabildo are from 2012, 
# while grassland and tree edge data are from 2018 and low growing woody features from 2021 (much closer to most of the observations)
# moreover in compare_double.R it can be seen, that Copernicus data are more differentiated, and smaller amounts of coordinates are sorted to the category, which will make the model more exact
source("Scripts/3prepare_stack/remove_cropgrassland.R")
# combined data has environmental variables at the occurrence points of Ariagona
# > mean(combined_data$d_grassland)           --> grassland consists of periodically and permanent herbaceous
# [1] 114.5152
# > mean(combined_data$d_periodically_herb)   --> mainly crops, should not use it, no crickets in intensively used farmland
# [1] 452.5005
# > mean(combined_data$d_permanent_herb)      --> wild meadows (should be the only one included!)
# [1] 45.81638
# apart from that was cropland and shrubs correlating
# do not replace NA values in curvature with 0
source("Scripts/3prepare_stack/hillshade.R")
# hillshade was removed from the model, because the data is without a pattern
source("Scripts/3prepare_stack/replace_NDVI_n_NDMI.R")
# NDVI and NDMI have to be replaced, because the NA values cause problems when creating the occurrences table (see step 1. there are two scripts)

# 6. create table containing presence coordinates and environmental information
source("Scripts/4create_occ_table/create_occ_table.R")

# 7. run the model
source("Scripts/5run_model/1preparations.R")
source("Scripts/5run_model/3run_model.R")
source("Scripts/5run_model/4projection.R")
