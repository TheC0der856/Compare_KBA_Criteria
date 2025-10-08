#load libraries
library(dplyr)
library(sf)


# load data:
# potential KBAs
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")
# isolated KBAs
isolated_KBAs <- read.csv("vi_distinct_genetic_diversity/4_distinct_genetic_diversity/KBAs_seen_isolated.csv")
# different thresholds on combinations
kba_files <- c(
  "KBAs_90.csv", "KBAs_95.csv", "KBAs_98.csv", 
  "KBAs_99.csv", "KBAs_995.csv", "KBAs_998.csv", "KBAs_999.csv", "KBAs_100.csv"
)
kba_ids <- c("KBA90", "KBA95", "KBA98", "KBA99", "KBA995", "KBA998", "KBA999", "KBA100")
KBAs_list <- lapply(kba_files, function(f) {
  read.csv(file.path("vi_distinct_genetic_diversity/4_distinct_genetic_diversity", f))
})
names(KBAs_list) <- kba_ids



# select areas
B1_area_names <- isolated_KBAs$Population[isolated_KBAs$ratios > 10]
B1_KBAs <- potential_KBAs %>%
  filter(name %in% B1_area_names)

B1_KBAs <- lapply(names(KBAs_list), function(kba_name) {
  names <- strsplit(KBAs_list[[kba_name]]$areaS[1], "_")[[1]]
  filtered <- potential_KBAs %>% filter(name %in% names)
  filtered
})
names(B1_KBAs) <- kba_ids


# save them
st_write(B1_KBAs, "combine_criteria/select_areas/selected_KBAs_with_DnD_isolated_KBAs.shp")

output_dir <- "combine_criteria/select_areas/select_KBAs_with_DnD_minimizing_problem"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
lapply(names(B1_KBAs), function(n) {
  output_path <- file.path(output_dir, paste0(n, ".shp"))
  st_write(B1_KBAs[[n]], output_path, delete_dsn = TRUE)
})