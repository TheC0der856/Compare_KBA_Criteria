library(sf)
library(dplyr)
library(geosphere)

# ------------------------------
# 1. Prepare occ_data
# ------------------------------
occ_data <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv", sep = ",")

# Clean coordinates
occ_data$WGS84_X <- as.numeric(sub(",", ".", occ_data$WGS84_X))
occ_data$WGS84_Y <- as.numeric(sub(",", ".", occ_data$WGS84_Y))

# Remove rows with missing coordinates
occ_data <- occ_data[complete.cases(occ_data$WGS84_X, occ_data$WGS84_Y), ]

# ------------------------------
# 2. Create occ.std: unique reference points
# ------------------------------
occ.std <- occ_data[!is.na(occ_data$Specimen_ID) & occ_data$Specimen_ID != "", c("WGS84_X", "WGS84_Y")]
occ.std <- occ.std[!duplicated(occ.std), ]  # Remove duplicates

# Add place names (44 reference points)
occ.std$place_name <- c(
  "Majada_Teno", "San_Jose_de_los_Llanos", "Fronton_wAnaga", "Aguamansa",
  "Derrabado", "Cementerio_eAnaga", "Teno", "Guillen_Lagunetas", "Icod",
  "Las_Lagunetas", "Ermita_LG1", "Ermita_LG2", "Cementerio_eAnaga2",
  "Cementerio_eAnaga3", "close_to_Rio_wAnaga", "Cementerio_eAnaga5",
  "Cementerio_eAnaga6", "Cementerio_eAnaga7", "Huerto_Bicho_Lagunetas",
  "Chipudde_center_LG", "Roque_Agando_LG", "Charcos_Lagunetas", "Rio_wAnaga",
  "Torre_Teno", "las_Lagunetas2", "Palmar_Teno", "Palmito_Teno", "Cuevas_wAnaga",
  "Bimberas_wAnaga", "Mequena", "Salvador_EH_center", "Jamones", "Bascos_west",
  "Taguluche_LG", "Soldado_EH_east", "Noruegos_LG", "Helachon_LG", "Quebradon_LG",
  "Chijerie_LG", "Campana_LG", "Paredes_LG", "Juel_LG", "Santa_Clara_LG", "Bailandero_LG"
)

# ------------------------------
# 3. Assign one_place groups
# ------------------------------
occ.std$one_place <- occ.std$place_name
occ.std$one_place[occ.std$place_name %in% c("Majada_Teno", "Teno", "Palmito_Teno", "Torre_Teno")] <- "Teno"
occ.std$one_place[grep("Cementerio_eAnaga", occ.std$place_name)] <- "Cementerio_eAnaga"
occ.std$one_place[grep("as_Lagunetas", occ.std$place_name)] <- "Las_Lagunetas"
occ.std$one_place[occ.std$place_name %in% c("Ermita_LG1", "Ermita_LG2", "Santa_Clara_LG")] <- "Ermita"
occ.std$one_place[occ.std$place_name %in% c("close_to_Rio_wAnaga", "Rio_wAnaga")] <- "Rio_wAnaga"
occ.std$one_place[occ.std$place_name %in% c("Cuevas_wAnaga", "Bimberas_wAnaga")] <- "wAnaga"
occ.std$one_place[occ.std$place_name %in% c("Helachon_LG", "Juel_LG", "Campana_LG")] <- "Majona"

# ------------------------------
# 4. Compute mean coordinates per one_place
# ------------------------------
mean_coords <- occ.std %>%
  group_by(one_place) %>%
  summarise(
    mean_WGS84_X = mean(WGS84_X),
    mean_WGS84_Y = mean(WGS84_Y)
  )

# ------------------------------
# 5. Convert occ_data and occ.std to sf
# ------------------------------
occ_full_sf <- st_as_sf(occ_data, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
occ_std_sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)

# ------------------------------
# 6. Spatial join: assign each point in occ_data to nearest reference point
# ------------------------------
occ_full_joined <- st_join(
  occ_full_sf,
  occ_std_sf %>% select(place_name),
  join = st_nearest_feature
)

# Re-assign one_place groups after join
occ_full_joined$one_place <- occ_full_joined$place_name
occ_full_joined$one_place[occ_full_joined$place_name %in% c("Majada_Teno", "Teno", "Palmito_Teno", "Torre_Teno")] <- "Teno"
occ_full_joined$one_place[grep("Cementerio_eAnaga", occ_full_joined$place_name)] <- "Cementerio_eAnaga"
occ_full_joined$one_place[grep("as_Lagunetas", occ_full_joined$place_name)] <- "Las_Lagunetas"
occ_full_joined$one_place[occ_full_joined$place_name %in% c("Ermita_LG1", "Ermita_LG2", "Santa_Clara_LG")] <- "Ermita"
occ_full_joined$one_place[occ_full_joined$place_name %in% c("close_to_Rio_wAnaga", "Rio_wAnaga")] <- "Rio_wAnaga"
occ_full_joined$one_place[occ_full_joined$place_name %in% c("Cuevas_wAnaga", "Bimberas_wAnaga")] <- "wAnaga"
occ_full_joined$one_place[occ_full_joined$place_name %in% c("Helachon_LG", "Juel_LG", "Campana_LG")] <- "Majona"

# ------------------------------
# 7. Compute sampling_density: number of occurrences per one_place
# ------------------------------
sampling_density_df <- occ_full_joined %>%
  st_drop_geometry() %>%
  filter(!is.na(Specimen_ID) & Specimen_ID != "") %>%  # only count valid specimens
  group_by(one_place) %>%
  summarise(sampling_density = n())

# ------------------------------
# 8. Merge sampling_density with mean_coords
# ------------------------------
mean_coords <- mean_coords %>%
  left_join(sampling_density_df, by = "one_place")

# ------------------------------
# 9. Convert to sf object with projected CRS
# ------------------------------
occurrences_sf <- st_as_sf(mean_coords, coords = c("mean_WGS84_X", "mean_WGS84_Y"), crs = 4326)
occurrences_sf <- st_transform(occurrences_sf, crs = 32628)

# ------------------------------
# 10. save resulls
# ------------------------------
# quality check:
#print(occurrences_sf, n = 29)

st_write(occurrences_sf, "C:/Users/Gronefeld/Desktop/Compare_KBA_Criteria/combine_criteria/sampling_density/sampling_density.shp", append = FALSE)

