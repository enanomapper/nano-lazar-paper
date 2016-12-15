---
author: |
  Christoph Helma^1^, Micha Rautenberg^1^, Denis Gebele^1^
title: |
  nano-lazar: Read across predictions for nanoparticle toxicities with calculated and measured properties
include-before: ^1^ in silico toxicology gmbh,  Basel, Switzerland
keywords: (Q)SAR, read-across, nanoparticle
date: \today
abstract: "The lazar framework for read across predictions was expanded for the prediction of naoparticles, and a new methodology for calculating nanoparticle descriptors from core and coating structures was implemented. In order to compare nanparticle descriptor sets and local regression algorithms 60 independent crossvalidation experiments were performed for the Protein Corona dataset obtained from the eNanoMapper database. The best RMSE and r^2 results were obtained with protein corona descriptors and the weighted random forest algorithm, but its 95% prediction interval is significantly less accurate than models with simpler descriptor sets (measured and calculated nanoparticle properties). The most accurate prediction intervals were obtained with measured nanoparticle properties with RMSE and r^2 valus that show no statistical significant difference (p < 0.05) to the protein corona descriptors. Calculated descriptors are interesting for cheap and fast high-throughput screening purposes, they have significantly lower r^2 values, but RMSE and prediction intervals are comparable to protein corona and nanoparticle moels." 

#documentclass: achemso
bibliography: references.bibtex
bibliographystyle: achemso
figPrefix: Figure
eqnPrefix: Equation
tblPrefix: Table
#subfigGrid: true
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
At present only the *Net cell association* endpoint of the *Protein corona* dataset, has a sufficient number of examples (121) to create and validate read-across models, all other public nanoparticle endpoints have less than 20 examples, which makes them unsuitable for local (Q)SAR modelling and crossvalidation experiments.

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

The *Protein corona dataset* contains 121 Gold and Silver particles that are characterized by physchem properties (*P-CHEM*) and their interaction with proteins in human serum (*Proteomics*). In addition *MP2D* fingerprints were calculated for core and coating compounds with defined chemical structures.

![*P-CHEM* properties of the *Protein corona* dataset. m](results/p-chem-properties.csv){#tbl:p-chem-properties}

Three repeated crossvalidations with independent training/test set splits were performed for the descriptor classes

- *MP2D* fingerprints (calculated, binary)
- *P-CHEM* properties (measured, quantitative)
- *Proteomics* data (measured, quantitative)
- *P-CHEM* and *Proteomics* data combined (measured, quantitative)

and the local regression algorithms

- local weighted average (*WA*)
- local weighted partial least squares regression (*PLS*)
- local weighted random forests (*RF*)

Results of these experiments are summarized in [@tbl:cv_summary]. [@fig:fingerprint], [@fig:pchem] and [@fig:prot] show the correlation of predictions with measurements for *MP2D*, *P-CHEM* and *Proteomics* random forests models. Correlation plots for all descriptors and algorithms are available in the supplementary material, which can be obtained from Github (https://com/enanomapper/nano-lazar-paper) or DockerHub (https://hub.docker.com/r/insilicotox/nano-lazar-paper/).

![Results from five independend crossvalidations for various descriptor/algorithm combinations. Best results are indicated by bold letters, statistically significant ($p<0.05$) poorer results by italics. Results in normal fonts show no significant difference to the best results. m](results/cv-summary-table.csv){#tbl:cv_summary}

<div id="fig:fingerprint">
![](figures/fingerprint-rf-0.pdf){#fig:fingerprint0 width=20%}
![](figures/fingerprint-rf-1.pdf){#fig:fingerprint1 width=20%}
![](figures/fingerprint-rf-2.pdf){#fig:fingerprint2 width=20%}
![](figures/fingerprint-rf-3.pdf){#fig:fingerprint3 width=20%}
![](figures/fingerprint-rf-4.pdf){#fig:fingerprint4 width=20%}

Correlation of predicted vs. measured values for five independent crossvalidations with *MP2D* fingerprint descriptors and local *random forest* models
</div>

<div id="fig:pchem">
![](figures/properties-PCHEM-rf-0.pdf){#fig:pchem0 width=20%}
![](figures/properties-PCHEM-rf-1.pdf){#fig:pchem1 width=20%}
![](figures/properties-PCHEM-rf-2.pdf){#fig:pchem2 width=20%}
![](figures/properties-PCHEM-rf-3.pdf){#fig:pchem3 width=20%}
![](figures/properties-PCHEM-rf-4.pdf){#fig:pchem4 width=20%}

Correlation of predicted vs. measured values for five independent crossvalidations with *P-CHEM* descriptors and local *random forest* models
</div>

<div id="fig:prot">
![](figures/properties-Proteomics-rf-0.pdf){#fig:prot0 width=20%}
![](figures/properties-Proteomics-rf-1.pdf){#fig:prot1 width=20%}
![](figures/properties-Proteomics-rf-2.pdf){#fig:prot2 width=20%}
![](figures/properties-Proteomics-rf-3.pdf){#fig:prot3 width=20%}
![](figures/properties-Proteomics-rf-4.pdf){#fig:prot4 width=20%}

Correlation of predicted vs. measured values for five independent crossvalidations with *Proteomics* descriptors and local *random forest* models
</div>

Discussion
==========

[@tbl:cv_summary] summarizes the results from five independent crossvalidations for all descriptor/algorithm combinations. The best results in terms of $RMSE$ and $R^2$ were obtained with *Proteomics* descriptors and local weighted *random forest* models. There are however six models without statistically significant differences in terms of $RMSE$ and five models in terms of $r^2$. The most accurate 95\% prediction intervals were obtained with *P-CHEM* descriptors and *random forest* models, this models does not differ significantly from the best $RMSE$ and $r^2$ results.


### Descriptors

  In terms of descriptors the best overall results were obtained with *Proteomics* descriptors. This is in agreement with previous findings from other groups [@Walkey14, @Liu15, @georgia]. It is however interesting to note that the prediction intervals are significantly more inaccurate than those from other descriptors and the percentage of measurements within the prediction interval is usually lower than 90\% instead of the expected 95\%.

  Using *P-CHEM* descriptors in addition to *Proteomics* does not lead to improved models, *random forest* results are even significantly worse than with *Proteomics* descriptors alone. 

  *P-CHEM* descriptors alone perform surprisingly well, especially in combination with local *random forest* models, which does not show statistically significant differences to the best *Proteomics* model. On average more than 95\% of the measurements fall within the 95\% prediction interval, with significantly better results than for *Proteomics* descriptors.

  All *MP2D* models have poorer performance in terms of $r^2$, but the *random forest* model does not differ significantly in terms of $RMSE$ and measurements within the prediction interval. 

### Algorithms

  With the exception of *P-CHEM*/*Proteomics* descriptors *random forests* models perform better than *partial least squares* and *weighted average* models with significant differences for *MP2D* and *P-CHEM* descriptors (detailed pairwise comparisons are available in the supplementary material). Interestingly the simple *weighted average* algorithm shows no significant difference to the best performing model for the *Proteomics* and *P-CHEM*/*Proteomics* descriptors.

### Interpretation and practical applicability

Although *random forest* models with *Proteomics* descriptors have the best performance in terms of $RMSE$ and $r^2$, the accuracy of the 95% prediction interval is significantly lower than for *MP2D* and *P-CHEM* models (detailed pairwise comparisons in the supplementary material). It is likely that this instability is caused by a unfavourable ratio between descriptors (TODO) and training examples (121), although feature selection reduces the number of independent descriptors from TODO to TODO and $random forest$ and $partial least squares$ algorithms are robust against a large number of descriptors. The observation that the *weighted average* algorithm, which uses descriptors only for similarity calculations and not for local model building, performs comparatively well for *Proteomics* descriptors, may support this interpretation.

*P-CHEM* *random forest* models have the most accurate prediction interval and the $RMSE$ and $r^2$ performance is comparable to the $Proteomics$ model, although it utilizes a much lower number of descriptors (TODO before feature selection, TODO after feature selection) which have not been measured for the purpose of (Q)SAR modelling. The main advantage from a practical point of view is that predictions of novel nanoparticles require a much lower amount of measurements than with $Proteomics$ data (although this argument may become obsolete with new high throughput techniques).

*MP2D* fingerprint descriptors are interesting from a practical point of view, because they do not require any measurements of nanoparticle properties. They need however defined chemical structures for core and coating compounds, which makes makes this approach infeasible for nanoparticle classes like carbon nanotubes. The resulting models do not differ significantly from the best results in terms of prediction accuracy ($RMSE$, measurements within prediction interval), but are significantly lower in terms of explained model variance ($r^2$). For practical purposes one may argue that the primary objective of read across models is to make accurate predictions and not to explain the model variance. For this reason we consider $r^2$ performance as secondary compared to $RMSE$ and prediction interval accuracies.

Unfortunately our results are not directly comparable to results from other studies , because they use different validation schemes (e.g. bootstrap instead of crossvalidation), exclude part of the training data (silver particles, sometimes also some gold particles) and some of them have serious methodological flaws (e.g. global feature selection before validation splits). Unfortunately none of these publications provides sufficient information to repeat their validation experiments with our models.

relevant features
features used in local models

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

We have performed 60 independent crossvalidation experiments for the Protein Corona dataset obtained from the eNanoMapper database in order to identify the best combination of descriptors for nanoparticle read across predictions. The best RMSE and r^2 results were obtained with protein corona descriptors and the weighted random forest algorithm, but its 95% prediction interval is significantly less accurate than models with simpler descriptor sets (measured and calculated nanoparticle properties). The most accurate prediction intervals were obtained with measured nanoparticle properties with RMSE and r^2 valus that show no statistical significant difference (p < 0.05) to the protein corona descriptors. Calculated descriptors are interesting for cheap and fast high-throughput screening purposes, they have significantly lower r^2 values than the best results, but RMSE and prediction intervals are comparable to the best results. 

For practical purposes we suggest to use nanoparticle properties when measurements are available and the newly developed nanoparticle fingerprints for screening purposes without physicochemical measurements. Both models have been implemented with a graphical user interface which is publicly available at https://nano-lazar.in-silico.ch.

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
