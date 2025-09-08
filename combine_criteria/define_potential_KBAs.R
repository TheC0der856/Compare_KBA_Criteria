library(sf)
library(dplyr)
library(tmap)

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
tmap_mode("view")
tm_shape(ranges) +
  tm_polygons("area_km2", palette = "viridis", title = "Fläche (km²)")


# load protected areas
protected_area <- st_read("C:/Users/Gronefeld/Desktop/Compare_KBA_Criteria/combine_criteria/protected_areas/eennpp/eennpp.shp")
protected_areas <- st_cast(protected_area, "POLYGON")
# calculate area size 
protected_areas <- protected_areas %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 10^6)
print(protected_areas %>% select(area_km2))
# view protected areas
tmap_mode("view")
tm_shape(protected_areas) +
  tm_polygons("area_km2", palette = "viridis", title = "Fläche (km²)")

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
# Anaga: extracted area from range
east_anaga <- ranges %>%
  filter(id == "eAnaga") %>%
  mutate(name = "eAnaga") %>%
  select(name, geometry)

west_anaga <- ranges %>%
  filter(id == "wAnaga") %>%
  mutate(name = "wAnaga") %>%
  select(name, geometry)


# calculate Lagunetas2: 
# range of area close to Las Lagunetas and La Laguna
range_lagunetas <- ranges %>%
  filter(id == "Lagunetas") %>%
  mutate(name = "Lagunetas") %>%
  select(name, geometry)
# protected area in the range
protected_areas_lagunetas <- protected_areas %>%
  filter(nombre %in% c("Las Lagunetas", "La Resbala")) %>%
  select(geometry)
protected_area_lagunetas <- st_union(protected_areas_lagunetas)
# divide
range_rest_lagunetas <- st_difference(range_lagunetas, protected_area_lagunetas)
# separate in single polygons
ranges_rest_lagunetas <- st_cast(range_rest_lagunetas, "POLYGON")
# keep largest polygon
lagunetas2 <- ranges_rest_lagunetas  %>%
  slice_max(as.numeric(st_area(geometry)), n = 1)

# Las Lagunetas
# extracted area from protected areas
las_lagunetas <- protected_areas %>%
  filter(nombre == "Las Lagunetas") %>%
  mutate(name = "Las Lagunetas") %>%
  select(name, geometry)

# calculate Aguamansa
aguamansa <- ranges_rest_lagunetas %>%
  slice_max(as.numeric(st_area(geometry)), n = 2) %>%  # zwei größte Polygone auswählen
  slice(2) %>%                                         # nur das zweitgrößte behalten
  select(name, geometry)

# calculate Icod: 
# range west Tenerife, called "Teno"
range_westTenerife <- ranges %>%
  filter(id == "Teno") %>%
  mutate(name = "Teno") %>%
  select(name, geometry)
# protected area west Tenerife, called "Teno" and "Chinyero"
protected_area_teno_chinyero <- protected_areas %>%
  filter(nombre %in% c("Teno", "Chinyero")) %>%
  select(geometry)
protected_area_westTenerife <- st_union(protected_area_teno_chinyero)
# non-protected range west Tenerife by "Teno" and "Chinyero"
range_rest_westTenerife <- st_difference(range_westTenerife, protected_area_westTenerife)
# separate in single polygons
ranges_rest_westTenerife <- st_cast(range_rest_westTenerife, "POLYGON")
# keep largest polygon
icod <- ranges_rest_westTenerife %>%
  slice_max(as.numeric(st_area(geometry)), n = 1)

# Chinyero (Aussprache: Chiñero)
# extracted area from protected areas
chinyero <- protected_areas %>%
  filter(nombre == "Chinyero") %>%
  mutate(name = "Chinyero") %>%
  select(name, geometry)

# Teno
# extracted area from protected areas
teno <- protected_areas %>%
  filter(nombre == "Teno") %>%
  mutate(name = "Teno") %>%
  select(name, geometry)



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
                        anaga, lagunetas2, las_lagunetas, aguamansa, icod, chinyero, teno,
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