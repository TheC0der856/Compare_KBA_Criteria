library(sf)
library(dplyr)
library(tmap)
library(lwgeom) # für st_split

#load range
range <- st_read("C:/Users/Gronefeld/Desktop/Compare_KBA_criteria/iv_range/range.shp")
ranges <- st_cast(range, "POLYGON")
# add ids
ranges <- ranges %>%
  mutate(id = c("wHierro", 
                "eHierro", 
                "Gomera", 
                "Teno",
                "Lagunetas",
                "wAnaga",
                "eAnaga"))
# calculate area size
ranges <- ranges %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 10^6)
print(ranges %>% select(area_km2))
# view areas
# tmap_mode("view")
# tm_shape(ranges) +
#   tm_polygons("area_km2", palette = "viridis", title = "Fläche (km²)")


# load protected areas
protected_area <- st_read("C:/Users/Gronefeld/Desktop/Compare_KBA_Criteria/combine_criteria/protected_areas/eennpp/eennpp.shp")
protected_areas <- st_cast(protected_area, "POLYGON")
# calculate area size 
protected_areas <- protected_areas %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 10^6)
print(protected_areas %>% select(area_km2))
# view protected areas
# tmap_mode("view")
# tm_shape(protected_areas) +
#   tm_polygons("area_km2", palette = "viridis", title = "Fläche (km²)")

# load KBAs
KBA <- st_read("C:/Users/Gronefeld/Desktop/Compare_KBA_criteria/combine_criteria/KBA_March2025/KBAsGlobal_2025_March_01/KBAsGlobal_2025_March_01_POL.shp")
KBAs <- st_cast(KBA, "POLYGON")
# equal CRS/ projection
KBAs <- st_transform(KBAs, st_crs(protected_areas))
# only interested in Canary Islands
KBAs_small <- st_crop(KBAs, st_bbox(protected_areas))
# # view KBAs
# tmap_mode("view")  
# tm_shape(KBAs_small) +
#   tm_polygons(col = "yellow",
#               fill_alpha = 0.4,
#               border.col = "orange",
#               fill.legend = tm_legend(title = "KBAs (cropped)"))



# Overlaps
overlap <- st_intersection(protected_areas, ranges)
# # view overlaps
# tmap_mode("view")
# tm_shape(protected_areas) + 
#   tm_polygons(col = "green", alpha = 0.4, border.col = "darkgreen", title = "Protected Areas") +
#   tm_shape(ranges) +
#   tm_polygons(col = "blue", alpha = 0.4, border.col = "darkblue", title = "Ranges") +
#   tm_shape(overlap) +
#   tm_polygons(col = "red", alpha = 0.6, border.col = "black", title = "Overlap")

# Collection points
# load collection point data
occ_data <-  read.csv("C:/Users/Gronefeld/Desktop/Compare_KBA_criteria/iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv", sep = ",")
# Extract and clean coordinates 
# only for rows which are not potential collection points and have exact coordinates
occ.std <- occ_data[!is.na(occ_data$Specimen_ID) & occ_data$Specimen_ID != "", c("WGS84_X", "WGS84_Y")]
# Remove duplicate coordinate pairs
occ.std <- occ.std[!duplicated(occ.std),]  
# Replace commas with dots and convert to numeric values
occ.std$WGS84_X <- as.numeric(sub(",", ".", occ.std$WGS84_X))
occ.std$WGS84_Y <- as.numeric(sub(",", ".", occ.std$WGS84_Y))
# Remove rows with missing values (NA)
occ.std <- occ.std[complete.cases(occ.std), ]
# adjust collection points to the same dimensions like the protected areas and the range
# transform to sf object
occ_points <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
# equal CRS/ projection
occ_points <- st_transform(occ_points, st_crs(protected_areas))

# Show map including the collection points: 
# tmap_mode("view")
# tm_shape(protected_areas) + 
#   tm_polygons(col = "green", alpha = 0.4, border.col = "darkgreen", title = "Protected Areas") +
#   tm_shape(ranges) +
#   tm_polygons(col = "blue", alpha = 0.4, border.col = "darkblue", title = "Ranges") +
#   tm_shape(overlap) +
#   tm_polygons(col = "red", alpha = 0.6, border.col = "black", title = "Overlap") +
#   tm_shape(occ_points) +
#   tm_dots(col = "black", size = 0.6, title = "Occurrence Points") 

# Show map including KBAs
tmap_mode("view")

tm_shape(protected_areas) + 
  tm_polygons(col = "green", fill_alpha = 0.4, border.col = "darkgreen",
              fill.legend = tm_legend(title = "Protected Areas")) +
  tm_shape(ranges) +
  tm_polygons(col = "blue", fill_alpha = 0.4, border.col = "darkblue",
              fill.legend = tm_legend(title = "Ranges")) +
  tm_shape(overlap) +
  tm_polygons(col = "red", fill_alpha = 0.6, border.col = "black",
              fill.legend = tm_legend(title = "Overlap")) +
  tm_shape(occ_points) +
  tm_dots(col = "black", size = 0.6,
          col.legend = tm_legend(title = "Occurrence Points")) +
  tm_shape(KBAs_small) +
  tm_polygons(col = "yellow", fill_alpha = 0.4, border.col = "orange",
              fill.legend = tm_legend(title = "KBAs"))



# potential KBAs
# empty sf object
potential_KBAs <- st_sf(
  name = character(),
  geometry = st_sfc(crs = st_crs(protected_areas))
)


################# Extract areas: ################
#################################################

################# Tenerife ######################
####### Anaga
# east Anaga: extracted area from range
east_anaga <- ranges %>%
  filter(id == "eAnaga") %>%
  mutate(name = "eAnaga") %>%
  select(name, geometry)
# west Anaga: extracted area from range
west_anaga <- ranges %>%
  filter(id == "wAnaga") %>%
  mutate(name = "wAnaga") %>%
  select(name, geometry)
# create two areas of the approx. same size
west_anaga_split <- st_split(
  west_anaga,
  st_sfc(st_linestring(matrix(
    c(mean(c(st_bbox(west_anaga)[c("xmin","xmax")])) - 100,
      st_bbox(west_anaga)["ymin"],
      mean(c(st_bbox(west_anaga)[c("xmin","xmax")])) - 100,
      st_bbox(west_anaga)["ymax"]),
    ncol = 2, byrow = TRUE
  )), crs = st_crs(west_anaga))
) %>%
  st_collection_extract("POLYGON") %>%
  st_sf() %>%
  mutate(area = st_area(geometry)) %>%
  arrange(area) %>%
  summarise(geometry = c(st_union(geometry[1:2]), geometry[3]))
# safe both areas under seperate ids
west_anaga1 <- west_anaga_split[1, ]
west_anaga2 <- west_anaga_split[2, ]


####### Lagunetas
# range including las Lagunetas 
range_lagunetas <- ranges %>%
  filter(id == "Lagunetas") %>%
  mutate(name = "Lagunetas") %>%
  select(name, geometry)
# protected area "La Resbala" in the range
protected_area_lagunetas <- protected_areas %>%
  filter(nombre == "La Resbala") %>%
  select(geometry)
# isolate la Resbala and everything westwards of la Resbala
inside <- st_intersection(range_lagunetas, protected_area_lagunetas)
outside <- st_difference(range_lagunetas, protected_area_lagunetas)
outside_smallest <- st_sf(geometry = st_cast(outside, "POLYGON")) %>% filter(st_area(geometry) == min(st_area(geometry)))
la_resbala <- st_union(outside_smallest, inside)
# devide the rest of the range in two:
outside_biggest <- st_sf(geometry = st_cast(outside, "POLYGON")) %>% filter(st_area(geometry) == max(st_area(geometry)))
bbox <- st_bbox(outside_biggest)
lagunetas_split <- st_split(
  outside_biggest,
  st_sfc(st_linestring(matrix(c(
    bbox["xmin"] - offset, bbox["ymax"] - 1000,
    bbox["xmax"] - offset, bbox["ymin"] - 1000
  ), ncol = 2, byrow = TRUE)), crs = st_crs(outside_biggest))
) %>% st_collection_extract("POLYGON") %>% st_sf()
lagunetas1 <- lagunetas_split[2, ]
lagunetas2 <- lagunetas_split[1, ]


####### Teno
# range called "Teno"
range_westTenerife <- ranges %>%
  filter(id == "Teno") %>%
  mutate(name = "Teno") %>%
  select(name, geometry)
# protected area called "Teno" 
protected_area_teno <- protected_areas %>%
  filter(nombre == "Teno") %>%
  select(geometry)
# devide in icod and teno
icod <- st_difference(range_westTenerife, protected_area_teno )
teno <- st_intersection(range_westTenerife, protected_area_teno)




################# La Gomera ######################
# Majona
# extracted area from protected areas
majona <- protected_areas %>%
  filter(nombre == "Majona") %>%
  mutate(name = "Majona") %>%
  select(name, geometry)

# instead of protected areas, use KBA, because it is more inclusive!
# # Garajonay
# # extracted area from protected areas
# garajonay <- protected_areas %>%
#   filter(nombre == "Garajonay") %>%
#   mutate(name = "Garajonay") %>%
#   select(name, geometry)
# # Benchijigua
# # extracted area from protected areas
# benchijigua <- protected_areas %>%
#   filter(nombre == "Benchijigua") %>%
#   mutate(name = "Benchijigua") %>%
#   select(name, geometry)
garajonay <- KBAs %>%
  filter(intname == "Garajonay National Park") %>%
  mutate(name = "Garajonay") %>%
  select(name, geometry)

# Lomo del Carretón
# extracted area from protected areas
carreton <- protected_areas %>%
  filter(nombre == "Lomo del Carretón") %>%
  mutate(name = "Lomo del Carretón") %>%
  select(name, geometry)

# Northern Gomera (Vallehermoso?)
# range Gomera
range_Gomera <- ranges %>%
  filter(id == "Gomera") %>%
  mutate(name = "Gomera") %>%
  select(name, geometry)
barrier_Gomera <- st_union(carreton, garajonay)
range_Gomera_minus_barrier <- st_difference(range_Gomera, barrier_Gomera)
# separate in single polygons
ranges_Gomera_minus_barrier <- st_cast(range_Gomera_minus_barrier, "POLYGON")
# keep vallehermoso polygon
vallehermoso <- ranges_Gomera_minus_barrier %>%
  slice_max(as.numeric(st_area(geometry)), n = 2) %>%  # die zwei größten Polygone
  slice(2) %>%                                         # nur das zweitgrößte auswählen
  select(name, geometry)

################# El Hierro ######################

# range around Ventejís
# extracted area from ranges
ventejis <- ranges %>%
  filter(id == "eHierro") %>%
  mutate(name = "modified_Ventejís") %>%
  select(name, geometry)

# Frontera
# extracted area from protected areas
frontera <- protected_areas %>%
  filter(nombre == "Frontera") %>%
  mutate(name = "Frontera") %>%
  select(name, geometry)

potential_KBAs <- rbind(potential_KBAs, 
                        east_anaga, west_anaga1, west_anaga2, lagunetas1, lagunetas2, la_resbala, icod, teno,
                        majona, garajonay, carreton, vallehermoso,
                        ventejis, frontera)

# view potential_KBAs
tmap_mode("view")
tm_shape(potential_KBAs) +
  tm_polygons(
    col = "purple",       # Füllfarbe
    alpha = 0.5,          # Transparenz
    border.col = "black", # Polygonränder
    title = "Potential KBAs"
  ) +
tm_shape(occ_points) +
  tm_dots(col = "black", size = 0.6,
          col.legend = tm_legend(title = "Occurrence Points")) 


# icod - Acantilados de La Culata & Interián?
# Aguamansa was machen mit Corona Forestal?
# Gomera??: überschneidung majona und garajonay