# number_of_localities

library(sf)
library(dplyr)
library(geosphere)
library(igraph)

occ_data <-  read.csv("C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/iii_extend_of_suitable_habitat/Habitatmodellierung/occurences/Ariagona_margaritae_Alles.csv", sep = ",")
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

# add place_name
occ.std$place_name <- c("Majada_Teno",              # 1
                        "San_Jose_de_los_Llanos",   # 2
                        "Fronton_wAnaga",           # 6
                        "Aguamansa",                # 7
                        "Derrabado",                # 26
                        "Cementerio_eAnaga",        # 30
                        "Teno",                     # 32
                        "Guillen_Lagunetas",        # 44
                        "Icod",                     # 51
                        "Las_Lagunetas",            # 149
                        "Ermita_LG1",               # 180
                        "Ermita_LG2",               # 181
                        "Cementerio_eAnaga2",       # 191
                        "Cementerio_eAnaga3",       # 193
                        "close_to_Rio_wAnaga",      # 194
                        "Cementerio_eAnaga5",       # 208
                        "Cementerio_eAnaga6",       # 209
                        "Cementerio_eAnaga7",       # 212
                        "Huerto_Bicho_Lagunetas",   # 215
                        "Chipudde_center_LG",       # 216
                        "Roque_Agando_LG",          # 220
                        "Charcos_Lagunetas",        # 241
                        "Rio_wAnaga",               # 249
                        "Torre_Teno",               # 257
                        "las_Lagunetas2",           # 272
                        "Palmar_Teno",              # 280
                        "Palmito_Teno",             # 291
                        "Cuevas_wAnaga",            # 293
                        "Bimberas_wAnaga",          # 294
                        "Mequena",                  # 311
                        "Salvador_EH_center",       # 315
                        "Jamones",                  # 322
                        "Bascos_west",              # 323
                        "Taguluche_LG",             # 337
                        "Soldado_EH_east",          # 342
                        "Noruegos_LG",              # 359
                        "Helachon_LG",              # 442
                        "Quebradon_LG",             # 447
                        "Chijerie_LG",              # 451
                        "Campana_LG",               # 456
                        "Paredes_LG",               # 459
                        "Juel_LG",                  # 461
                        "Santa_Clara_LG",           # 470
                        "Bailandero_LG"             # 474
                        )


# occurences with less than 1km distance to each other should be dealed as one occurrence, if the areas are not separated from each other
# empty list for close occurrrence points
close_points <- data.frame(place_name1 = integer(), place_name2 = integer(), Distance_m = numeric())
# calculate pairwise distances
for (i in 1:(nrow(occ.std)-1)) {
  for (j in (i+1):nrow(occ.std)) {
    dist <- distVincentyEllipsoid(
      c(occ.std$WGS84_X[i], occ.std$WGS84_Y[i]),
      c(occ.std$WGS84_X[j], occ.std$WGS84_Y[j])
    )  # distance in m
    # save if the distance fits the threshold
    if (dist < 1000) {
      close_points <- rbind(close_points, data.frame(
        place_name1 = occ.std$place_name[i],
        place_name2 = occ.std$place_name[j],
        Distance_m = dist
      ))
    }
  }
}
#print(close_points)

# one place:
# Teno: Majada_Teno, Teno, Palmito_Teno, Torre_Teno
# Cementerio_eAnaga: Cementerio_eAnaga, Cementerio_eAnaga2, Cementerio_eAnaga3, Cementerio_eAnaga5, Cementerio_eAnaga6, Cementerio_eAnaga7
# Las_Lagunetas: Las_Lagunetas, las_Lagunetas2
# Ermita: Ermita_LG1,  Ermita_LG2, Santa_Clara_LG
# Rio_wAnaga: close_to_Rio_wAnaga,  Rio_wAnaga
# wAnaga: Cuevas_wAnaga, Bimberas_wAnaga
# Majona: Helachon_LG,  Juel_LG, Campana_LG

# add a new column for all coordinates that belong to one place
occ.std$one_place <- occ.std$place_name  # empty column created

# sort coordinates to the new one_place names
occ.std$one_place[occ.std$place_name == c("Majada_Teno", "Teno", "Palmito_Teno", "Torre_Teno")] <- "Teno"
occ.std$one_place[grep("Cementerio_eAnaga", occ.std$place_name)] <- "Cementerio_eAnaga"
occ.std$one_place[grep("as_Lagunetas", occ.std$place_name)] <- "Las_Lagunetas"
occ.std$one_place[occ.std$place_name %in% c("Ermita_LG1", "Ermita_LG2", "Santa_Clara_LG")] <- "Ermita"
occ.std$one_place[occ.std$place_name %in% c("close_to_Rio_wAnaga", "Rio_wAnaga")] <- "Rio_wAnaga"
occ.std$one_place[occ.std$place_name %in% c("Cuevas_wAnaga", "Bimberas_wAnaga")] <- "wAnaga"
occ.std$one_place[occ.std$place_name %in% c("Helachon_LG", "Juel_LG", "Campana_LG")] <- "Majona"

#calculate the mean for all coordinates that are actually from one place
mean_coords <- occ.std %>%
  group_by(one_place) %>%
  summarise(
    mean_WGS84_X = mean(WGS84_X, na.rm = TRUE),  # Mittelwert der X-Koordinate
    mean_WGS84_Y = mean(WGS84_Y, na.rm = TRUE)   # Mittelwert der Y-Koordinate
  )

# load them sf object
occurrences_sf <- st_as_sf(mean_coords, coords = c("mean_WGS84_X", "mean_WGS84_Y"), crs = 4326)
#transform coordinate system
occurrences_sf <- st_transform(occurrences_sf, crs = 32628)
#plot(occurrences_sf)
# 29 localities, 3 localities should be protected at least. Let's see how many localities would be protected by each area


# locality boundaries defined by range
# load range
range <- st_read("C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/iv_range/range.shp")

# seperate the multipolygon into single polygons
range_areas <- st_cast(range, "POLYGON")
# give the polygons different "names"
range_areas$FID <- 1:nrow(range_areas)

# Count how many occurrence points are within each polygon
occurrences_within <- st_join(occurrences_sf, range_areas)
#table(occurrences_within$FID)
# 1, 3, 4, 5, 6 are the areas that would protecting more than 10%
#plot(range_areas)

#find the polygon with the most points
count_points_per_polygon <- occurrences_within %>%
  group_by(FID) %>%
  summarise(count = n())
polygon_with_most_points_id <- count_points_per_polygon %>%
  arrange(desc(count)) %>%
  slice(1) %>%
  pull(FID)
#polygon_with_most_points_id

# Extract the sf object of the polygon with the most points
polygon_with_most_points <- range_areas[range_areas$FID == polygon_with_most_points_id, ]
# plot(st_geometry(polygon_with_most_points), col = "red", main = "Polygon with the Most Occurrence Points")
# plot(st_geometry(occurrences_sf), col = "blue", pch = 20, add = TRUE)

# 
# # calculate not only the area that has the most points but also the area with the highest density of points
# range_areas$Area_m2 <- st_area(range_areas)
# range_areas$Area_km2 <- range_areas$Area_m2 / 1e6  
# range_areas$Area_km2_div_by_localities <- range_areas$Area_km2 / as.numeric(table(occurrences_within$FID))
# # smallest area has the highest density of points!
# # now the selected area would be different
# # west-central-Hierro is most efficient, less area for more points, but non the less protects more than 10% of its localities
# # Sort the sf object by area in ascending order
# range_areas_sorted_for_Area_km2_div_by_localities <- range_areas[order(range_areas$Area_km2_div_by_localities), ]
# range_areas_sorted_for_Area_km2_div_by_localities <- range_areas_sorted_for_Area_km2_div_by_localities[-(1:6), ]
# #plot(st_geometry(area_highest_density_of_localities), col = "red", main = "Area with Highest Density of Localities")
# range_areas_sorted_for_Area_km2_div_by_localities <- range_areas_sorted_for_Area_km2_div_by_localities[, c("geometry")]


st_write(polygon_with_most_points, "C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/v_number_of_localities/area_with_most_localities.shp", append = FALSE)
# st_write(range_areas_sorted_for_Area_km2_div_by_localities, "C:/Users/Gronefeld/Desktop/Compare_species-based_criteria/Calculations/v_number_of_localities/area_highest_density_of_localities.shp", append = FALSE)


# # find localities, in 5km distance?
# # empty list for close occurrrence points
# localities <- data.frame(one_place1 = integer(), one_place2 = integer(), Distance_m = numeric())
# # calculate pairwise distances
# for (i in 1:(nrow(occ.std)-1)) {
#   for (j in (i+1):nrow(occ.std)) {
#     dist <- distVincentyEllipsoid(
#       c(occ.std$WGS84_X[i], occ.std$WGS84_Y[i]),
#       c(occ.std$WGS84_X[j], occ.std$WGS84_Y[j])
#     )  # distance in m
#     # save if the distance fits the threshold
#     if (dist < 5000) {
#       localities <- rbind(localities, data.frame(
#         one_place1 = occ.std$one_place[i],
#         one_place2 = occ.std$one_place[j],
#         Distance_m = dist
#       ))
#     }
#   }
# }
# 
# # create a list with grouped localities
# g <- graph_from_data_frame(localities, directed = FALSE) # igraph
# components <- components(g)
# grouped_localities <- split(names(components$membership), components$membership)
# grouped_localities
# 
# # Tenerife: 
# # Teno:          2
# # San Jose:      1
# # Icod:          1
# # Aguamansa:     1
# # las Lagunetas: 4
# # west Anaga:    3
# # east Anaga:    1
# 
# # La Gomera:
# # south+east:    6
# # Quebradon:     1
# # Chipudde.      1
# # north:         2
# 
# # El Hierro: 
# # west:          2
# # center:        2
# # east:          2
# 
# 
# # sum of localities: 29
# # means we should protect 3 localities!
# # the ones which should be selected: 
# # La Gomera:
# # south+east:    6
# 
# 
# 
# # sort places to groups
# locality_map <- stack(grouped_localities) %>%
#   rename(one_place = values, locality = ind)
# 
# # add it to the data frame
# occ.std <- left_join(occ.std, locality_map, by = "one_place")
# 
# # replace with names
# # occ.std <- occ.std %>%                           # sort
# #   mutate(locality = as.numeric(locality)) %>%
# #   arrange(locality)
# group_names <- c(
#   "1" = "Teno",
#   "2" = "west_Anaga",
#   "3" = "west_Hierro",
#   "4" = "east_Anaga",
#   "5" = "Lagunetas",
#   "6" = "Ermita",
#   "7" = "Roque_Agando",
#   "8" = "center_Hierro",
#   "9" = "east_Hierro"
# )
# occ.std <- occ.std %>%
#   mutate(locality = group_names[as.character(locality)])
# 
# # replace NA
# occ.std$locality[is.na(occ.std$locality)] <- occ.std$one_place[is.na(occ.std$locality)]
# 
# 



