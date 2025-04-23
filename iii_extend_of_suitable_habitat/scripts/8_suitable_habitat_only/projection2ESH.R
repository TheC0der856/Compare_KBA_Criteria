# load library
library("terra")
library("sf")

# load projection
projection <- rast("iii_extend_of_suitable_habitat/Presence/test_projection.tif")
EMprojection <- projection$Presence_PA1_RUN1_MAXNET
#plot(EMprojection)

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
#all(st_is_valid(suitable_habitat_sf)) # controll if errors happend from the transformation

# find the biggest suitable area
suitable_habitats_sf <- st_cast(suitable_habitat_sf, "POLYGON")
selected_suitable_habitat_sf <- suitable_habitats_sf[which.max(st_area(suitable_habitats_sf)), ]


# save as shapefile
st_write(suitable_habitat_sf, "iii_extend_of_suitable_habitat/suitable_habitat.shp")
st_write(selected_suitable_habitat_sf, "iii_extend_of_suitable_habitat/selected_suitable_habitat.shp")
