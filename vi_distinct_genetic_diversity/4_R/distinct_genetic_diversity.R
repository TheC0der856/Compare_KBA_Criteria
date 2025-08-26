# load library
library(adegenet) #genind, etc.
library(vegan)    #Delta+
library(sf)       #load areas
library(dplyr)

# copy .structure file and change file ending into .stru
# delete the first row
# load genetic data
# load genetic data
genetic_info <- read.structure("vi_distinct_genetic_diversity/2_quality_control/dataset/populations_cleaned.stru") 
364
5414 
1
2

0
n


# replace 0 with NA
genetic_info_0 <- tab(genetic_info)
genetic_info_0[genetic_info_0 == 0] <- NA
genetic_info_NA <- genind(genetic_info_0, pop = pop(genetic_info))
# remove outgroup
genetic_info_NA <- genetic_info_NA[!genetic_info_NA$pop %in% c("out1", "out2"), ]


# add populations!
# load data:
individual <- indNames(genetic_info_NA) 
coordinates <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
area <- st_read("iv_range/range.shp")
areas <- st_cast(area, "POLYGON")
# organize coordinates:
coordinates$WGS84_X <- as.numeric(gsub(",", ".", coordinates$WGS84_X))
coordinates$WGS84_Y <- as.numeric(gsub(",", ".", coordinates$WGS84_Y))
coordinates_filtered <- coordinates[coordinates$Specimen_ID %in% individual, ] # removes rows without a matching individual
coordinates_ordered <- coordinates_filtered[match(individual, coordinates_filtered$Specimen_ID), ] # same order like in individual
coordinates_clean <- coordinates_ordered[!is.na(coordinates_ordered$WGS84_X) & !is.na(coordinates_ordered$WGS84_Y), ] # avoid mistake because NA
coordinates_sf <- st_as_sf(coordinates_clean, coords = c("WGS84_X", "WGS84_Y"), crs = 4326) 
coordinates_matching_coordinatesystem <- st_transform(coordinates_sf, crs = st_crs(areas))
tidy_coordinates <- coordinates_matching_coordinatesystem %>%
                    dplyr::select(Specimen_ID, geometry)
# organize areas
areas$area_ID <- 1:nrow(areas)
# which individuals are in an area?
individual_area <- st_join(tidy_coordinates, areas, join = st_within)
#table(individual_area$area_ID)
# add the area information to genind object
population <- individual_area$area_ID
pop(genetic_info_NA) <- as.factor(population)

# calculate allele abundances
genpop <- genind2genpop(genetic_info_NA)
allele_abundances <- genpop@tab

# calculate distances
t_allele_abundances <- t(allele_abundances)
taxdis <- taxa2dist(t_allele_abundances)

# calculate distinct genetic diversity
mod <- taxondive(allele_abundances, taxdis)
#mod$Dplus

# find KBAs
# calculate ratios
sumDplus <- sum(mod$Dplus)
ratios <- mod$Dplus/sumDplus * 100
ratios # in % 
# Application of KBA criterium B1
B1 <- ratios[ratios >= 10]
#names(B1)

sort(B1, decreasing = TRUE)

# 7 east Anaga
# 6 west Anaga
# 5 Lagunetas
# 4 Teno
# 3 La Gomera
# 2 El Hierro east
# 1 El Hierro center & west


# from IDs to areas: create sf
# unnecessary because protects all, just copy from range & ESH

# 1        7        2        3        6        4        5 
# 14.40561 14.40182 14.33553 14.29799 14.25729 14.16422 14.13754 
