# Variables

# Paper

#nano-lazar.pdf: nano-lazar.md references.bibtex results/weighted-average.rb
nano-lazar.pdf: nano-lazar.md results/weighted-average.r_squared results/weighted-average.rmse results/weighted-average.mae
	pandoc nano-lazar.md --latex-engine=pdflatex --filter ./inline.rb -o nano-lazar.pdf 
	#pandoc --bibliography=references.bibtex --latex-engine=pdflatex --filter ./inline.rb --filter pandoc-crossref --filter pandoc-citeproc -o nano-lazar.pdf 

# figures

#results/weighted-average.r_squared results/weighted-average.rmse results/weighted-average.mae: results/weighted-average-repeated-crossvalidation.id

results/weighted-average.r_squared: results/weighted-average-repeated-crossvalidation.id
	ruby scripts/repeated-cv.rb weighted-average

results/weighted-average-repeated-crossvalidation.id: results/training-dataset.id
	ruby scripts/weighted-average.rb

# import

results/training-dataset.id: scripts/import.rb
	ruby scripts/import.rb 

clean: 
	rm results/*
