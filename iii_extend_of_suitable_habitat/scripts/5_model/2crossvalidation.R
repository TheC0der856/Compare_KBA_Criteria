# # cross validation 
# # this is not necessary if the default options are used by biomod2: will automatically apply the random strategy
# 
# # random selection
# cv.r <- bm_CrossValidation(bm.format = myBiomodData,
#                            strategy = "random",
#                            nb.rep = 5,
#                            perc = 0.7)
#  
# 
# #head(cv.r)
# #summary(myBiomodData, calib.lines= cv.r)
# #plot(myBiomodData, calib.lines = cv.r, plot.type= "raster")
# # apply(cv.r, 2, table)
# 
# 
# # k-fold selection 
# cv.k <- bm_CrossValidation(bm.format = myBiomodData,
#                            strategy = "kfold",
#                            nb.rep = 2,
#                            k = 3)
# 
# #head(cv.k)
# #summary(myBiomodData, calib.lines= cv.k)
# #plot(myBiomodData, calib.lines = cv.k, plot.type= "raster")
# # apply(cv.k, 2, table)