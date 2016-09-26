% Validation of read across predictions for nanoparticle toxicities
% Christoph Helma, Micha Rautenberg, Denis Gebele
% in silico toxicology gmbh,  Basel, Switzerland
  \
  \
  \
  ![](images/logo-enm.png "eNanoMapper")

Objectives
==========

- Validate `lazar` read across models for nanoparticles
- Compare regression algorithms
    - Local weighted average
    - Local weighted partial least squares
    - Local weighted random forests
- Compare nanoparticle descriptors
    - Nanoparticle properties (physchem, size, shape, ...)
    - Interaction with human serum proteins
- Provide an example for reproducible research

`lazar` read across framework 
===========================

- Search in a database for similar nanoparticles (*neighbors*)
- Build a local QSAR model with these neighbors
- Use this model to predict the activity of the query compound

Similarity calculation
======================

Relevant features
  : Features that correlate significantly with toxicity (Pearson correlation p-value < 0.05) 

Weighted cosine similarity
  : 
    - Scaled and centered *relevant feature* vectors
    - Feature contributions weighted by Pearson correlation coefficient
    - Similarity threshold: $sim > 0.5$ 

Local regression algorithms
===========================

- Weighted average 
- Weighted partial least squares regression
- Weighted random forests

Partial least squares and random forest models use the `caret` R package with default settings

Prediction intervals: 1.96*RMSE of `caret`s bootstrapped model predictions

If PLS/RF modelling or prediction fails, `lazar` resorts to using the weighted
average method.

Validation
==========

- 3 repeated 10-fold crossvalidations with independent training/test
set splits
- *No* fixed random seed for training/test set splits, to avoid overfitting and to demonstrate the variability of validation results due to random training/test splits.
- Separate feature selection for each training dataset to avoid overfitting 

Data requirements
=================

- At least 100 examples per toxicity endpoint for statistically meaningful validation results
- At least non-empty intersection of descriptors for calculation of similarities

*Net cell association* endpoint of the *Protein corona* dataset (121 gold and silver particles)

10-fold crossvalidations
========================

Descriptors | Algorithm           | $r^2$ | RMSE | 
------------|---------------------|-------|------|--
Physchem | WA | `! scripts/values.rb weighted_average P-CHEM r_squared` | `! scripts/values.rb weighted_average P-CHEM rmse` | 
Physchem | PLS | `! scripts/values.rb pls P-CHEM r_squared` | `! scripts/values.rb pls P-CHEM rmse` |
Physchem |RF | `! scripts/values.rb random_forests P-CHEM r_squared` | `! scripts/values.rb random_forests P-CHEM rmse` |
Proteomics | WA  | `! scripts/values.rb weighted_average Proteomics r_squared` | `! scripts/values.rb weighted_average Proteomics rmse` | 
Proteomics | PLS | `! scripts/values.rb pls Proteomics r_squared` | `! scripts/values.rb pls Proteomics rmse` |
Proteomics | RF |  `! scripts/values.rb random_forests Proteomics r_squared` | `! scripts/values.rb random_forests Proteomics rmse` |
All | WA | `! scripts/values.rb weighted_average all r_squared` | `! scripts/values.rb weighted_average all rmse` 
All | PLS | `! scripts/values.rb pls all r_squared` | `! scripts/values.rb pls all rmse` 
All |RF |  `! scripts/values.rb random_forests all r_squared` | `! scripts/values.rb random_forests all rmse`

Gold *and* silver particles included!

Correlation plot
================

![Correlation of log2 transformed net cell association measurements with random forest predictions using physchem properties and protein corona data.](figures/random_forests-all-crossvalidations.png)

Reproducible research
=====================

- Manuscript (and presentation) including figures and tables are built directly from experimental results
- Custom `pandoc` filter (similar to `knitr` for `R`)
- Simple Makefile (`make clean; make` re-runs all experiments and creates an updated manuscript)

Lazar (source code)
  : <https://github.com/opentox/lazar>

Manuscript (source code)
  : <https://github.com/opentox/nano-lazar-paper>

Docker image
  : <https://hub.docker.com/r/insilicotox/nano-lazar-paper/>

Questions
=========

- More aggressive parameter optimization and feature selection (danger of overfitting a relatively large dataset)
- Mechanistic interpretation of relevant features (nanoparticle properties and proteins)

TODO
====

- Webinar
- Finish and publish paper (journal suggestions?)
- Adjust nano-lazar GUI
