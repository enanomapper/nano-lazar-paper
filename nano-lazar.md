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

Physchem properties
-------------------

Algorithm        | $r^2$                                      | RMSE                        
-----------------|--------------------------------------------|---------------------------------------
Weighted average | `! scripts/values.rb weighted_average P-CHEM r_squared` | `! scripts/values.rb weighted_average P-CHEM rmse` 
Partial least squares | `! scripts/values.rb pls P-CHEM r_squared` | `! scripts/values.rb pls P-CHEM rmse` 
Random forest | `! scripts/values.rb random_forests P-CHEM r_squared` | `! scripts/values.rb random_forests P-CHEM rmse` 

: Repeated crossvalidation results for models with physchem properties, $**$ best results of all experiments, $*$ no statistically significant difference to best results ($p > 0.05$)

![Correlation of log2 transformed net cell association measurements with weighted average predictions using physchem properties.](figures/weighted_average-pchem-crossvalidations.pdf){#fig:wa-pchem}

![Correlation of log2 transformed net cell association measurements with partial least squares predictions using physchem properties.](figures/pls-pchem-crossvalidations.pdf){#fig:pls-pchem}

![Correlation of log2 transformed net cell association measurements with random forest predictions using physchem properties.](figures/random_forests-pchem-crossvalidations.pdf){#fig:rf-pchem}


Protein corona
--------------

Algorithm        | $r^2$                                      | RMSE                        
-----------------|--------------------------------------------|---------------------------------------
Weighted average | `! scripts/values.rb weighted_average Proteomics r_squared` | `! scripts/values.rb weighted_average Proteomics rmse` 
Partial least squares | `! scripts/values.rb pls Proteomics r_squared` | `! scripts/values.rb pls Proteomics rmse` 
Random forest | `! scripts/values.rb random_forests Proteomics r_squared` | `! scripts/values.rb random_forests Proteomics rmse` 

: Repeated crossvalidation results for models with protein corona data, $**$ best results of all experiments, $*$ no statistically significant difference to best results ($p > 0.05$)

![Correlation of log2 transformed net cell association measurements with weighted average predictions using protein corona data.](figures/weighted_average-proteomics-crossvalidations.pdf){#fig:wa-prot}

![Correlation of log2 transformed net cell association measurements with partial least squares predictions using protein corona data.](figures/pls-proteomics-crossvalidations.pdf){#fig:pls-prot}

![Correlation of log2 transformed net cell association measurements with random forest predictions using protein corona data.](figures/random_forests-proteomics-crossvalidations.pdf){#fig:rf-prot}


Physchem properties and protein corona
--------------------------------------

Algorithm        | $r^2$                                      | RMSE                        
-----------------|--------------------------------------------|---------------------------------------
Weighted average | `! scripts/values.rb weighted_average all r_squared` | `! scripts/values.rb weighted_average all rmse` 
Partial least squares | `! scripts/values.rb pls all r_squared` | `! scripts/values.rb pls all rmse` 
Random forest | **`! scripts/values.rb random_forests all r_squared`** | `! scripts/values.rb random_forests all rmse` 

: Repeated crossvalidation results for models with physchem properties and protein corona data, $**$ best results of all experiments, $*$ no statistically significant difference to best results ($p > 0.05$)

![Correlation of log2 transformed net cell association measurements with weighted average predictions using physchem properties and protein corona data.](figures/weighted_average-all-crossvalidations.pdf){#fig:wa-all}

![Correlation of log2 transformed net cell association measurements with partial least squares predictions using physchem properties and protein corona data.](figures/pls-all-crossvalidations.pdf){#fig:pls-all}

![Correlation of log2 transformed net cell association measurements with random forest predictions using physchem properties and protein corona data.](figures/random_forests-all-crossvalidations.pdf){#fig:rf-all}

Discussion
==========

Liu paper:

descriptor selection not included in cv!!
prediction accuracy != r^2
uses bootstrap and strange r^2 which includes training set performance

all papers: no silver particles

Conclusion
==========
