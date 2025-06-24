#####################################################################
# MSE Course
# Running MSE analysis with the a4a platform (session 05, day01)
# MSE setup, aka 'conditioning'
# 20191114 (EJ)
#####################################################################

#====================================================================
# libraries, code, input data and MSE setup
#====================================================================
rm(list = ls())
library(FLa4a)
library(mse)
library(FLAssess)
library(ggplotFL)
library(FLBRP)
library(doParallel)

#--------------------------------------------------------------------
# data and preprocessing
#--------------------------------------------------------------------
attach("../../../../data/cod.RData")
stk <- stk
idxs <- idxs
detach()

#--------------------------------------------------------------------
# MSE setup
#--------------------------------------------------------------------

it <- 75 # iterations
y0 <- range(stk)["minyear"] # initial OM year
dy <- range(stk)["maxyear"] # final OM year
fy <- dy + 25 # final year
iy <- dy  # initial year of projection (also intermediate)
nsqy <- 3 # number of years to compute status quo metrics
vy <- ac(iy:fy) # vector of years to be projected

#====================================================================
# OM conditioning
#====================================================================

#--------------------------------------------------------------------
# Assessment
#--------------------------------------------------------------------
brn <- 50 # If you dont use mcmc put burn equal zero to avoid mismatch dimension in the matrix later on
mcsave <- 100
mcmc <- mcsave*it

# submodels
qmod <- list(~s(age, k=3), ~s(age, k=3))
fmod <- ~te(age, year, k = c(3, 15)) + s(age, k = 5)
srmod <- ~geomean(CV=0.3)

# mcmc setup object
scamcmc <- SCAMCMC(mcmc = mcmc, mcsave = mcsave, mcprobe = 0.3)

# run
fit <- sca(stk, idxs, fmodel=fmod, qmodel=qmod, srmodel=srmod, fit="MCMC", mcmc = scamcmc)
fit <- burnin(fit, brn)
stk <- stk + fit
plot(stk)

# status quo F
fsq <- mean(fbar(stk)[,ac(dy:(dy-nsqy+1))])

#--------------------------------------------------------------------
# S/R
# use medians to avoid fitting to each iter
#--------------------------------------------------------------------

stk0 <- qapply(stk, iterMedians)
gsr  <- as.FLSR(stk0, model = "bevholt")
gsr <- fmle(gsr)
plot(gsr)

#--------------------------------------------------------------------
# Set residuals for the projections period using residuals sd for
# rlnorm
#--------------------------------------------------------------------
res_gsr <- window(rec(stk), end=fy)
res_gsr <- rlnorm(res_gsr, 0, sd(residuals(gsr)))
residuals(gsr) <- res_gsr

#--------------------------------------------------------------------
# reference points
#--------------------------------------------------------------------
brp_gsr <- brp(FLBRP(stk0, gsr))

#--------------------------------------------------------------------
# extend object for fwd, set up future assumptions - means of nsqy years
#--------------------------------------------------------------------
stk <- stf(stk, fy-dy, nsqy, nsqy)
plot(stk)

#--------------------------------------------------------------------
# build OM object
#--------------------------------------------------------------------
# set projection method for OM
proj <- mseCtrl(method=fwd.om, args=list(maxF=3))
# build object
stk.om <- FLom(stock=stk, sr=gsr, refpts=refpts(brp_gsr), projection=proj)#, fleetBehaviour=fb)

#====================================================================
# OEM
#====================================================================
#--------------------------------------------------------------------
# deviances for indices using q estimated by the model
#--------------------------------------------------------------------
idcs <- FLIndices()
for (i in 1:length(idxs)){
	i.q0 <- predict(fit)$qmodel[[i]]
	i.q <- window(i.q0, end=fy)
	i.q[,ac((iy):fy)] <- i.q[,ac(dy)]
	i.fit <- window(index(fit)[[i]], end=fy) 
	idx_temp <- FLIndex(index=i.fit, index.q=i.q) 
	range(idx_temp)[c("startf", "endf")] <- range(idxs[[i]])[6:7]
	idcs[[i]] <- idx_temp
}
names(idcs) <- names(idxs)

#--------------------------------------------------------------------
# deviances for catches
#--------------------------------------------------------------------

set.seed(0)
# build log residuals
catch.dev <- log(catch.n(stk))
catch.dev <- catch.dev-iterMeans(catch.dev)
# compute varcov for multivariate normal randomization
Sig <- apply(catch.dev[,ac(y0:dy),1,1,,drop=TRUE], 3, function(x) cov(t(x)))
Sig <- apply(Sig, 1, mean)
Sig <- matrix(Sig, ncol=dim(catch.dev)[1])
# randomize
catch.dev[,ac(vy)][] <- t(mvrnorm((it-brn) * length(vy), rep(0, nrow(Sig)), Sig))
# exponentiate for OEM object
catch.dev <- exp(catch.dev)

#--------------------------------------------------------------------
# build OEM object
#--------------------------------------------------------------------

idxDev <- lapply(idcs, index.q)
names(idxDev) <- c("index.q", "index.q")
stkDev <- FLQuants(catch.n=catch.dev)

# deviances
dev <- list(idx=idxDev, stk=stkDev)
# observations
# WARNING: note we're selecting one index only
obs <- list(idx=idcs, stk=stk)

# OEM
oem <- FLoem(method=sampling.oem, observations=obs, deviances=dev)

#====================================================================
# IEM
# not much to say, just assuming our own ignorance ...
#====================================================================
iem <- FLiem(method=noise.iem, args=list(fun="rlnorm", mean=0, sd=0.2, multiplicative=TRUE))

save(stk.om, oem, iem, fy, y0, iy, nsqy, file='mse_setup.RData')

