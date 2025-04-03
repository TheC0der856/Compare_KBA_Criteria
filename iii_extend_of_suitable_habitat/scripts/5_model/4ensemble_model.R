library(biomod2)
setwd("iii_extend_of_suitable_habitat/")

# load model
file.out <- paste0("Presence/Presence.AllModels.models.out")
if (file.exists(file.out)) {
  myBiomodModelOut <- get(load(file.out))
}


myEnsembleModel <- BIOMOD_EnsembleModeling(
                                  myBiomodModelOut,
                                  models.chosen = "all",
                                  em.by = "all",
                                  em.algo = 'EMca', 
                                  metric.select = "all",
                                  metric.select.thresh = NULL,
                                  metric.select.table = NULL,
                                  metric.select.dataset = NULL,
                                  metric.eval = c("KAPPA", "TSS", "ROC"),
                                  var.import = 0,
                                  EMci.alpha = 0.05,
                                  EMwmean.decay = "proportional",
                                  nb.cpu = 1,
                                  seed.val = 123,
                                  do.progress = TRUE
)

get_built_models(myEnsembleModel)

if (!dir.exists("ensemble_model_results")) {
   dir.create("ensemble_model_results")
}
eval_scores <- get_evaluations(myEnsembleModel)
write.csv(eval_scores, "ensemble_model_results/evaluation.csv", row.names = TRUE)

# bm_PlotEvalMean(bm.out = myEnsembleModel, dataset = 'calibration')
# bm_PlotEvalBoxplot(bm.out = myEnsembleModel, group.by = c('algo', 'algo'))
# # EMca is the best!
