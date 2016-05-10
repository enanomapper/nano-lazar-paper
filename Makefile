# Variables

# Paper

#nano-lazar.pdf: nano-lazar.md references.bibtex results/weighted-average.rb
nano-lazar.pdf: nano-lazar.md results/weighted-average.rb
	pandoc nano-lazar.md --filter ./inline.rb -o nano-lazar.pdf 
	#pandoc --bibliography=references.bibtex --latex-engine=pdflatex --filter ./inline.rb --filter pandoc-crossref --filter pandoc-citeproc -o nano-lazar.pdf 

#results

results/weighted-average.rb: results/training-dataset.id
	ruby scripts/weighted-average.rb

# import

results/training-dataset.id: scripts/import.rb
	ruby scripts/import.rb 

clean: 
	rm results/*
