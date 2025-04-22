# load library
library(adegenet)
library(poppr)


# load genetic data
structure_unprocessed <- read.structure("vi_distinct_genetic_diversity/2_R/populations.str") 
355
6435 
1
0

1
n


# remove individuals and loci >20% missing data
# replace 0 with NA
structure_0 <- tab(structure_unprocessed)
structure_0[structure_0 == 0] <- NA
structure_NA <- genind(structure_0, pop = pop(structure_unprocessed))

# remove individuals with >20% missing data
structure_geno_removed <- missingno(structure_NA, type = "geno", cutoff = 0.2)
# 0 genotypes contained missing values greater than 20%, Removing 0 genotypes

# remove loci containing missing values greater than 50%
structure_loci_removed <- missingno(structure_NA, type = "loci", cutoff = 0.5)
# This cannot be done, even though recommended. Otherwise: Removing 6435 loci