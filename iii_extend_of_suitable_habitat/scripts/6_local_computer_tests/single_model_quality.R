# load package
library(biomod2)
library(ggplot2)

# load single models
file.out <- paste0("Presence/Presence.AllModels.models.out")
if (file.exists(file.out)) {
  myBiomodModelOut <- get(load(file.out))
}

# create a new directory to save the quality files if it does not exist yet
if (!dir.exists("single_model_quality")) {
  dir.create("single_model_quality")
}

# # save evaluation scores
# eval_scores <- get_evaluations(myBiomodModelOut)
# write.csv(eval_scores, "single_model_quality/evaluation.csv", row.names = TRUE)
# # save variable importance
# var_important <- get_variables_importance(myBiomodModelOut)
# write.csv(var_important, "single_model_quality/variable_importance.csv", row.names = TRUE)
# tables to huge to be informative

# Represent evaluation scores
plotmean <- bm_PlotEvalMean(bm.out = myBiomodModelOut)
ggsave("single_model_quality/mean.pdf", plot = plotmean$plot, width = 8, height = 6)
# plotmodel <- bm_PlotEvalBoxplot(bm.out = myBiomodModelOut, group.by = c('algo', 'algo'))
# ggsave("single_model_quality/models.pdf", plot = plotmodel$plot, width = 8, height = 6)
# # plotmodel$plot shows similar information like plotmean$plot
# plotrun <- bm_PlotEvalBoxplot(bm.out = myBiomodModelOut, group.by = c('run', 'run'))
# ggsave("single_model_quality/runs.pdf", plot = plotrun$plot, width = 8, heights = 6)
# # all runs look similar.
# # Since there are no abnormalities there is no adjustment to it and I decided to exclude this information unless requested to not overwhelm the reader.

# # Represent variable importance
# var_important_model <- bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('expl.var', 'algo', 'algo'))
# ggsave("single_model_quality/models_variable_importance.pdf", plot = var_important_model$plot, width = 8, height = 6)
# var_important_run <- bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('expl.var', 'algo', 'run'))
# ggsave("single_model_quality/runs_variable_importance.pdf", plot = var_important_run$plot, width = 8, height = 6)
# # there is to much going on for the results are not easily understood by lookind at these plots
# # they show that fayal-brezal is the most important variable in all models
# # analyses of variable importance will be easier to understand from ensembled model
