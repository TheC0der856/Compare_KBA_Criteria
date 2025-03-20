source("packages_installer.R")
# Load the libraries
library(sf)
library(dplyr)

# Define file paths
Hierro_path <- "env_variables/originals/formaciones_forestales/El_Hierro/Agrupacion_forestal_EH.shp"
Gomera_path <- "env_variables/originals/formaciones_forestales/La_Gomera/Agrupacion_Forestal_LG.shp"
Tenerife_path <- "env_variables/originals/formaciones_forestales/Tenerife/Agrupacion_Forestal_TFE.shp"
formaciones_forestales_output_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"

# Load the shapefiles
Hierro_shapefile <- st_read(Hierro_path)
Gomera_shapefile <- st_read(Gomera_path)
Tenerife_shapefile <- st_read(Tenerife_path)

# Print the first few rows to check the data
#print(head(Hierro_shapefile))


################ revise Hierro_shapefile ######################

# 1. add a column with inaccurate vegetation data
# check the information present in the file
#unique(Hierro_shapefile$C_FISIONOM)
# add an additional empty column
Hierro_shapefile <- Hierro_shapefile %>%
  mutate(inaccurate_vegetation_classification = NA)
# extract values before '|' and transfer them into the new column, NA values stay if there is no value in C_FISIONOM
Hierro_shapefile <- Hierro_shapefile %>%
  mutate(inaccurate_vegetation_classification = ifelse(
    is.na(C_FISIONOM), 
    NA, 
    sub("^(.*?)\\s*\\|.*", "\\1", C_FISIONOM)
  ))
# investigate the newly created column
#> unique(Hierro_shapefile$inaccurate_vegetation_classification)
#[1] NA                     "HERBAZALES"           "MATORRALES"           "OTROS"                "BOSQUES Y ARBUSTEDAS" "VEGETACIÓN RUPÍCOLA" 
#[7] "BOSQUES  ARBUSTEDAS" 
# there are two ways of writing forest, here is the correction:
Hierro_shapefile <- Hierro_shapefile %>%
  mutate(inaccurate_vegetation_classification = case_when(
    inaccurate_vegetation_classification %in% c("BOSQUES  ARBUSTEDAS", "BOSQUES Y ARBUSTEDAS") ~ "BOSQUES Y ARBUSTEDAS",
    TRUE ~ inaccurate_vegetation_classification
  ))


# 2. add a column with more accurate vegetation data
# check the information present in the file
#unique(Hierro_shapefile$Denomina)
# add an additional column containing the accurate vegetation information
Hierro_shapefile <- Hierro_shapefile %>%
  mutate(accurate_vegetation_classification = trimws(Denomina))
# summarize Fayal-brezal:
Hierro_shapefile <- Hierro_shapefile %>%
  mutate(accurate_vegetation_classification = case_when(
    accurate_vegetation_classification %in% c("Fayal-brezal con pinos", "Resto del Fayal – brezal") ~ "Fayal_brezal",
    TRUE ~ accurate_vegetation_classification
  ))

################ revise Gomera_shapefile ######################

# 1. add a column with inaccurate vegetation data
#unique(Gomera_shapefile$C_FISIONOM)
# add an additional empty column
Gomera_shapefile <- Gomera_shapefile %>%
  mutate(inaccurate_vegetation_classification = NA)
# extract values before '|' and transfer them into the new column, NA values stay if there is no value in C_FISIONOM
Gomera_shapefile <- Gomera_shapefile %>%
  mutate(inaccurate_vegetation_classification = ifelse(
    is.na(C_FISIONOM), 
    NA, 
    sub("^(.*?)\\s*\\|.*", "\\1", C_FISIONOM)
  ))
#unique(Gomera_shapefile$inaccurate_vegetation_classification)

# 2. add a column with more accurate vegetation data
#unique(Gomera_shapefile$Denominaci)
# add an additional column containing the accurate vegetation information
Gomera_shapefile <- Gomera_shapefile %>%
  mutate(accurate_vegetation_classification = trimws(Denominaci))
# summarize Fayal-brezal:
Gomera_shapefile <- Gomera_shapefile %>%
  mutate(accurate_vegetation_classification = case_when(
    accurate_vegetation_classification %in% c("Brezal", "Resto del Fayal – brezal") ~ "Fayal_brezal",
    TRUE ~ accurate_vegetation_classification
  ))

################ revise Tenerife_shapefile ######################

# 1. add a column with inaccurate vegetation data
#unique(Tenerife_shapefile$C_FISIONOM)
# add an additional empty column
Tenerife_shapefile <- Tenerife_shapefile %>%
  mutate(inaccurate_vegetation_classification = NA)
# extract values before '|' and transfer them into the new column, NA values stay if there is no value in C_FISIONOM
Tenerife_shapefile <- Tenerife_shapefile %>%
  mutate(inaccurate_vegetation_classification = ifelse(
    is.na(C_FISIONOM), 
    NA, 
    sub("^(.*?)\\s*\\|.*", "\\1", C_FISIONOM)
  ))
#unique(Tenerife_shapefile$inaccurate_vegetation_classification)

# 2. add a column with more accurate vegetation data
#unique(Tenerife_shapefile$Denominaci)
# add an additional column containing the accurate vegetation information
Tenerife_shapefile <- Tenerife_shapefile %>%
  mutate(accurate_vegetation_classification = trimws(Denominaci))
# summarize Fayal-brezal:
Tenerife_shapefile <- Tenerife_shapefile %>%
  mutate(accurate_vegetation_classification = case_when(
    accurate_vegetation_classification %in% c("Fayal – brezal con pinos", "Brezal" , "Resto del Fayal – brezal") ~ "Fayal_brezal",
    TRUE ~ accurate_vegetation_classification
  ))
#unique(Tenerife_shapefile$accurate_vegetation_classification)




######################### combine shapefiles ###################

formaciones_forestales_shapefile <- bind_rows(Hierro_shapefile, Gomera_shapefile, Tenerife_shapefile)
# save
st_write(formaciones_forestales_shapefile, formaciones_forestales_output_path)


