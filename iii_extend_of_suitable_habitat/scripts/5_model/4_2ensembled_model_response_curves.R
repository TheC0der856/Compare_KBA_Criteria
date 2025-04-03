#load packages
library(biomod2)
library(ggplot2)

#load ensemble model
file.out <- paste0("iii_extend_of_suitable_habitat/Presence/Presence.AllModels.ensemble.models.out")
if (file.exists(file.out)) {
  myEnsembleModel <- get(load(file.out))
}

response_curves_EMcaByROC_median <- bm_PlotResponseCurves(bm.out = myEnsembleModel, 
                                                        models.chosen = 'Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo',
                                                        fixed.var = 'median')

response_curves_EMcaByROC_mean <- bm_PlotResponseCurves(bm.out = myEnsembleModel, 
                                                       models.chosen = 'Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo',
                                                       fixed.var = 'mean')

response_curves_EMcaByROC_min <- bm_PlotResponseCurves(bm.out = myEnsembleModel, 
                                                       models.chosen = 'Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo',
                                                       fixed.var = 'min')

response_curves_EMcaByROC_max <- bm_PlotResponseCurves(bm.out = myEnsembleModel, 
                                                       models.chosen = 'Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo',
                                                       fixed.var = 'max')

ggsave("ensemble_model_results/response_curves_EMcaByROC_mean_plot.jpg", plot = response_curves_EMcaByROC_mean$plot, width = 10, height = 8, dpi = 300)
ggsave("ensemble_model_results/response_curves_EMcaByROC_mean_plot.pdf", plot = response_curves_EMcaByROC_mean$plot, width = 10, height = 8)

ggsave("ensemble_model_results/response_curves_EMcaByROC_mean_plot.jpg", plot = response_curves_EMcaByROC_mean$plot, width = 10, height = 8, dpi = 300)
ggsave("ensemble_model_results/response_curves_EMcaByROC_mean_plot.pdf", plot = response_curves_EMcaByROC_mean$plot, width = 10, height = 8)

ggsave("ensemble_model_results/response_curves_EMcaByROC_min_plot.jpg", plot = response_curves_EMcaByROC_min$plot, width = 10, height = 8, dpi = 300)
ggsave("ensemble_model_results/response_curves_EMcaByROC_min_plot.pdf", plot = response_curves_EMcaByROC_min$plot, width = 10, height = 8)

ggsave("ensemble_model_results/response_curves_EMcaByROC_max_plot.jpg", plot = response_curves_EMcaByROC_max$plot, width = 10, height = 8, dpi = 300)
ggsave("ensemble_model_results/response_curves_EMcaByROC_max_plot.pdf", plot = response_curves_EMcaByROC_max$plot, width = 10, height = 8)