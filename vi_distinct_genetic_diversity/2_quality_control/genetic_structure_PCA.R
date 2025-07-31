# PCA locations and genetic structure

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
genetic_info <- read.structure("vi_distinct_genetic_diversity/2_quality_control/dataset/populations_cleaned.stru") 
360
5321 
1
2

0
n

# add "pop" : four groups -> Islands, Tenerife two structures
# load data
individual <- indNames(genetic_info)
islands_data <- read.csv("iii_extend_of_suitable_habitat/occurrences/Ariagona_margaritae_Alles.csv")
# sort data
islands_data_reduced <- islands_data_reduced <- islands_data[islands_data$Specimen_ID %in% individual, ] # removes rows without a matching individual
islands_data_ordered <- islands_data_reduced[match(individual, islands_data_reduced$Specimen_ID), ] # same order like in individual
population <- islands_data_ordered$Island
#islands_data_ordered$Place_Name # 136 starts west
cut <- 136
population[population == "Tenerife" & seq_along(population) < cut] <- "east_Tenerife"
population[population == "Tenerife" & seq_along(population) >= cut] <- "west_Tenerife"
# add population
pop(genetic_info ) <- as.factor(population)


# path were plink files should be saved
setwd("vi_distinct_genetic_diversity/plink_data")

# convert files into plink format
genomic_converter(genetic_info, output= "plink")

# rename files
list.files()
file.rename("01_radiator_genomic_converter_20250731@1138", "genetic_structure")
setwd("genetic_structure")
list.files()
file.rename("radiator_data_20250731@1138.tfam", "genetic_structure.tfam")
file.rename("radiator_data_20250731@1138.tped", "genetic_structure.tped")

# create directory for results
dir.create("results")
runPLINK("--tfile genetic_structure --pca --out results/genetic_structure")

# load results into R
eigenValues <- read_delim("results/genetic_structure.eigenval", delim = " ", col_names = F)
eigenVectors <- read_delim("results/genetic_structure.eigenvec", delim = " ", col_names = F)
eigen_percent <- round((eigenValues/ (sum(eigenValues))*100), 2)

# create a plot
PCAplot <- ggplot(data = eigenVectors)  +
  geom_point(mapping = aes(x = X3, y = X4, color = factor(X1), shape = factor(X1)), size = 2, show.legend = TRUE) +
  scale_color_manual(values = c("east_Tenerife" = "goldenrod", "west_Tenerife" = "cadetblue", "La_Gomera" = "palegreen", "El_Hierro" = "tan4")) + 
  scale_shape_manual(values = c("east_Tenerife" = 16, "west_Tenerife" = 16, "La_Gomera" = 16, "El_Hierro" = 16 )) +                     
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

ggsave("genetic_structure_PCA.jpg", 
       plot = PCAplot, 
       width =  11.69, 
       height = 8.27, 
       dpi = 300) 

setwd("..")
setwd("..")
