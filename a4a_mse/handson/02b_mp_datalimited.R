#####################################################################
# MSE Course
# Running MSE analysis with the a4a platform (session 05, day01)
# Data limited MP, length based MP
# 20191114 (EJ)
#####################################################################

#====================================================================
# libraries, code, input data and MSE setup
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
	ctrl.est = mseCtrl(method=length.est, args=list(vbPars=data.frame(linf=110, k=0.1, t0=-0.3))),
	ctrl.phcr = mseCtrl(method=indicator.phcr, args=list(itrg=25)), 
	ctrl.hcr = mseCtrl(method=indicator.hcr),
	ctrl.is = mseCtrl(method=indicator.is, args=list(system='input'))))

#--------------------------------------------------------------------
# register cores for parallel
#--------------------------------------------------------------------
cl <- makeCluster(1)
clusterEvalQ(cl = cl, expr = {library(FLa4a)})
registerDoParallel(cl)

#--------------------------------------------------------------------
# run
#--------------------------------------------------------------------
res.dl <- mp(stk.om, oem, iem, ctrl.mp=ctrl, genArgs=mpargs, tracking="indicator.est")
stopCluster(cl)

#--------------------------------------------------------------------
# visualize
#--------------------------------------------------------------------
plot(stk.om, res.dl)

#--------------------------------------------------------------------
# save results
#--------------------------------------------------------------------
save(res.dl, ctrl, file="datalimited.RData")


