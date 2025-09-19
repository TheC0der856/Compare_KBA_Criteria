#load libraries
library(dplyr)
library(sf)
library(adegenet) #genind, etc.
library(vegan)    #Delta+

# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")

# copy .structure file and change file ending into .stru
# delete the first row
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


# add coordinates
# load data:
individual <- indNames(genetic_info_NA) 
coordinates <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
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



# which individuals are in an area?
individual_area <- st_join(tidy_coordinates, potential_KBAs , join = st_within)
#table(individual_area$area_ID)
# add the area information to genind object
population <- individual_area$name
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
sorted_ratios <- sort(ratios, decreasing = TRUE)

# Application of KBA criterium B1
B1 <- ratios[ratios >= 10]
#names(B1)


