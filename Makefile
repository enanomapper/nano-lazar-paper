# Paper
nano-lazar.pdf: nano-lazar.md references.bib figures/DONE results/cv-summary-table.csv results/cv-statistics.json results/p-chem-properties.csv 
	pandoc nano-lazar.md --bibliography=references.bib --latex-engine=pdflatex -F pandoc-csv2table -F pandoc-crossref -F pandoc-citeproc -o nano-lazar.pdf 

# Tables
results/cv-summary-table.csv: results/validation-summaries.json
	scripts/cv-summary-table.rb

results/p-chem-properties.csv: results/training-datasets.json
	scripts/p-chem-properties.rb

# Figures
figures/DONE: results/protein-corona-validation.ids
	scripts/plots.rb && touch figures/DONE

# statistical comparison of crossvalidation results
results/cv-statistics.json: results/validation-summaries.json
	scripts/cv-statistics.rb

# repeated crossvalidations
results/validation-summaries.json: results/protein-corona-validation.ids
	scripts/validation-summaries.rb

results/protein-corona-validation.ids: results/training-datasets.json
	scripts/protein-corona-validations.rb

# import enm
results/training-datasets.json: 
	scripts/import.rb 

clean: 
	rm results/*; rm figures/*; mongo development --eval "db.dropDatabase()"
