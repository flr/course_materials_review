---
title: The FLR Project for Quantitative Fisheries Science
author: I. Mosqueira, E. Jardim, F. Scott - EC JRC IPSC G03
date: JRC - UW Meeting. 11 June 2015
rights:  Creative Commons Share Alike 4.0
---

# FLR, Fisheries Library in R

> A collection of packages in the R statistical language providing a domain-specific programming language for quantitative fisheries science.

\centering\includegraphics[width=0.90\textwidth]{graphics/flr_pkgs.png}

# Goals

1. Provide the tools for effective and reliable implementation of simulation models of the fishery system.

2. Encourage the use of Management Strategy Evaluation for designing robust fisheries management plans.

3. Facilitate the exchange of ideas and algorithms through the establishment of a *lingua franca* for quantitative fisheries science.

4. To do so under the Free/Open Source ethos of transparency, reproducibility and free exchange of ideas and algorithms.


# Computational platform

\centering
\includegraphics[width=0.30\textwidth]{graphics/r_logo.png}
\vfill
\includegraphics[width=0.30\textwidth]{graphics/using_cpp.png}
\hfill
\includegraphics[width=0.30\textwidth]{graphics/cppad_logo.png}
\hfill
\includegraphics[width=0.30\textwidth]{graphics/admb_logo.png}

# Philosophy

\centering
\hfill
\includegraphics[width=0.20\textwidth]{graphics/gpl_logo.png}
\hfill
\includegraphics[width=0.40\textwidth]{graphics/eupl_logo.png}
\hfill
\vfill
\includegraphics[width=0.20\textwidth]{graphics/cc_logo.png}

# Features: Design

- Designed around the fisheries system elements & processes

\centering\includegraphics[width=0.55\textwidth]{graphics/mse_drawing.jpeg}

# Features: the R way

- R powerful and clear syntax

```{.r}
rec ~ a * ssb * exp(-b * ssb)
```

- Reuse R methods

```{.r}
summary, plot, [, predict, rnorm, apply, window, ...
```

<!--
# Features: stochasticity

- Objects and methods fully aware of variability

```{.r}
> rnorm(200, FLQuant(rep(0.5, 3)), 25)

An object of class "FLQuant"
iters:  200
, , unit = unique, season = all, area = unique
      year
age   1              2              3            
  all -1.68739(23.1) 0.23650(22.5)  1.69216(24.0)

units:  NA 

```
-->

# Features: stochasticity

- Objects and methods fully aware of variability

```{.r}
plot(flq)
```
\centering
\includegraphics[width=0.4\textwidth]{graphics/flq_exp.png}
\includegraphics[width=0.4\textwidth]{graphics/flq_rno.png}


<!--
# Features: data I/O

```{.r}
# From file
read.table("catch.len", skip=5)

# From legacy formats
readVPAFile("ple4.caa")

# From web
nao.orig <- read.table("http://www.cdc.noaa.gov/nao.data",
	skip=1, nrow=62, na.strings="-99.90")

# From DB
con <- dbConnect(drv, dbname="tempdb")
rs <- dbSendQuery(con,"select * from TableName")
```
-->

<!--
# Features: Parallelization

```{.r}
# Fit two SR in parallel
srs <- mclapply(c('bevholt', 'ricker'), function(x) {
	model(srs[[x]]) <- x
	srs[[x]] <- fmle(srs[[x]])
	return(srs[[x]])
}, mc.cores=2)

# Compare AIC
> lapply(srs, AIC)
bevholt  ricker 
 -20.40  -27.7
```
-->

# Features: High Performance Computing

\centering\includegraphics[width=0.40\textwidth]{graphics/cluster.png}
\hfill
\centering\includegraphics[width=0.40\textwidth]{graphics/ganglia.png}

<!--
# Features: High Performance Computing
```{.r}
# Backend
library(doMC)
library(doMPI)
library(doRedis)

# Frontend
out <- times(8) %do% fwd(fut, sr=psr, catch=fca)
```
-->

# Features: Reproducible Research
```
---
title: R and markdown
author: FLR Team, EC JRC G03
---

# Results
This shows the results

	```{.r}
	plot(ple4)
	```
which looks good.
```

# Features: Reproducible Research

\centering\includegraphics[width=0.70\textwidth]{graphics/rmd.png}

# Features: interactive visualization

<https://iphc.shinyapps.io/MSAB/>

\centering\includegraphics[width=0.80\textwidth]{graphics/iphc_shiny.png}

# A flight over FLR

\centering\includegraphics[width=0.90\textwidth]{graphics/flr_pass.png}

# Stock assessment

```{.r}
# LOAD pkg & data
> library(FLa4a)
> data(ple4)
> data(ple4.index)

# RUN basic a4a SCAA
> fit <- sca(ple4, ple4.index)

# UPDATE stock
> stk <- ple4 + fit
```

# Stock assessment

```{.r}
> plot(stk)
```
\centering\includegraphics[width=0.55\textwidth]{graphics/a4a_fit.png}

<!--
# SR
```{.r}
> data(nsher)
> model(nsher)

rec ~ a * ssb * exp(-b * ssb)

> params(nsher)
An object of class "FLPar"
params
         a          b 
1.1939e+02 9.4511e-03 
units:  NA 
```
-->

<!--
# SR
```{.r}
> model(nsher) <- ricker

> nsher <- fmle(nsher)

  Nelder-Mead direct search function minimizer
  [...]
HI-REDUCTION      65 -12.200179 -12.200179
Exiting from Nelder Mead minimizer
    67 function evaluations used
```
-->

# SR
```{.r}
> plot(nsher)
```
\centering\includegraphics[width=0.50\textwidth]{graphics/nsher_fit.png}

# SR
```{.r}
> profile(nsher)
```
\centering\includegraphics[width=0.55\textwidth]{graphics/nsher_profile.png}

# Advice

```{.r}
# Assume future biology
> fut <- stf(ple4, 3)

# Constant catch
> fca <- FLQuant(c(catch(ple4)[,'2008']),
  dimnames=list(year=2009:2011))                                    

# Project
> fut <- fwd(fut, sr=psr, catch=fca)
```

# Advice

<!--
```{.r}
> plot(fut) + geom_vline(aes(xintercept=2009))
```
-->

\centering\includegraphics[width=0.55\textwidth]{graphics/ple4_fwd.png}

<!--
# BRP

```{.r}
# BRP for ple4 and its SR
> prp <- brp(FLBRP(ple4, sr=psr))

# Reference Points
> refpts(prp)

An object of class "FLPar"
        quantity
refpt    harvest    yield      ssb       
  msy    2.9073e-01 9.4691e+04 4.4930e+05
  crash  7.8888e-01 2.1098e-06 4.9400e-06
  f0.1   8.7602e-02 5.5622e+04 8.0045e+05
  fmax   1.3538e-01 7.3551e+04 6.9910e+05
```
-->

# BRP

```{.r}
plot(prp)
```
\centering\includegraphics[width=0.55\textwidth]{graphics/ple4_brp.png}


# MSE

- IOTC albacore MPs
- Evaluation EU CFP MAPs
- ICCAT MSEs
- MED
- AUS Northern prawn

<!--
# 

\centering\includegraphics[width=0.90\textwidth]{graphics/keep_calm.png}
-->

# IOTC albacore

\centering\includegraphics[width=0.60\textwidth]{graphics/albom.png}

# IOTC albacore

\centering\includegraphics[width=0.60\textwidth]{graphics/R1e.png}

# IOTC albacore

\centering\includegraphics[width=0.60\textwidth]{graphics/skj05.png}

# Evaluation of catch-only methods

FAO Fisheries and Aquaculture Circular. No. 1086

Rosenberg et al. 2014. *Developing new approaches to global stock status assessment and fishery production potential of the seas*

\centering\includegraphics[width=0.30\textwidth]{graphics/fao_sim.png}

# Teaching

- Course *FLR and a4a for Quantitative Fisheries Science*

- Four days

- Jan 2013, Apr, Aug 2014, Aug 2015

- 65 participants, 14 countries

\vfill
\centering\includegraphics[width=0.40\textwidth]{graphics/course.png}

# FLR & a4a for Quantitative Fisheries Science

- INTRODUCTION to R and FLR

- Non-linear model FITTING

- Biomass dynamics STOCK ASSESMENT

- Statistical Catch-at-age MODELS

- Short and medium term FORECAST

- MANAGEMENT STRATEGY EVALUATION

- REPRODUCIBLE research

- High Performance COMPUTING

# Usage

- 34 articles use or extend it
- 202 articles cite Kell *et al.* 2007.
- 8 RFMOs, 26 WGs
- ICES WGs
- STECF EWGs

# Development

\centering\includegraphics[width=0.80\textwidth]{graphics/flr_map.png}

# To know more

\centering\includegraphics[width=0.80\textwidth]{graphics/flr_web.png}

# Getting help

\centering\includegraphics[width=0.80\textwidth]{graphics/flr_list.png}

# Source code

\centering\includegraphics[width=0.80\textwidth]{graphics/flr_github.png}

# Bugs, ideas, complaints

\centering\includegraphics[width=0.80\textwidth]{graphics/flcore_issues.png}

# 
\centering

\includegraphics[width=0.20\textwidth]{graphics/flr_logo.png}

\scriptsize

\url{http://flr-project.org/}

*flr-team@flr-project.org*

\vfill

\includegraphics[width=0.20\textwidth]{tex/header.png}

\scriptsize

Iago MOSQUEIRA, Ernesto JARDIM, Finlay SCOTT

EC JRC, IPSC Maritime Affairs G03, Ispra (IT)

*iago.mosqueira@jrc.ec.europa.eu*
