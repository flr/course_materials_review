---
title: "The FLR platform"
author: "Ernesto Jardim (ernesto.jardim@wur.nl)"
email: "ernesto.jardim@wur.nl"
institute: "Wageningen Marine Research"
fontsize: 12pt
output:
  wmrkdown::wur:
    slide_level: 1
tags:
---

# Why, oh why?

Schnute *et al.* (2007 and 1998) compared the number of software tools
and languages currently available for stock assessments with the Babel
tower myth and concluded that: "The cosmic plan for **confounding
software languages** seems to be working remarkably well among the
community of quantitative fishery scientists!"

# A brief history of FLR

- Started by FEMS FP5, COMMIT & EFIMAS FP6
- Beta ICES WG Methods 2004
- FLCore version 1.0 - 2005
- FLCore version 1.4 *The Golden Jackal* - 2007
\hfill\includegraphics[keepaspectratio, height=0.2\textheight]{graphics/WolfGoldenJackal.jpg}
- FLCore version 2.2 *Swordfish Polka* - 2010
\hfill\includegraphics[keepaspectratio, height=0.2\textheight]{graphics/flr20.png}
- FLR 2.4 *The Duke of Prawns* - 2011
\hfill\includegraphics[keepaspectratio, height=0.2\textheight]{graphics/flr24.png}

#

\centering
\includegraphics[keepaspectratio, height=0.85\textheight]{graphics/flr30.png}

# Current

\centering
FLR 2.6 - *Black Swan*

\bigskip

\includegraphics[keepaspectratio, height=0.4\textheight]{graphics/flr26c.png}

# FLR development

- Collaborative development
- Informal team
- Indirect funding
- Open Source

# GNU project (http://gnu.org)

\centering

*Free software is a matter of liberty, not price*

\medskip

\Huge{free = free speech}

\medskip

\Huge{free != free beer}

# Mission statement

The FLR project provides a **platform for quantitative fisheries
science** based on the R statistical language. The guiding principles of
FLR are:

- **openness** - through community involvement and the open source ethos
- **flexibility** - through a design that does not constrain the user to a given paradigm
- **extendibility** - through the provision of tools that are ready to be personalized and adapted.

# Really, what is FLR?

- Extendable toolbox for implementing bio-economic simulation models of fishery systems
- Tools used by managers (hopefully) as well as scientists
- With many applications including:
    - Fit stock-recruitment relationships,
    - Model fleet dynamics (including economics),
    - Simulate and evaluate management procedures and HCRs,
    - More than just stock assessment (VPA, XSA, ICES uptake)
- A software platform for quantitative fisheries science
- A collection of R packages
- A team of devoted developers
- A community of active users

# Design principles

- OOP - S4
- Classes: elements in system
    - `FLStock`, fish stock
		- `FLBRP` inputs for BRP calc
- Methods: link objects
- Mid-steepenes learning curve

# Packages

\centering
\includegraphics[keepaspectratio, width=0.6\textwidth]{graphics/flrpackages.png}

# MSE - The Lego block approach

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/MSE.png}

# More information

- [FLR Project @ http://flr-project.org](http://flr-project.org)
- [Source code @ http://github.com/flr/](http://gtihub.com/flr/)

#

\centering
\includegraphics[keepaspectratio, height=0.8\textheight]{graphics/keep-calm-and-keep-coding.png}

