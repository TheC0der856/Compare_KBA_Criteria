library(sf)

# only range which is inside suitable habitat to avoid commission errors
range <- st_read("iv_range/range.shp")
ESH   <- st_read("iii_extend_of_suitable_habitat/suitable_habitat.shp")
#plot(range)
#plot(ESH)
range_ESH           <- st_intersection(st_geometry(range), st_geometry(ESH))

# buffer the area for all occurence point being in the area
ranges_ESH_buffer   <- st_buffer(range_ESH, dist = 350) 
# 350m is necessary to include Icod, but this will induce more imprecision especially close to the coast.
# more than 500m buffer would be necessary to include all occurrence points
# one point is very far from all suitable habitat, so it was not included in the range
# 200m buffer excludes 7% of occurrence points (> 90% probably fine), but Icod is lost!
# 100m/75m/50m buffer excludes 9% of occurrence points (> 90% probably fine)
# should not be smaller than 50m otherwise we have a lot of small range islands with a single occurrence point inside

# melt buffer and create single polygons
ranges_ESH <- st_cast(st_union(ranges_ESH_buffer), "POLYGON")


# load occurence points
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

# only keep areas with occurrence points
contains_point <- sapply(ranges_ESH, function(p) {
  any(st_contains(p, occurrences_sf, sparse = FALSE))
})
ranges_ESH_with_occurences <- ranges_ESH[contains_point]
 # tm_shape(range_with_points_sf) +
 #   tm_polygons(col = "lightblue", border.col = "darkblue", fill_alpha = 0.5, 
 #               fill.legend = tm_legend(title = "Range")) +
 #   tm_shape(occurrences_sf) +
 #   tm_dots(col = "red", size = 2, legend.show = TRUE, 
 #           fill.legend = tm_legend(title = "Occurrences"))

# fill holes
range_expanded <- st_buffer(ranges_ESH_with_occurences, dist = 50) 
range_filled <- st_union(range_expanded)
range_filled <- st_buffer(range_filled, dist = -50)
# tmap_mode("view")
# tm_shape(range_filled) +
#   tm_polygons(col = "lightblue", border.col = "darkblue", fill_alpha = 0.5,
#               fill.legend = tm_legend(title = "Range")) +
#   tm_shape(occurrences_sf) +
#   tm_dots(col = "red", size = 2, fill.legend = tm_legend(title = "Occurrences"))

write_sf(range_filled, "iv_range/range_no_commission.shp")
