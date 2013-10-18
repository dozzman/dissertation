# Makefile for Proposal and Dissertation Tex files

# options
#TEX_OPTIONS= -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make
TEX_OPTIONS= -interaction=nonstopmode
BIBTEX_OPTIONS=
TEX_RES=proposal_title.tex
PDFS=proposal.pdf #main.pdf
BIB_RES=resources.bib

# main latex compiler
TEX=pdflatex $(TEX_OPTIONS)
BIBTEX=bibtex $(BIBTEX_OPTIONS)

.PHONY: all

all: $(PDFS)

%.pdf: %.tex $(TEX_RES) $(BIB_RES)
	$(TEX) $<
	$(TEX) $<
	$(BIBTEX) `(echo $< | sed 's/\..*//';)` 
	$(TEX) $<
	$(TEX) $<
