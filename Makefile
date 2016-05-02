# Variables

# Paper

nano-lazar.pdf: nano-lazar.md references.bibtex
	pandoc --bibliography=references.bibtex --latex-engine=pdflatex --filter ./inline.rb --filter pandoc-crossref --filter pandoc-citeproc -o nano-lazar.pdf 
