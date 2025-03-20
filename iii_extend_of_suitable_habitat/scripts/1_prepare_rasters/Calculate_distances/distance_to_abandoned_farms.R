library(sf)
library(dplyr)
library(terra)
source("Scripts/1prepare_rasters/functions/shp2raster.R")
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# paths
Hierro_path <- "env_variables/originals/Farms/gobcan_mapa-cultivos_eh_shp/EH_MCultivos_2022.shp"
Gomera_path <- "env_variables/originals/Farms/gobcan_mapa-cultivos_lg_shp/LG_MCultivos_2023.shp"
Tenerife_path <- "env_variables/originals/Farms/gobcan_mapa-cultivos_tf_shp/TF_MCultivos_2021.shp"

cultivos_output_path <- "env_variables/processed/cultivos/cultivos.gpkg"
abandoned_farms_path <- "env_variables/processed/cultivos/abandoned_farms.tif"
active_farms_path <- "env_variables/processed/cultivos/active_farms.tif"
dir.create("env_variables/processed/cultivos", recursive = TRUE, showWarnings = FALSE)


# Load data
Hierro_shapefile <- st_read(Hierro_path)
Gomera_shapefile <- st_read(Gomera_path)
Tenerife_shapefile <- st_read(Tenerife_path)

# unite them
cultivos_shapefile <- bind_rows(Hierro_shapefile, Gomera_shapefile, Tenerife_shapefile)
# content: 
# ISLA_NA = name of the island
# ISLA_CO = weared ID for each island
# CATEGORIA = category like bananas, fruits, wine...
# AGRUPACION = another form of category more details
# CULTIVO_NA = exact plant name
# CULTIVO_CO = ID for plant name
# BORDE_NA = % of vine, or other category
# BORDE_CO = an ID, not going to check the _CO anymore
# DISEMI_NA = "No aplica"     "Templados"     "Subtropicales" "Almendros"     "Cítricos"      "Higueras"      "Olivos"        "Tagasaste"     "Castaños"
# REGADIO_NA= Yes, No - no idea why
# TECNICA_NA = if it is bio or they have animals
# unique(cultivos_shapefile$ABANDON_NA) # abandoned or not

# save
#st_write(cultivos_shapefile, cultivos_output_path)



# extract abandoned farmland
abandoned_farmland <- cultivos_shapefile %>% filter(ABANDON_NA  %in% c( "Sí, cultivo abandonado", "Sí, prolongado", "Sí, reciente"))
# create raster
abandoned_farmland <- shp2raster(abandoned_farmland)
# measure Euclidean distance 
distance_abandoned_farmland <- distance_from_0(abandoned_farmland)
# plot(distance_abandoned_farmland)
# Save the raster
writeRaster(distance_abandoned_farmland, abandoned_farms_path, overwrite = TRUE)


# extract active farmland
active_farmland <- cultivos_shapefile %>% filter(ABANDON_NA  ==  "No")
# create the raster
active_farmland <-  shp2raster(active_farmland)
# measure Euclidean distance 
distance_active_farmland <- distance_from_0(active_farmland)
# plot(distance_active_farmland)
# Save the raster
writeRaster(distance_active_farmland, active_farms_path, overwrite = TRUE)

