---
author: |
  Christoph Helma^1^, Micha Rautenberg^1^, Denis Gebele^1^
title: |
  nano-lazar: Validation of read across predictions for nanoparticle toxicities
include-before: ^1^ in silico toxicology gmbh,  Basel, Switzerland
keywords: (Q)SAR, read-across, nanoparticle
date: \today
abstract: " "
#documentclass: achemso
#bibliography: references.bibtex
#bibliographystyle: achemso
figPrefix: Figure
eqnPrefix: Equation
tblPrefix: Table
output:
  pdf_document:
    fig_caption: yes
header-includes:
#  - \usepackage{lineno}
#  - \linenumbers
...

Introduction
============

Data requirements
-----------------

Calculation of similarities
  intersection of physchem descriptors

Experimental data for similar compounds

Use cases
---------

- no nanoparticle information: core+coating properties
- physchem measurements
- proteomics


Objectives
----------

- Evaluate currently available nanoparticle data for read across predictions
- Compare read across predictions based on
  - calculated core and coating properties
  - measured nanoparticle properties
  - nanoparticle protein corona

Methods
=======

Results
=======

Data requirements
-----------------

Predictions from core and coating properties
--------------------------------------------

Predictions from physchem properties
------------------------------------

Algorithm                 | $r^2$                                      | RMSE                                  | MAE
-----------------|--------------------------------------------|---------------------------------------|----------------
weighted average | `! cat results/weighted-average.r_squared` | `! cat results/weighted-average.rmse` | `! cat results/weighted-average.mae` 

`! cat results/training-dataset.id`

` ruby results/weighted-average.rb`

![weighted average](results/loo-cv.png "weighted average")

referenzdaten!

pls mit original properties: katastrophal, egal ob -log10 oder nicht

local weighted average, -log10 transformed, no feature selection
rmse: 0.8585810024686744, mae: 0.6785597520657844, r_squared: 0.508897016476696

local pls, -log10 transformed, no feature selection (calls weighted average)
rmse: 0.8992939561572298, mae: 0.7204175044919703, r_squared: 0.6563666334054629

local weighted avarage, -log10 transformed, feature selection

pls with scaled properties

Predictions from proteomics
---------------------------


Discussion
==========

Conclusion
==========
