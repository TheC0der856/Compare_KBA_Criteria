#load libraries
library(sf)
library(dplyr)

# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")
# localities:
localities <- st_read("v_number_of_localities/localities.shp")

# number of localities: 29

# sort every locality to KBA name
localities_in_KBA <- st_join(localities, potential_KBAs, join = st_within)

# count locality per KBA
counts <- localities_in_KBA %>%
  st_set_geometry(NULL) %>%          # remove locality geometry
  group_by(name) %>%          
  summarise(n_localities = n(), .groups = "drop")

# calculate percentage & filter for B1 criterium: 
B1 <- counts %>%
  mutate(percent_of_29 = (n_localities / 29) * 100) %>%
  filter(percent_of_29 > 10)

# extract area bounderies of selected area names: 
selected_KBAs <- potential_KBAs %>%
  filter(name %in% B1$name)

# save KBAs selected with localities:
st_write(selected_KBAs, "combine_criteria/select_areas/selected_KBAs_with_localities.shp")