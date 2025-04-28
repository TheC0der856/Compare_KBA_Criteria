#load packages
library(biomod2)
library(ggplot2)
library(reshape2)

#load ensemble model
file.out <- paste0("Presence/Presence.AllModels.ensemble.models.out")
if (file.exists(file.out)) {
  myEnsembleModel <- get(load(file.out))
}

response_curves_EMcaByROC_median <- bm_PlotResponseCurves(bm.out = myEnsembleModel, 
                                                          models.chosen = 'Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo',
                                                          fixed.var = 'median')

# create adjusted and more beautiful plot :)
ggdat <- response_curves_EMcaByROC_median$tab
ggdat$expl.name <- factor(ggdat$expl.name, levels = sort(levels(ggdat$expl.name))) # alphabetic order in plot
new.env = get_formal_data(myEnsembleModel, 'expl.var')

show.variables <- unique(ggdat$expl.name)
new.env_m <- melt(new.env[, show.variables], variable.name = "expl.name", value.name = "expl.val")

gg <- ggplot(ggdat, aes(x = .data$expl.val, y = .data$pred.val, color = .data$pred.name)) +
  geom_line(linewidth = 2) +
  geom_rug(data = new.env_m, sides = 'b', inherit.aes = FALSE, aes(x = .data$expl.val)) +
  facet_wrap("expl.name", scales = "free_x") +
  xlab("") +
  ylab("") +
  theme(legend.title = element_blank()
        , legend.key = element_rect(fill = "white")
        , legend.position = "none", 
        strip.text = element_text(size = 20),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 15), 
        axis.text.y = element_text(size = 15))

# save plot
ggsave("response_curves_EMcaByROC_median.pdf", plot = gg, width = 14, height = 8)