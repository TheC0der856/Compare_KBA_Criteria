library(dplyr)
library(sf)

# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")
# suitable habitat:
suitable_habitat <- st_read("iii_extend_of_suitable_habitat/suitable_habitat.shp")


total_suitable_area <- sum(st_area(suitable_habitat))

# % of suitable habitat of each potential KBA
kba_coverage <- potential_KBAs %>%
  rowwise() %>%  # wichtig, um Zeile für Zeile zu rechnen
  mutate(
    total_area = st_area(geometry),
    habitat_area = sum(st_area(st_intersection(geometry, suitable_habitat))),
    percent_covered = as.numeric(habitat_area / total_suitable_area  * 100)
  ) %>%
  ungroup() %>%
  select(name, total_area, habitat_area, percent_covered)


# apply B1 
selected_KBAs <- kba_coverage[kba_coverage$percent_covered > 10, ]

# save KBAs selected with range:
st_write(selected_KBAs, "combine_criteria/select_areas/selected_KBAs_with_suitable_habitat.shp")