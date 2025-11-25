
# preparations:
source("code/preparation/load_libraries.R")                  # load libraries
source("code/preparation/load_genind_with_potentialKBAs.R")  # load data set
rm(list = setdiff(ls(), "genetic_info"))                     # keep only the data set in environment
invisible(sapply(list.files("code/functions", pattern = "\\.R$", full.names = TRUE), source)) # load functions



# calculate best KBA combinations
best_KBA_combinations <- minimize_KBAs(genetic_info      = genetic_info,
                                       ID_limit          = 10,
                                       n_bootstraps      = 50,
                                       threshold_factor  = 0.9,
                                       n_cores           = 3)
# summarize results
summary <- summarize_minimized_KBAs(best_KBA_combinations)


# save results:
write.csv(best_KBA_combinations, "results/test_boots/50/1.csv")
write.csv(summary,               "results/test_boots/50/1summary.csv")
