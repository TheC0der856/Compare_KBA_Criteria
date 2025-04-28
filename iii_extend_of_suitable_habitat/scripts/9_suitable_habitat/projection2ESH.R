# load library
library("terra")
library("sf")

# load projection
projection <- rast("iii_extend_of_suitable_habitat/Presence/Cluster/proj_20x20/proj_20x20_Presence_ensemble.tif")
EMprojectionROC <- projection$Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo
#EMprojectionTSS <- projection$Presence_EMcaByTSS_mergedData_mergedRun_mergedAlgo
#plot(EMprojectionROC)
#plot(EMprojectionTSS)
# not only the evaluation scores are similar, also the plots
# since there are no differences I will choose ROC, as it was already choosen for displaying response curves
EMprojection <- EMprojectionROC

# values between 0 and 1000
# 0 no way the species occurs here
# 1000 the species definitely occurs here

# if I want to keep sites that have a >80% probability that the species occurs there (suitable habitat)
# the values should be 800-1000
suitable_habitat <- mask(EMprojection, EMprojection >= 800 & EMprojection <= 1000, maskvalues=FALSE)
#plot(suitable_habitat)

# transform into sf-object
suitable_habitat_poly <- as.polygons(suitable_habitat, dissolve=TRUE)
suitable_habitat_sf <- st_as_sf(suitable_habitat_poly)
#plot(suitable_habitat_sf)
#all(st_is_valid(suitable_habitat_sf)) # control if errors happened from the transformation

# find the biggest suitable area
# suitable_habitats_sf <- st_cast(suitable_habitat_sf, "POLYGON")
# selected_suitable_habitat_sf <- suitable_habitats_sf[which.max(st_area(suitable_habitats_sf)), ]

# find the suitable area within the selected range
#selected_range <- st_read("iv_range/selected_range.shp")
# selected_suitable_habitat_sf <- st_intersection(
#   suitable_habitat_sf[, "geometry"],
#   selected_range[, "geometry"]
# )
# something is wrong here...
# I could not find out why it is not working so I made the intersection with jupiter notbook python script.

# save as shapefile
st_write(suitable_habitat_sf, "iii_extend_of_suitable_habitat/suitable_habitat.shp")
#st_write(selected_suitable_habitat_sf, "iii_extend_of_suitable_habitat/selected_suitable_habitat.shp")
