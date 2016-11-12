# Variables
figures = figures/weighted_average-pchem-crossvalidations.pdf figures/weighted_average-proteomics-crossvalidations.pdf figures/weighted_average-all-crossvalidations.pdf figures/pls-pchem-crossvalidations.pdf figures/pls-proteomics-crossvalidations.pdf figures/pls-all-crossvalidations.pdf figures/random_forests-pchem-crossvalidations.pdf figures/random_forests-proteomics-crossvalidations.pdf figures/random_forests-all-crossvalidations.pdf

# Paper
nano-lazar.pdf: nano-lazar.md $(figures) results/cv-comparison.json results/substances-per-endpoint.json
	pandoc nano-lazar.md --bibliography=references.bibtex --latex-engine=pdflatex --filter ./inline.rb --filter pandoc-crossref --filter pandoc-citeproc -o nano-lazar.pdf 

# Presentations
enm-presentation.html: enm-presentation.md results/cv-comparison.json figures/random_forests-all-crossvalidations.png
	pandoc --filter ./inline.rb  -t slidy --css slidy/style.css -s --self-contained -o enm-presentation.html enm-presentation.md 

athens-workshop.html: athens-workshop.md results/cv-comparison.json figures/random_forests-all-crossvalidations.png
	pandoc --filter ./inline.rb  -t slidy --css slidy/style.css -s --self-contained -o athens-workshop.html athens-workshop.md 

opentox-workshop.html: opentox-workshop.md results/cv-comparison.json figures/random_forests-all-crossvalidations.png
	pandoc --filter ./inline.rb  -t slidy --css slidy/style.css -s --self-contained -o opentox-workshop.html opentox-workshop.md 

# Figures
figures/random_forests-all-crossvalidations.png: results/repeated-crossvalidations.json
	ruby scripts/plot.rb random_forests all png

figures/weighted_average-pchem-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb weighted_average P-CHEM

figures/weighted_average-proteomics-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb weighted_average Proteomics

figures/weighted_average-all-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb weighted_average all

figures/pls-pchem-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb pls P-CHEM

figures/pls-proteomics-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb pls Proteomics

figures/pls-all-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb pls all

figures/random_forests-pchem-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb random_forests P-CHEM

figures/random_forests-proteomics-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb random_forests Proteomics

figures/random_forests-all-crossvalidations.pdf: results/repeated-crossvalidations.json
	ruby scripts/plot.rb random_forests all

# statistical comparison of crossvalidation results
results/cv-comparison.json: results/repeated-crossvalidations.json
	ruby scripts/cv-comparison.rb

# repeated crossvalidations
results/repeated-crossvalidations.json: results/training-dataset.id
	ruby scripts/repeated-crossvalidations.rb

# substances per endpoint
results/substances-per-endpoint.json: results/training-dataset.id
	ruby scripts/substances-per-endpoint.rb 

results/prediction-model.ids: results/training-dataset.id
	ruby scripts/repeated-crossvalidations.rb

# import enm
results/training-dataset.id: 
	ruby scripts/import.rb 

clean: 
	rm results/*
