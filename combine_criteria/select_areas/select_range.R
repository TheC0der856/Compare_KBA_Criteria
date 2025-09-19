# iv range über 10% für jedes Gebiet?

#load packages
library(sf)


#load data:
#load range
range <- st_read("C:/Users/Gronefeld/Desktop/Compare_KBA_criteria/iv_range/range.shp")
#load potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")


# area size range:
m2_range <- sum(st_area(range))
# potential KBAs
potential_KBAs$area_m2 <- st_area(potential_KBAs)
# % of KBAs to range
potential_KBAs$percent_of_range <- as.numeric((potential_KBAs$area_m2 / m2_range) * 100)

# apply B1 
selected_KBAs <- potential_KBAs[potential_KBAs$percent_of_range > 10, ]

# save KBAs selected with range:
st_write(selected_KBAs, "combine_criteria/selected_KBAs_with_range.shp")