#====================================================================
# EJ (20250623)
# Introduction to MSE concepts - manual demonstration of MSE
#====================================================================

#====================================================================
# load libraries and data and set up run
#====================================================================
library(FLa4a)
library(FLasher)
library(FLBRP)
load("data.RData")

# set up
ny <- 5
its <- 25
rng <- range(stk)
af <- 1 # advice frequency
frefpt <- "f0.1"

#====================================================================
# OM conditioning based on stock assessment
# Uncertainty is introduced by MCMC fitting process
# Uncertainty is propagated through the SR model into reference points
#====================================================================
fit <- sca(stk, idx, srmodel=~s(year, k=15), fit="MCMC", mc=SCAMCMC())
plot(stk+fit)
om <- iter(stk+fit, sample(1:100, its))
om.sr <- fmle(as.FLSR(om, model="bevholt"), control = list(trace = 0))
om.brp <- brp(FLBRP(om, sr=om.sr))

#====================================================================
# Management procedure
#====================================================================

#--------------------------------------------------------------------
# Year 1, providing advice for year 2, data up to previous year (1-1)
#--------------------------------------------------------------------

ay <- rng["maxyear"]
py <- ay + af

# OEM
# Observation model generates data up to year 1-1
# No uncertainty in catch or index
# Index is based on a constant catcability over ages of 0.01
idx <- FLIndex(index=window(stock.n(om), end=ac(ay-1))*0.01)
range(idx)[c("startf","endf")]<- c(0,0)
stk <- window(om, end=ac(ay-1))

# MP
# Estimator is sca with FLa4a
fmod <- ~s(age, k=3) + s(year, k=20)
estimator <- sca(stk, idx, fmodel=fmod, fit="MP")
stk0 <- stk + estimator
# beverton and holt stock recruitment is fitted every year
sr0 <- fmle(as.FLSR(stk0, model="bevholt"), control = list(trace = 0))
# HCR is f0.1 as target, also estimated every year
ftrg <- refpts(brp(FLBRP(stk0, sr0)))[frefpt, "harvest"]
# Projects for 2 years
yrs <- c(ay:py)
ctrl <- fwdControl(list(year=yrs, value=ftrg, quant="fbar"))
stk_fwd <- fwdWindow(stk0, end=py)
stk_fwd <- fwd(stk_fwd, control=ctrl, sr=sr0)
# catch advice is based on the projected catch if the target is applied
catch_advice <- catch(stk_fwd)[,ac(py)]

# IEM
# No implementation model

#--------------------------------------------------------------------
# Year 2, providing advice for year 3, data up to previous year (2-1)
#--------------------------------------------------------------------

ay <- ay + 1
py <- ay + af

# Update OM with previous decision
ctrl <- fwdControl(list(year=ay, value=catch_advice, quant="catch"))
om <- fwdWindow(om, end=ay)
om <- fwd(om, control=ctrl, sr=om.sr)

# OEM
idx <- FLIndex(index=window(stock.n(om), end=ac(ay-1))*0.01)
range(idx)[c("startf","endf")]<- c(0,0)
stk <- window(om, end=ac(ay-1))

# MP
fmod <- ~s(age, k=3) + s(year, k=20)
estimator <- sca(stk, idx, fmodel=fmod, fit="MP")
stk0 <- stk2 <- stk + estimator
sr0 <- fmle(as.FLSR(stk0, model="bevholt"), control = list(trace = 0))
ftrg <- refpts(brp(FLBRP(stk0, sr0)))[frefpt, "harvest"]
yrs <- c(ay:py)
ctrl <- fwdControl(list(year=yrs, value=ftrg, quant="fbar"))
stk_fwd <- fwdWindow(stk0, end=py)
stk_fwd <- fwd(stk_fwd, control=ctrl, sr=sr0)
catch_advice <- catch(stk_fwd)[,ac(py)]

# IEM

#--------------------------------------------------------------------
# Year 3, providing advice for year 4, data up to previous year (3-1)
#--------------------------------------------------------------------

ay <- ay + 1
py <- ay + af

# Update OM with previous decision
ctrl <- fwdControl(list(year=ay, value=catch_advice, quant="catch"))
om <- fwdWindow(om, end=ay)
om <- fwd(om, control=ctrl, sr=om.sr)

# OEM
idx <- FLIndex(index=window(stock.n(om), end=ac(ay-1))*0.01)
range(idx)[c("startf","endf")]<- c(0,0)
stk <- window(om, end=ac(ay-1))

# MP
fmod <- ~s(age, k=3) + s(year, k=21)
estimator <- sca(stk, idx, fmodel=fmod, fit="MP")
stk0 <- stk3 <- stk + estimator
sr0 <- fmle(as.FLSR(stk0, model="bevholt"), control = list(trace = 0))
ftrg <- refpts(brp(FLBRP(stk0, sr0)))[frefpt, "harvest"]
yrs <- c(ay:py)
ctrl <- fwdControl(list(year=yrs, value=ftrg, quant="fbar"))
stk_fwd <- fwdWindow(stk0, end=py)
stk_fwd <- fwd(stk_fwd, control=ctrl, sr=sr0)
catch_advice <- catch(stk_fwd)[,ac(py)]

# IEM

#--------------------------------------------------------------------
# Year 4, providing advice for year 5, data up to previous year (4-1)
#--------------------------------------------------------------------

ay <- ay + 1
py <- ay + af

# Update OM with previous decision
ctrl <- fwdControl(list(year=ay, value=catch_advice, quant="catch"))
om <- fwdWindow(om, end=ay)
om <- fwd(om, control=ctrl, sr=om.sr)

# OEM
idx <- FLIndex(index=window(stock.n(om), end=ac(ay-1))*0.01)
range(idx)[c("startf","endf")]<- c(0,0)
stk <- window(om, end=ac(ay-1))

# MP
fmod <- ~s(age, k=3) + s(year, k=21)
estimator <- sca(stk, idx, fmodel=fmod, fit="MP")
stk0 <- stk4 <- stk + estimator
sr0 <- fmle(as.FLSR(stk0, model="bevholt"), control = list(trace = 0))
ftrg <- refpts(brp(FLBRP(stk0, sr0)))[frefpt, "harvest"]
yrs <- c(ay:py)
ctrl <- fwdControl(list(year=yrs, value=ftrg, quant="fbar"))
stk_fwd <- fwdWindow(stk0, end=py)
stk_fwd <- fwd(stk_fwd, control=ctrl, sr=sr0)
catch_advice <- catch(stk_fwd)[,ac(py)]

# IEM

#--------------------------------------------------------------------
# Year 5
#--------------------------------------------------------------------

ay <- ay + 1
py <- ay + af

# Update OM with previous decision
ctrl <- fwdControl(list(year=ay, value=catch_advice, quant="catch"))
om <- fwdWindow(om, end=ay)
om <- fwd(om, control=ctrl, sr=om.sr)

#====================================================================
# Analysis of results
#====================================================================

#--------------------------------------------------------------------
# kobe is your friend
#--------------------------------------------------------------------
# ssb and F relative to MSY reference points
ssb_ssbmsy <- ssb(om)/refpts(om.brp)["msy", "ssb"]
f_fmsy <- fbar(om)/refpts(om.brp)["msy", "harvest"]

ssb_ssbmsy <- window(iterMedians(ssb(om)/refpts(om.brp)["msy", "ssb"]), start=2020)
f_fmsy <- window(iterMedians(fbar(om)/refpts(om.brp)["msy", "harvest"]), start=2020)

# code to compute kobe plot
ggplot(mapping=aes(y=c(f_fmsy), x=c(ssb_ssbmsy))) +
  # Add quadrants
  geom_rect(aes(xmin = 1, xmax = Inf, ymin = 0, ymax = 1), fill = "green", alpha = 0.5) +
  geom_rect(aes(xmin = 0, xmax = 1, ymin = 0, ymax = 1), fill = "yellow", alpha = 0.5) +
  geom_rect(aes(xmin = 0, xmax = 1, ymin = 1, ymax = Inf), fill = "red", alpha = 0.5) +
  geom_rect(aes(xmin = 1, xmax = Inf, ymin = 1, ymax = Inf), fill = "yellow", alpha = 0.5) +
  # Reference lines
  geom_vline(xintercept = 1, linetype = "dashed") +
  geom_hline(yintercept = 1, linetype = "dashed") +
  # Points
  geom_point(size = 2) +
  # lines
  geom_path(arrow = arrow(type = "open", length = unit(0.15, "inches")), linewidth = 0.5) +
  # Labels and theme
  labs(
    x = expression(B / B[MSY]),
    y = expression(F / F[MSY]),
  ) +
  theme_minimal()

