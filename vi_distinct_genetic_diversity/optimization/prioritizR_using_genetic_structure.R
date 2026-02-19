# install.packages("prioritizr")
# install.packages("sf")         # spatial data
# install.packages("terra")      # rasters
# install.packages("Rsymphony")  # solver for the optimization problem

library(prioritizr)
library(sf)
library(terra)
library(Rsymphony)
library(dplyr)

# set seed for reproducibility
set.seed(500)

# load planning unit data
planning_unit <- st_read("C:/Users/Gronefeld/Desktop/Compare_metrics/Calculations/combine_criteria/define_potential_KBAs/potential_KBAs_including_area_size.shp")

# load genetic data
structure         <- st_read("C:/Users/Gronefeld/Desktop/Compare_metrics/Calculations/assess_genetic_data/3_Structure/structure_pie_charts.shp") # load structure data
structure         <- structure[complete.cases(st_drop_geometry(structure)[, c("Cluster1","Cluster2","Cluster3","Cluster4")]),]                   # remove row with NA
structure$cost    <- 1                                                                                                                           # cost is necessary for the optimization with prioritizr, but not for KBAs, so we assume that all areas would cost the same, so only the genetic structure will be evaluated
# we cannot include EDplus in our optimization problem, because the solver assumes linear data (genetic diversity is not linear increasing with adding new areas and EDplus is neither)
#EDplus            <- read.csv("C:/Users/Gronefeld/Desktop/Compare_metrics/Calculations/vi_distinct_genetic_diversity/KBAs_seen_isolated.csv")    # load Delta+ diversity and distinctiveness index
#EDplus$cost       <- 1 - EDplus$expected_Dplus                                                                                                   # costs are here related to low genetic diversity measured with Delta+ and not to economic interests, which are ignored in KBAs
#genetic_data      <- structure %>% left_join(EDplus, by = c("name" = "Population"))                                                              # combine both information in one dataframe


# formulate optimization problem
p <- problem(
  structure,
  features = c("Cluster1","Cluster2","Cluster3","Cluster4"),
  cost = "cost"
) %>%
  add_min_set_objective() %>%
  add_relative_targets(0.2) %>%   # 20% of each genetic cluster
  add_binary_decisions() %>%
  add_default_solver()

# find and illustrate solution
s1 <- solve(p)
s1$name[s1$solution_1 == 1]
plot(st_geometry(s1[s1$solution_1 == 1, ]),
     col = "red")

# If we use an established program to find the most suitable areas for protection
# and if we optimize for including et least 20% of each genetic structure
# we receive a result which is acceptable, but not good (two areas are very similar: Aguamansa & Lagunetas).
# It is better to maximize genetic diversity.
# Using prioritizR is easy and fast, 
# but if genetic Structure is calculated as a precondition to use prioritizR
# maximizing EDplus will need a similar amount of time. 
# There might be also better ways of maximizing EDplus, that I don't know about (I am not a mathematician, they may now)
