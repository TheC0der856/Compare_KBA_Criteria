#AOO
library(sf)

# fishnet:
# define a box fitting my occurence coordinates
bbox <- st_bbox(c(xmin = -19 , ymin = 27, xmax = -16, ymax = 28.5), crs = 4326)
# change the box to UTM CRS (zone 28N)
utm_crs <- st_transform(st_as_sfc(bbox), crs = 32628)  
# create a fishnet with the gridsize of 2000 m x 2000 m
fishnet <- st_make_grid(utm_crs, cellsize = c(2000, 2000), what = "polygons")
# create sf object
fishnet_sf <- st_sf(geometry = fishnet)
#plot(fishnet_sf)

# occurrence points:
# load occurrence data
occ_data <-  read.csv("C:/Users/Gronefeld/Desktop/Habitatmodellierung/occurences/Ariagona_margaritae_Alles.csv", sep = ",")
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

# combine:
# transform occurrences to fishnet coordinates
occurrences_sf <- st_transform(occurrences_sf, st_crs(fishnet_sf))
# identify overlap between fishnet and occurences
overlapping_indices <- st_intersects(fishnet_sf, occurrences_sf, sparse = FALSE)
# extract fishnet-polygons with overlap
overlapping_fishnet <- fishnet_sf[apply(overlapping_indices, 1, any), ]
plot(overlapping_fishnet)

#10% of 30 are 3 
# if you want to cover the largest possible area you would probably choose La Gomera 
# (5 boxes ~ 16.67%)

# select the area which is most important
occurences2 <- occ_data[!is.na(occ_data$Specimen_ID) & 
                      occ_data$Specimen_ID != "" & 
                      occ_data$Island == "La_Gomera", c("WGS84_X", "WGS84_Y")]
# Remove duplicate coordinate pairs
occurences2.std <- occurences2[!duplicated(occurences2),]  
# just keep most southern points 
occurences2.std_sorted <- occurences2.std[order(occurences2.std$WGS84_Y), ]
southernmost_points <- occurences2.std_sorted[1:5, ]
#southernmost_points
# Replace commas with dots and convert to numeric values
southernmost_points$WGS84_X <- as.numeric(sub(",", ".", southernmost_points$WGS84_X))
southernmost_points$WGS84_Y <- as.numeric(sub(",", ".", southernmost_points$WGS84_Y))
# load them sf object
occurrences2_sf <- st_as_sf(southernmost_points, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)

# combine:
# transform occurrences to fishnet coordinates
occurrences2_sf <- st_transform(occurrences2_sf, st_crs(fishnet_sf))
# identify overlap between fishnet and occurrences
overlapping2_indices <- st_intersects(fishnet_sf, occurrences2_sf, sparse = FALSE)
# extract fishnet-polygons with overlap
overlapping2_fishnet <- fishnet_sf[apply(overlapping2_indices, 1, any), ]
plot(overlapping2_fishnet)


# save as shape file
st_write(overlapping_fishnet, "C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/ii_area_of_occupancy/AOO_all.shp")
st_write(overlapping2_fishnet, "C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/ii_area_of_occupancy/AOO_selected_area.shp")




# check
# AOO_all <- st_read("C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/ii_area_of_occupancy/AOO_all.shp")
# AOO_selected_area <- st_read("C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/ii_area_of_occupancy/AOO_selected_area.shp")
# plot(st_geometry(AOO_all), col = "lightblue", main = "Area of Occupancy (AOO)", reset = FALSE)
# plot(st_geometry(AOO_selected_area), col = "red", add = TRUE)
# legend("topright", legend = c("AOO_all", "AOO_selected_area"), fill = c("lightblue", "red"))
