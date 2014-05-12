# Makefile for Proposal and Dissertation Tex files

# options
#TEX_OPTIONS= -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make
TEX_OPTIONS= -interaction=nonstopmode
BIBTEX_OPTIONS=

# main latex and bibtex compiler
TEX=pdflatex $(TEX_OPTIONS)
BIBTEX=bibtex $(BIBTEX_OPTIONS)

.PHONY: all diss proposal progress_report

diss: diss.pdf 

all: proposal progress_report diss

proposal: proposal.pdf

progress_report: progress_report.pdf

progress_report.tex: progress_report_title.tex

diss.pdf: yield_queue.pdf thread_repr.pdf bind_callback.pdf

%.pdf: %.tex resources.bib
	$(TEX) $<
	$(TEX) $<
	grep '\\cite' < $<; \
	if [[ $$? == 0 ]]; then \
		$(BIBTEX) `(echo $< | sed 's/\..*//';)`; \
	fi 
	$(TEX) $<
	$(TEX) $<

%.pdf: %.svg
	inkscape -A $*.pdf $<

clean:
	rm *.log *.bbl *.fls *.pdf *.aux *.blg *.toc *.lof 2>/dev/null; exit 0
