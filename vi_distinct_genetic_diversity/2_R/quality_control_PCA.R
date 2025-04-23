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

# load genetic data
genetic_info <- read.structure("vi_distinct_genetic_diversity/2_R/populations.str") 
355
6435 
1
0

1
n


setwd("C:/Users/Gronefeld/Desktop/D&D_examples/Ariagona_example")

genomic_converter(genind, output= "plink")

list.files()
file.rename("01_radiator_genomic_converter_20241129@1517", "Ariagona_plink")
setwd("Ariagona_plink")
list.files()
file.rename("radiator_data_20241129@1517.tfam", "Ariagona.tfam")
file.rename("radiator_data_20241129@1517.tped", "Ariagona.tped")


dir.create("results")
runPLINK("--tfile Ariagona --pca --out results/Ariagona")