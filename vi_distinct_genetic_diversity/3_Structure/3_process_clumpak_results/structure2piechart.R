# prepare table to display pie charts with structure results in ArcGIS

# load packages
library("dplyr")
library("tidyr")
library("sf")


############################## import data ####################################################
# population structure
q_matrix <- read.csv("vi_distinct_genetic_diversity/3_Structure/clumpak_data/K=4/MinorCluster1/CLUMPP.files/ClumppIndFile.output", 
                     header = FALSE, 
                     sep = "", 
                     fill = TRUE)
# IDs of individuals
stru <- read.table("vi_distinct_genetic_diversity/2_quality_control/dataset/populations_cleaned.stru",
                   header = FALSE, stringsAsFactors = FALSE)
ind_ids <- stru[,1]
specimenID <- unique(ind_ids)
# coordinates
coordinates <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
areas <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")




############################# organize structure results #######################################
cluster_probs <- q_matrix[, 6:9] 
colnames(cluster_probs) <- c("Cluster1", "Cluster2", "Cluster3", "Cluster4")
cluster_probs$id <- unique(specimenID)
prob_col <- c()
for (ind_number in 1:nrow(cluster_probs)){  
  for (cluster_number in 1:4){
    cluster_prob <- cluster_probs[ind_number,cluster_number]
    prob_col <- c(prob_col, cluster_prob)
  }
}
cluster_col <- c()
for(ind_number in 1:nrow(cluster_probs)) {
  cluster_name <- c(1, 2, 3, 4)
  cluster_col <- c(cluster_col, cluster_name)
}
ind_col <- c()
for(ind_number in 1:nrow(cluster_probs)) {
  ind_name <- c(rep(cluster_probs[ind_number, "id"], 4)) 
  ind_col <- c(ind_col, ind_name)
}
organised_cluster_probs <- data.frame(specimen_id = ind_col, 
                                      prob = prob_col, 
                                      cluster = cluster_col)



########################### organize area coordinates ################################################
coordinates$WGS84_X <- as.numeric(gsub(",", ".", coordinates$WGS84_X))
coordinates$WGS84_Y <- as.numeric(gsub(",", ".", coordinates$WGS84_Y))
coordinates_filtered <- coordinates[coordinates$Specimen_ID %in% specimenID, ] # removes rows without a matching individual
coordinates_ordered <- coordinates_filtered[match(specimenID, coordinates_filtered$Specimen_ID), ] # same order like in individual
coordinates_clean <- coordinates_ordered[!is.na(coordinates_ordered$WGS84_X) & !is.na(coordinates_ordered$WGS84_Y), ] # avoid mistake because NA
coordinates_sf <- st_as_sf(coordinates_clean, coords = c("WGS84_X", "WGS84_Y"), crs = 4326) 
coordinates_matching_coordinatesystem <- st_transform(coordinates_sf, crs = st_crs(areas)) # match coordinate systems
tidy_coordinates <- coordinates_matching_coordinatesystem %>% # remove unnecessary information
  dplyr::select(Specimen_ID, geometry)
areas$area_ID <- 1:nrow(areas) # give every area an ID
specimens_in_area <- st_join(tidy_coordinates, areas, join = st_within) # assign specimens to area

########################### structure results with area coordinates combined ###########################
coordinate_cluster <- data.frame(
  area_ID = character(),
  Cluster1 = numeric(),
  Cluster2 = numeric(),
  Cluster3 = numeric(),
  Cluster4 = numeric(),
  stringsAsFactors = FALSE
)
# add area information to organised_cluster_probs
organised_cluster_probs <- merge(
  organised_cluster_probs,
  specimens_in_area[, c("Specimen_ID", "area_ID")],
  by.x = "specimen_id",
  by.y = "Specimen_ID",
  all.x = TRUE
)
# calculate the average of cluster percentages per area 
areaID_cluster <- organised_cluster_probs %>%
  group_by(area_ID, cluster) %>%
  summarise(mean_prob = mean(prob), .groups = "drop") %>%
  pivot_wider(
    names_from = cluster,
    values_from = mean_prob,
    names_prefix = "Cluster"
  ) %>%
  replace(is.na(.), 0)
#add geometry
coordinate_cluster_sf <- left_join(areas, areaID_cluster, by = "area_ID")
# add another column with the frequency of coordinates for having the possibility to adjust for pie chart size?


## save resulting sf
st_write(coordinate_cluster_sf, "vi_distinct_genetic_diversity/3_Structure/structure_pie_charts.shp")


