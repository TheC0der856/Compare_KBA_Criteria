#load libraries
library(dplyr)
library(sf)
#library(tmap)

# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")
# area of occupancy:
AOO <- st_read("ii_area_of_occupancy/AOO_all.shp")


# tmap_mode("view")
# tm_shape(potential_KBAs) +
#   tm_polygons(col = "lightgreen", alpha = 0.4, border.col = "darkgreen", lwd = 2, title = "Potential KBAs") +
#   tm_shape(AOO) +
#   tm_polygons(col = "red", alpha = 0.5, border.col = "darkred", lwd = 1, title = "AOO") +
#   tm_layout(legend.outside = TRUE)

total_AOO <- sum(st_area(AOO))

# % of suitable habitat of each potential KBA
kba_coverage <- potential_KBAs %>%
  rowwise() %>%  # wichtig, um Zeile für Zeile zu rechnen
  mutate(
    total_area = st_area(geometry),
    AOO_area = sum(st_area(st_intersection(geometry, AOO))),
    percent_covered = as.numeric(AOO_area / total_AOO * 100)
  ) %>%
  ungroup() %>%
  select(name, total_area, AOO_area, percent_covered)

# apply B1 
selected_KBAs <- kba_coverage[kba_coverage$percent_covered > 10, ]

# save KBAs selected with range:
st_write(selected_KBAs, "combine_criteria/select_areas/selected_KBAs_with_AOO.shp")

