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
bibliography: references.bibtex
bibliographystyle: achemso
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

Read across is a commonly used approach for the risk assessment of chemicals.
Read across procedures are based on the assumption that similar compounds cause
similar biological effects. In order to estimate the activity of a novel
compound a researcher will search for similar compounds with known biological
activities and deduce the activity of the new compound from this data. In order
to make the procedure reproducible, traceable and objective the authors of this
paper have developed a computer program (`lazar`, [@Maunz2013]) that automates
the risk assessment process. The objective of the current study was to extend
`lazar` for the risk assessment of nanomaterials.

The concept of chemical *similarity* is the key idea behind all read across
procedures. But similarity is not an intrinsic property of substances, it can
be defined in different ways and the utility and performance of similarity
measures depends on each specific use case.

*Structural similarity* is most frequently used in the risk assessment of
compounds with a well defined chemical structure. These similarity definitions
are obviously not directly applicable to nanomaterials, because they lack
a well defined structure. It is however relatively straightforward to adapt
other concepts, e.g. similarity in terms of chemical properties or in terms of
biological effects. Compared to structural similarity, which can be calculated
directly from chemical structures, these similarity definitions depend on
actual *measurements*, which makes their estimation more expensive and time
consuming. For this reason we have developed a novel concept of structural
similarity for nanomaterials, which is based on the chemical fingerprints of
core and coating materials.

In order to estimate the utility of these similarity concepts for nanomaterials, we have performed model building and validation experiments for models based on

- structural similarity (based on core and coating fingerprints)
- property similarity (based on measured nanoparticle properties)
- biological similarity (based on the interaction with serum proteins)

and compared the local regression algorithms

- weighted average
- partial least squares
- random forests

In addition we intend to address the important topic of *reproducible research* with this publication. It is in our experience frequently impossible to reproduce computational experiments for a variety of reasons, e.g.

- publications lack important details about algorithms and data
- authors use proprietary software that does not disclose its algorithms
- original software, libraries and operating systems are not available anymore

Our attempt to address these problems is to provide a self contained environment that contains all software and data for the experiments presented in this manuscript. 
It contains also a build system for the manuscript, that 
pulls results and figures directly from validation experiments (similar to the `R knitr` package [@Xie2015]).

The complete self-contained system with the compiled manuscript is publicly available as a `docker` image from 
DockerHub (https://hub.docker.com/r/insilicotox/nano-lazar-paper/).

Source code for the manuscript and validation experiments has been published under a GPL license at Github (https://github.com/opentox/nano-lazar-paper). The `lazar` framework library has been published under the same terms (https://github.com/opentox/lazar).

`nano-lazar` model predictions and validation results are also publicly accessible from a straightforward and free webinterface at https://nano-lazar.in-silico.ch.

Methods
=======

Datasets
--------

Nanoparticle characterisations and toxicities were mirrored from the eNanoMapper database [@Jeliazkova15] via its REST API.

Algorithms
----------

For this study we have adapted the modular lazar (*la*zy *s*tructure *a*ctivity *r*elationships)
read across framework [@Maunz2013] for nanoparticle model development and validation.

lazar was originally developed for small molecules with a defined chemical structure and uses chemical fingerprints for the identification of similar compounds (*neighbors*). Nanoparticles in contrast do not have clearly defined chemical structures, but they can be characterised by their composition (core and coatings), measured properties (e.g. size, shape, physicochemical properties) or the interaction with biological macromolecules. Within nano-lazar we use these properties for the identification of similar nanoparticles (*neighbors*) and as descriptors for local QSAR models.

nano-lazar makes read-across predictions with the following basic workflow: For a given nanoparticle
lazar 

- searches in a database for similar nanoparticles (*neighbors*) with experimental
  toxicity data, 
- builds a local QSAR model with these neighbors and 
- uses this model to predict the activity of the query compound.

This procedure resembles an automated version of *read across* predictions in
toxicology, in machine learning terms it would be classified as a
*k-nearest-neighbor* algorithm.

Apart from this basic workflow nano-lazar is completely modular and allows the
researcher to use arbitrary algorithms for similarity searches and local QSAR
modelling. Within this study we are using and comparing the following algorithms:

### Nanoparticle descriptors

  In order to find similar nanoparticles and to create local QSAR models it is necessary to characterize nanoparticles by descriptors. In this study we are using three types of descriptors:

  - Calculated molecular fingerprints for core and coating compounds (MOLPRINT 2D fingerprints [@Bender04], *MP2D*)
  - Measured nanoparticle properties from the eNanoMapper database (*P-CHEM*)
  - Protein interaction data from the eNanoMapper database (*Proteomics*)

### Feature selection

  Calculated MP2D fingerprints are used without feature selection, as preliminary experiments have shown, that feature selection deteriorates the overall performance of read-across models (which is in agreement with our observations on small molecules).

  Nanoparticle properties in the eNanoMapper database have not been measured for the purpose of read across and QSAR modelling. For this reason the database contains a lot of features that are irrelevant for toxicity. In preliminary experiments we have observed that using all available features for similarity calculations leads to neighbor sets that are unsuitable for local QSAR models, because large numbers of irrelevant features override the impact of features that are indeed relevant for toxicity.

  For this reason we use the lazar concept of *activity specific similarities* [@Maunz2013], by selecting only those features that correlate with a particular toxicity endpoint (Pearson correlation p-value < 0.05), which leads to a set of *relevant features*. This reduced feature set is used for similarity calculations and local QSAR models. 
  For crossvalidation experiments feature selection is repeated separately for each crossvalidation fold, to avoid overfitted models [@????].

### Neighbor identification

  For binary features (MP2D fingerprints) we are using the union of core and coating fingerprints to calculate the Tanimoto/Jaccard index and a similarity threshold of $sim > 0.1$.

  For quantitative features (P-CHEM, Proteomics) we use the reduced set of relevant features to calculate the *weighted cosine similarity* of their scaled and centered relevant feature vectors, where the contribution of each feature is weighted by its Pearson correlation coefficient with the toxicity endpoint. A similarity threshold of $sim > 0.5$ is used for the identification of neighbors for local QSAR models.

  In both cases nanoparticles that are identical to the query particle are eliminated from neighbors to obtain unbiased predictions in the presence of duplicates.

### Local QSAR models and predictions

  For read-across predictions local QSAR models for a query nanoparticle are build with similar nanoparticles (*neighbors*).


  In this investigation we are comparing three local regression algorithms:

  - weighted local average (WA)
  - weighted partial least squares regression (PLS)
  - weighted random forests (RF)

  In all cases neighbor contributions are weighted by their similarity.
  The weighted local average algorithm serves as a simple and fast benchmark algorithm, whereas 
  partial least squares and random forests are known to work well for a variety of QSAR problems. 
  Partial least squares and random forest models use the `caret` R package
  [@Kuhn08].  Models are trained with the default
  `caret` settings, optimizing the number of PLS components or number of variables available for splitting at each RF tree node
   by bootstrap resampling.

  Finally the local model is applied to predict the activity of the query
  nanoparticle. The RMSE of bootstrapped model predictions is used to construct 95\%
  prediction intervals at 1.96*RMSE.
  Prediction intervals are not available for the 
  weighted average algorithm, as it does not use internal validation,

  If PLS/RF modelling or prediction fails, the program resorts to using the weighted
  average method.

### Applicability domain

  The applicability domain of lazar models is determined by the diversity of the
  training data. If no similar compounds are found in the training data (either
  because there are no similar nanoparticles or because similarities cannot be
  determined du to the lack of mesured properties) no predictions will be
  generated. Warnings are also issued, if local QSAR model building or model
  predictions fail and the program has to resort to the weighted average algorithm. 

  The accuracy of local model predictions is indicated by the 95\% prediction
  interval. 

### Validation

  For validation purposes we use results from 3 repeated 10-fold crossvalidations with independent training/test set splits. Feature selection is performed separately for each training dataset to avoid overfitting. For the same reason we do not use a fixed random seed for training/test set splits. This leads to slightly different results for each repeated crossvalidation run, but it allows to estimate the variability of validation results due to random training/test splits.

  In order to identify significant differences between validation results, outcomes (RMSE, $r^2$, correct 95\% prediction interval) are compared by ANOVA analysis, followed by Tukey multiple comparisons of means.

  Please note that recreating validations (e.g. in the Docker image) will not lead to exactly the same results, because crossvalidation folds are created randomly to avoid overfitting for fixed training/test set splits.

### Availability

  Public webinterface: https://nano-lazar.in-silico.ch

  Source code:

  `lazar` framework: https://github.com/opentox/lazar

  `nano-lazar` GUI: https://github.com/enanomapper/nano-lazar

  Manuscript and validation experiments: https://github.com/opentox/nano-lazar-paper

  Docker image with manuscript, validation experiments, `lazar` libraries and third party dependencies: https://hub.docker.com/r/insilicotox/nano-lazar-paper/


Results
=======

The first step step was to determine the toxicity endpoints currently available in the eNanoMapper database that have sufficient data for the creation and validation of read across models. [@tbl:endpoints] summarizes the endpoints and data points that are currently available in eNanoMapper.

![Substances per endpoint. s](results/substances-per-endpoint.csv){#tbl:endpoints-summary}

In order to obtain meaningful and statistically relevant results from crossvalidation experiments we need at least 100 examples per endpoint. In our experience feature selection and local model building frequently fails for smaller datasets (especially within crossvalidation folds) because too few examples are available and crossvalidation results depend more on training/test set splits than on the performance of individual algorithms. This general observation was confirmed by attempts to validate models for the *Cell Viability* endpoint of the MODENA dataset with 41 examples and 4 independent features. In these cases global models may be preferable over local read-across models, but these models will have a narrow applicability domain.

At present only the *Net cell association* endpoint of the *Protein corona* dataset, has a sufficient number of examples to create and validate read-across models. 
It contains 121 Gold and Silver particles that are characterized by physchem properties (*P-CHEM*) and their interaction with proteins in human serum (*Proteomics*). In addition *MP2D* fingerprints were calculated for core and coating compounds with defined chemical structures.

![*P-CHEM* properties of the *Protein corona* dataset. s](results/p-chem-properties.csv){#tbl:p-chem-properties}

Three repeated crossvalidations with independent training/test set splits were performed for the descriptor classes

- *MP2D* fingerprints (calculated, binary)
- *P-CHEM* properties (measured, quantitative)
- *Proteomics* data (measured, quantitative)
- *P-CHEM* and *Proteomics* data combined (measured, quantitative)

and the local regression algorithms

- local weighted average (*WA*)
- local weighted partial least squares regression (*PLS*)
- local weighted random forests (*RF*)

Results of these experiments are summarized in [@tbl:cv-summary]. Figures [@fig:pchem-prot-rf] and [@fig:mp2d-rf] show the correlation of predictions with measurements for the *P-CHEM*/*Proteomics* and *MP2D* random forests models. Correlation plots for all descriptors and algorithms are available in the supplementary material.

![Repeated crossvalidation results. s](results/cv-summary-table.csv){#tbl:cv-summary}

Discussion
==========

p-chem/proteomics rf best performing
mp2d/rf most practical

relevant features
features used in local models

calculated vs measured
practical applicability
prediction interval accuracy

variability of results


Liu paper:

descriptor selection not included in cv!!
prediction accuracy != r^2
uses bootstrap and strange r^2 which includes training set performance

all papers: no silver particles

georgia:

why only 84 gold particles (neutrals excluded)
text could be clearer
unterschied 10cv, 10cv-test
is this clustering supervised or unsupervised

mixture of regulatory, (nano)tox and machine learning/stat aspects
conceptional overview of BIO descriptors before formal definition
statistically significant differences of results (?)
liu study overfitted!! (discussion)
references, figures sometimes incorrect
VIP comes from lui? => choosing preselected proteins == overfitting

which contains TODO Gold and Silver particles that are characterized by physchem properties and their interaction with proteins in human serum. For this dataset we have found TODO (NTUA abstract?) reference studies [@Walkey14, @Liu15].

TODO: literature search

https://scholar.google.com/scholar?q=protein+corona+nanoparticles+qsar&btnG=&hl=en&as_sdt=0%2C5&as_vis=1

TODO: description of parameters

Conclusion
==========

Acknowledgements
================

This work was performed as part of the EU FP7 project "Nanomaterials safety assessment: Ontology,
database(s) for modelling and risk assessment
Development of an integrated multi-scale modelling
environment for nanomaterials and systems by design" (Theme NMP.2013.1.3-2 NMP.2013.1.4-1, Grant agreement no: 604134).

References
==========

McDermott et al., 2013; Walkey et al., 2014
Yang et al., 2012; Balbin et al., 2013
