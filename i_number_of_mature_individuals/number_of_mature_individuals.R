# load packages
library("tidyr")
library("sf")

# load data
coordinates <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
specimenID <- coordinates$Specimen_ID
specimenID <- specimenID[specimenID != ""]
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")


# combine potential areaID with specimenID
coordinates$WGS84_X <- as.numeric(gsub(",", ".", coordinates$WGS84_X))
coordinates$WGS84_Y <- as.numeric(gsub(",", ".", coordinates$WGS84_Y))
coordinates_clean <- coordinates[!is.na(coordinates$WGS84_X) & !is.na(coordinates$WGS84_Y), ] 
coordinates_sf <- st_as_sf(coordinates_clean, coords = c("WGS84_X", "WGS84_Y"), crs = 4326) 
coordinates_matching_coordinatesystem <- st_transform(coordinates_sf, crs = st_crs(potential_KBAs)) # match coordinate systems
tidy_coordinates <- coordinates_matching_coordinatesystem %>% # remove unnecessary information
  dplyr::select(Specimen_ID, geometry)
potential_KBAs$area_ID <- potential_KBAs$name # give every area an ID
specimens_in_area <- st_join(tidy_coordinates, potential_KBAs, join = st_within) # assign specimens to area

# apply 10% threshold
abundance_per_area <- table(specimens_in_area$area_ID)
area_percent <- prop.table(abundance_per_area) * 100
area_overB1 <- area_percent[area_percent > 10]
potential_KBAs_overB1 <- potential_KBAs[potential_KBAs$area_ID %in% names(area_overB1), ] # create sf object

# save results:
st_write(potential_KBAs_overB1, "i_number_of_mature_individuals/number_of_mature_individuals.shp")
