# compare 2023 and 2024 lab data

# packages:
if (!requireNamespace("adegenet", quietly = TRUE)) {
  install.packages("adegenet")
} 
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
if (!requireNamespace("radiator", quietly = TRUE)) {
  devtools::install_github("thierrygosselin/radiator")
}
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
  library(ggplot2)
}
library(adegenet)
library(radiator)
library(readr)
library(ggplot2)

# define function
runPLINK <- function(PLINKoptions = "") {
  system(paste('"C:/Program Files/plink_win64_20241022/plink"', PLINKoptions))
}

# copy .structure file and change file ending into .stru
# delete the first row
# load genetic data
genetic_info <- read.structure("vi_distinct_genetic_diversity/3_R/populations.stru") 
366
4988 
1
2

1
n

# add "pop" : two groups -> 2023 and 2025
# load data
individual <- indNames(genetic_info)
year <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
# sort year data
year_reduced <- year[year$Specimen_ID %in% individual, ] # removes rows without a matching individual
year_ordered <- year_reduced[match(individual, year_reduced$Specimen_ID), ] # same order like in individual
population <- year_ordered$should.be.sequenced.
population_year <- ifelse(population == "successfull", "2023", "2025")
# add population
pop(genetic_info ) <- as.factor(population_year)

# remove outgroup
# Identify non-NA population indices
valid_indices <- !is.na(pop(genetic_info))
# Subset the genind object to include only individuals with valid population info
genetic_info <- genetic_info[valid_indices, ]

# path were plink files should be saved
setwd("vi_distinct_genetic_diversity/plink_data")

# convert files into plink format
genomic_converter(genetic_info, output= "plink")

# rename files
list.files()
file.rename("02_radiator_genomic_converter_20250724@1441", "Ariagona_plink")
setwd("Ariagona_plink")
list.files()
file.rename("radiator_data_20250724@1441.tfam", "Ariagona.tfam")
file.rename("radiator_data_20250724@1441.tped", "Ariagona.tped")

# create directory for results
dir.create("results")
runPLINK("--tfile Ariagona --pca --out results/Ariagona")

# load results into R
eigenValues <- read_delim("results/Ariagona.eigenval", delim = " ", col_names = F)
eigenVectors <- read_delim("results/Ariagona.eigenvec", delim = " ", col_names = F)
eigen_percent <- round((eigenValues/ (sum(eigenValues))*100), 2)

# create a plot
PCAplot <- ggplot(data = eigenVectors)  +
  geom_point(mapping = aes(x = X3, y = X4, color = factor(X1), shape = factor(X1)), size = 2, show.legend = TRUE) +
  scale_color_manual(values = c("2023" = "goldenrod", "2025" = "cadetblue")) + 
  scale_shape_manual(values = c("2023" = 16, "2025" = 16)) +                     
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_vline(xintercept = 0, linetype = "dotted") + 
  labs(
    x = paste0("Principal component 1 (", eigen_percent[1,1], " %)"),
    y = paste0("Principal component 2 (", eigen_percent[2,1], " %)")) +
  theme_minimal() +
  theme(
    legend.position = "none", 
    panel.background = element_rect(fill = "white", color = NA),  
    plot.background = element_rect(fill = "white", color = NA),
    axis.title = element_text(size = 20, face = "bold"), 
    axis.text = element_text(size = 15, face = "bold"),                 
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20),
    panel.spacing = unit(2, "lines")
  )




# save plot 
setwd("..")

ggsave("PCA.jpg", 
       plot = PCAplot, 
       width =  11.69, 
       height = 8.27, 
       dpi = 300) 

setwd("..")
setwd("..")
