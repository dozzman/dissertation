# Makefile for Proposal and Dissertation Tex files

# options
#TEX_OPTIONS= -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make
TEX_OPTIONS= -interaction=nonstopmode
BIBTEX_OPTIONS=
DEPS=proposal_title.tex
PDFS=proposal.pdf #main.pdf

# main latex compiler
TEX=pdflatex $(TEX_OPTIONS)
BIBTEX=bibtex $(BIBTEX_OPTIONS)
.PHONY: all

all: $(PDFS)

%.pdf: %.tex $(DEPS)
	$(TEX) $<;
	# $(BIBTEX) $<;
	$(TEX) $<;
	$(TEX) $<;
