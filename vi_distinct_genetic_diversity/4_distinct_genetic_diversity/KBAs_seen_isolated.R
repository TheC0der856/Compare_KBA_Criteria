#load libraries
library(dplyr)
library(sf)
library(adegenet) #genind, etc.
library(vegan)    #Delta+
library(poppr)    #bitwise.dist()


# functions
calculate_EDplus <- function(genind_obj) {
  allele_frequencies <- tab(genind_obj, freq = TRUE)
  dist_matrix <- bitwise.dist(genind_obj)
  mod <- taxondive(t(allele_frequencies), dist_matrix)
  return(mod$EDplus)
}


# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")

# copy .structure file and change file ending into .stru
# delete the first row
# load genetic data
genetic_info <- read.structure("vi_distinct_genetic_diversity/2_quality_control/dataset/populations_cleaned.stru") 
345
5237
1
2

0
n

# add coordinates
# load data:
individual <- indNames(genetic_info) 
coordinates <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
# organize coordinates:
coordinates$WGS84_X <- as.numeric(gsub(",", ".", coordinates$WGS84_X))
coordinates$WGS84_Y <- as.numeric(gsub(",", ".", coordinates$WGS84_Y))
coordinates_filtered <- coordinates[coordinates$Specimen_ID %in% individual, ] # removes rows without a matching individual
coordinates_ordered <- coordinates_filtered[match(individual, coordinates_filtered$Specimen_ID), ] # same order like in individual
coordinates_clean <- coordinates_ordered[!is.na(coordinates_ordered$WGS84_X) & !is.na(coordinates_ordered$WGS84_Y), ] # avoid mistake because NA
coordinates_sf <- st_as_sf(coordinates_clean, coords = c("WGS84_X", "WGS84_Y"), crs = 4326) 
coordinates_matching_coordinatesystem <- st_transform(coordinates_sf, crs = st_crs(potential_KBAs))
tidy_coordinates <- coordinates_matching_coordinatesystem %>%
  dplyr::select(Specimen_ID, geometry)

# which individuals are in an area?
individual_area <- st_join(tidy_coordinates, potential_KBAs , join = st_within)
#table(individual_area$area_ID)
# add the area information to genind object
population <- individual_area$name
pop(genetic_info) <- as.factor(population)





# create list: one genind for each population
genind_list <- lapply(unique(population), function(pop_name) {
  inds <- which(genetic_info@pop == pop_name)  # Indizes der Individuen der Population
  genetic_info[inds, ] # Subset des genind-Objekts
})
names(genind_list) <- unique(population)

# calculate Delta+ for every genind
results_df <- data.frame(Population = character(),
                         expected_Dplus = numeric(),
                         stringsAsFactors = FALSE)
for(pop_name in names(genind_list)) {
  genind_pop <- genind_list[[pop_name]]
  if(nInd(genind_pop) < 2) { # only one individual -> NA!
    Dplus_mean <- NA
  } else {
    # calculate allele frequencies: this is simple and only possible, because diploid!
    allele_frequencies <- tab(genind_pop, freq = TRUE)
    # calculate distance
    dist_matrix <- bitwise.dist(genind_pop)
    # calculate Delta+ for every locus
    mod <- taxondive(t(allele_frequencies), dist_matrix)
  }
  # save results
  results_df <- rbind(results_df, data.frame(Population = pop_name,
                                             expected_Dplus = mod$EDplus))
}

results_df$ratios <- results_df$expected_Dplus/sum(results_df$expected_Dplus) *100

# results_df
# Population expected_Dplus    ratios
# 1        eAnaga     0.12975680  6.462291
# 2  West Anaga 1     0.12975680  6.462291
# 3  West Anaga 2     0.18139402  9.033985
# 4     Aguamansa     0.22753682 11.332040
# 5   Lagunetas 1     0.22408713 11.160234
# 6   Lagunetas 2     0.21447212 10.681377
# 7          Icod     0.20711672 10.315055
# 8          Teno     0.14968139  7.454598
# 9     Garajonay     0.17108244  8.520436
# 10       Majona     0.09760099  4.860832
# 11       Cubaba     0.04697346  2.339424
# 12     Frontera     0.13681974  6.814048
# 13     Ventejís     0.09162860  4.563389

write.csv(results_df, "vi_distinct_genetic_diversity/4_distinct_genetic_diversity/KBAs_seen_isolated.csv", row.names = FALSE)
