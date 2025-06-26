# FLR.R - DESC
# FLR.R

# Copyright 2015 Iago Mosqueira. Distributed under the GPL 2.
# Maintainer: Iago Mosqueira, JRC
# Soundtrack:
# Notes:

library(FLa4a)
data(ple4)
data(ple4.index)

fit <- sca(ple4, FLIndices(A=ple4.index))

stk <- ple4 + fit

library(ggplotFL)

# Stock assessment

png(file='graphics/a4a_fit.png')
plot(stk)
dev.off()


# SR

data(nsher)

png(file='graphics/nsher_fit.png')
plot(nsher)
dev.off()

png(file='graphics/nsher_profile.png')
profile(nsher)
dev.off()

AIC(nsher)
BIC(nsher)

# Advice

library(FLash)
library(FLAssess)

psr <- fmle(as.FLSR(ple4, model='ricker'))

# windowFwd

fut <- stf(ple4, 3)

# target

fca <- FLQuant(c(catch(ple4)[,'2008']), dimnames=list(year=2009:2011))                                    

# fwd

fut <- fwd(fut, sr=psr, catch=fca)

png(file='graphics/ple4_fwd.png')
plot(fut) + geom_vline(aes(xintercept=2009), color='darkgrey')
dev.off()

# BRP

library(FLBRP)

prp <- brp(FLBRP(ple4, sr=psr))

refpts(prp)

png(file='graphics/ple4_brp.png')
plot(prp) + xlab("") + ylab("")
dev.off()


# Features


fq <- rnorm(200, FLQuant(rep(0.5, 6)), 25)

png(file='graphics/flq_exp.png')
plot(FLQuant(exp(1:6)))
dev.off()

png(file='graphics/flq_rno.png')
plot(rnorm(200, FLQuant(exp(1:6)), FLQuant(exp(1:6))))
dev.off()

# HPC

library(parallel)

srs <- FLSRs(bevholt=nsher, ricker=nsher)
srs <- mclapply(c('bevholt', 'ricker'), function(x) {
	model(srs[[x]]) <- x
	srs[[x]] <- fmle(srs[[x]])
	return(srs[[x]])
}, mc.cores=2)

names(srs) <- c('bevholt', 'ricker')

lapply(srs, AIC)


library(doMC)

out <- times(4) %do% fwd(fut, sr=psr, catch=fca)
