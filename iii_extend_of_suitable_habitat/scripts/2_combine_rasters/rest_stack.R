# create more stacks:
#load library
library(terra)

# # temperature and radiation fit together
# temperature <- rast("env_variables/originals/Temperature/tti_x10/tti_x10.tif")
# all_month_temperature <- subset(temperature, "tti_yy_x10")
# radiation <- rast("env_variables/originals/Radiation/ghi_x10/ghi_x10.tif")
# all_month_radiation <- subset(radiation, "ghi_yy_x10")
# # Stack rasters
# radiation_temperature_stack <- c(all_month_radiation, all_month_temperature)
# # rename the rasters
# names(radiation_temperature_stack) <- c("radiation_x10", "temperature_x10")
# # resolution  : 250, 250  (x, y), coord. ref. : WGS 84 / Pseudo-Mercator (EPSG:3857) is not detailed enough


# fog, canopy height and wind speed have the same coordinate system and can be easily combined
fog <- rast("env_variables/originals/Fog/Fn-CA-2000-2014/Modis-NUB-14-12-28.tif")
wind_speed <- rast("env_variables/originals/Speed_Wind/Vien-CA-2001-2020/VIEN_2018-12-28.tif")
Canopy_Height <- rast("env_variables/processed/Canopy_Height/Canopy_Height.tif")
# align the resolution of the rasters to Canopy Height
fog_resampled <- resample(fog, Canopy_Height)
wind_speed_resampled <- resample(wind_speed, Canopy_Height)
# find the common extent 
# extract the extend of the rasters
ext_fog <- ext(fog)
ext_wind_speed <- ext(wind_speed)
ext_canopy_height <- ext(Canopy_Height)
# calculate the common extend
xmin_common <- max(ext_fog[1], ext_wind_speed[1], ext_canopy_height[1])
xmax_common <- min(ext_fog[2], ext_wind_speed[2], ext_canopy_height[2])
ymin_common <- max(ext_fog[3], ext_wind_speed[3], ext_canopy_height[3])
ymax_common <- min(ext_fog[4], ext_wind_speed[4], ext_canopy_height[4])
# create the common extend
common_extent <- ext(xmin_common, xmax_common, ymin_common, ymax_common)
# Crop both rasters to the common extent
fog_cropped <- crop(fog_resampled, common_extent)
wind_cropped <- crop(wind_speed_resampled, common_extent)
canopy_cropped <- crop(Canopy_Height, common_extent)
# Stack the cropped rasters
fog_wind_canopy_stack <- c(fog_cropped, wind_cropped, canopy_cropped)
names(fog_wind_canopy_stack) <- c("fog", "wind_speed", "canopy_height")


# add fog_wind_canopy_stack to google engine rasters
# load google engine rasters
source("Scripts/2combine_rasters/google_engine_stack.R")
# Reprojektion und Resampling of fog, wind, canopy height to WGS 84 / UTM zone 28N (EPSG:32628)  (in m, better for local applications)
fog_EPSG32628 <- project(fog_wind_canopy_stack$fog, google_engine_stack)
wind_EPSG32628 <- project(fog_wind_canopy_stack$wind_speed, google_engine_stack)
canopy_EPSG32628 <- project(fog_wind_canopy_stack$canopy_height, google_engine_stack)
# combine stacks 
google_fogwindcanopy_stack <- c(google_engine_stack, fog_EPSG32628, wind_EPSG32628, canopy_EPSG32628)


# add tree cover density
# load Tree Cover Density 
Tree_Cover_Density <- rast("env_variables/processed/Tree_Cover_Density/Tree_Cover_Density.tif")
# adjust projection of coordinate system 
tree_cover_reprojected <- project(Tree_Cover_Density, google_engine_stack)
# combine tree cover density and the combined stacks
google_engine_plus_rest_stack <- c(google_fogwindcanopy_stack, tree_cover_reprojected)

  
# save the stack
# define path
output_dir <- "env_variables/stacks"
output_file <- file.path(output_dir, "google_engine_plus_rest_stack.tif")
# create folder if it does not exist yet
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}
# save raster
writeRaster(google_engine_plus_rest_stack, output_file, overwrite = TRUE)
