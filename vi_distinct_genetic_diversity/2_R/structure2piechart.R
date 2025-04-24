# prepare table to display pie charts with structure results in ArcGIS

# load packages
library("dplyr")
library("tidyr")


############################## import data ####################################################
# population structure
q_matrix <- read.csv("Clumpak_results/Ariagona/1741606813/K=3/MajorCluster/CLUMPP.files/ClumppIndFile.output", 
                     header = FALSE, 
                     sep = "", 
                     fill = TRUE)
# IDs of individuals
specimenID <- read.csv("vi_distinct_genetic_diversity/2_R/populations.str", 
                  header = FALSE, 
                  sep = "", 
                  fill = TRUE)
specimenID <- unique(specimenID$V1[-1])
# coordinates
coordinates <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
area <- st_read("iv_range/range.shp")
areas <- st_cast(area, "POLYGON")



############################# organize structure results #######################################
cluster_probs <- q_matrix[, 6:8] # needs to be changed for sure!
colnames(cluster_probs) <- c("Cluster1", "Cluster2", "Cluster3", "Cluster4")
cluster_probs$id <- specimenID
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
  ind_name <- c(rep(cluster_probs[ind_number, 4], 3)) # needs to be adjusted?
  ind_col <- c(ind_col, ind_name)
}
organised_cluster_probs <- data.frame(id = ind_col, 
                                      prob = prob_col, 
                                      cluster = cluster_col)



########################### organize area coordinates ################################################
coordinates$WGS84_X <- as.numeric(gsub(",", ".", coordinates$WGS84_X))
coordinates$WGS84_Y <- as.numeric(gsub(",", ".", coordinates$WGS84_Y))
coordinates_filtered <- coordinates[coordinates$Specimen_ID %in% specimenID, ] # removes rows without a matching individual
coordinates_ordered <- coordinates_filtered[match(specimenID, coordinates_filtered$Specimen_ID), ] # same order like in individual
coordinates_sf <- st_as_sf(coordinates_ordered, coords = c("WGS84_X", "WGS84_Y"), crs = 4326) 
coordinates_matching_coordinatesystem <- st_transform(coordinates_sf, crs = st_crs(areas)) # match coordinate systems
tidy_coordinates <- coordinates_matching_coordinatesystem %>% # remove unnecessary information
  dplyr::select(Specimen_ID, geometry)
areas$area_ID <- 1:nrow(areas) # give every area an ID
specimens_in_area <- st_join(tidy_coordinates, areas, join = st_within) # assign specimens to area

########################### structure results with area coordinates combined ###########################
coordinate_cluster <- data.frame(
  coordinate = character(),
  Cluster1 = numeric(),
  Cluster2 = numeric(),
  Cluster3 = numeric(),
  Cluster4 = numeric(),
  stringsAsFactors = FALSE
)
# which individuals were found at which sites?
ids_per_coordinates <- aggregate(ID ~ combined_coordinates, data = site_coordinates, FUN = toString)
specimens_in_area$area_ID
# calculate the average of cluster percentages per area 
for (i in seq(ids_per_coordinates$combined_coordinates)) {
  coordinate <- unlist(strsplit(ids_per_coordinates[i, "combined_coordinates"], ", "))
  ids_per_coordinate <- unlist(strsplit(ids_per_coordinates[i, "ID"], ", "))
  cluster_probs_data <- cluster_probs[cluster_probs$id %in% ids_per_coordinate,  ]
  average_cluster_probs <- colMeans(cluster_probs_data[,1:4])
  # save results for every coordinate
  coordinate_cluster <- rbind(coordinate_cluster ,data.frame(
    coordinate = coordinate,
    Cluster1 = average_cluster_probs["Cluster1"],
    Cluster2 = average_cluster_probs["Cluster2"],
    Cluster3 = average_cluster_probs["Cluster3"], 
    Cluster4 = average_cluster_probs["Cluster4"]
  ))
}
# better row names, to avoid confusion
rownames(coordinate_cluster) <- NULL
# add another column with the frequency of coordinates for having the possibility to adjust for pie chart size
#freq_coordinates <- table(site_coordinates$combined_coordinates)
#coordinate_cluster$freq_coordinates <- freq_coordinates[coordinate_cluster$coordinate]
# separate coordinates again 
coordinate_cluster <- coordinate_cluster %>%
  separate(coordinate, into = c("WGS84_X", "WGS84_Y"), sep = "_", convert = TRUE)


## save resulting pie chart table
write.csv(coordinate_cluster, "structure_pie_charts.csv")

