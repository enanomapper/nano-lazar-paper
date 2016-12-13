# Paper
nano-lazar.pdf: nano-lazar.md figures/DONE results/cv-summary-table.csv results/cv-statistics.json results/substances-per-endpoint.csv results/p-chem-properties.csv
	pandoc nano-lazar.md --bibliography=references.bibtex --latex-engine=pdflatex -F pandoc-csv2table -F pandoc-crossref -F pandoc-citeproc -o nano-lazar.pdf 

# Tables
results/cv-summary-table.csv: results/validation-summaries.json
	scripts/cv-summary-table.rb

results/p-chem-properties.csv: results/training-datasets.json
	scripts/p-chem-properties.rb

# substances per endpoint
results/substances-per-endpoint.csv: results/training-datasets.json
	scripts/substances-per-endpoint.rb 

# Figures
figures/DONE: results/protein-corona-validation.ids
	scripts/plots.rb && touch figures/DONE

# statistical comparison of crossvalidation results
results/cv-statistics.json: results/validation-summaries.json
	scripts/cv-statistics.rb

# repeated crossvalidations
results/validation-summaries.json: results/protein-corona-validation.ids
	scripts/validation-summaries.rb

results/modena-validation.ids: results/training-datasets.json
	scripts/modena-validations.rb

results/protein-corona-validation.ids: results/training-datasets.json
	scripts/protein-corona-validations.rb

# import enm
results/training-datasets.json: 
	scripts/import.rb 

clean: 
	rm results/*; rm figures/*; mongo development --eval "db.dropDatabase()"
