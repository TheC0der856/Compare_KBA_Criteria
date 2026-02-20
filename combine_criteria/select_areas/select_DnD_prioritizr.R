#load libraries
library(dplyr)
library(sf)


# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")

selected_KBAs <- potential_KBAs %>%
  filter(name %in% c("Lagunetas 2", "Aguamansa", "Cubaba", "Frontera"))

write_sf(selected_KBAs, "combine_criteria/select_areas/DnD_prioritizr.shp")