#####################################################################
# MSE Course
# Running MSE analysis with the a4a platform (session 05, day01)
# Data rich MP, full feedback
# 20191114 (EJ)
#####################################################################

#====================================================================
# libraries, code and input data
#====================================================================
library(FLa4a)
library(mse)
library(FLAssess)
library(ggplotFL)
library(FLBRP)
library(doParallel)
load("mse_setup.RData")

#====================================================================
# MP
#====================================================================
#--------------------------------------------------------------------
# generic arguments to be passed to the MP
#--------------------------------------------------------------------

mpargs <- list(fy=fy, y0=y0, iy=iy, nsqy=nsqy, seed = 1234)

#--------------------------------------------------------------------
# control file
#--------------------------------------------------------------------
ctrl <- mpCtrl(list(
	ctrl.est = mseCtrl(method=sca.sa),
	ctrl.phcr = mseCtrl(method=movingF.phcr, args=list(interval=5, frp='msy')),
	ctrl.hcr = mseCtrl(method=movingF.hcr),
	ctrl.is = mseCtrl(method=tac.is)))

#--------------------------------------------------------------------
# register cores for parallel
#--------------------------------------------------------------------
cl <- makeCluster(3)
clusterEvalQ(cl = cl, expr = {library(FLa4a)})
registerDoParallel(cl)

#--------------------------------------------------------------------
# run
#--------------------------------------------------------------------
res.dr <- mp(stk.om, oem, iem, ctrl.mp=ctrl, genArgs=mpargs)
stopCluster(cl)

#--------------------------------------------------------------------
# visualize
#--------------------------------------------------------------------
plot(stk.om, res.dr)

#--------------------------------------------------------------------
# save results
#--------------------------------------------------------------------
save(ctrl, res.dr, file="datarich.RData")

