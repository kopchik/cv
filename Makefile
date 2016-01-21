#Makefile for creating pdf document with fonts within it

#version for journal
extmainfile=main
extoutfile=main

#ghostscript command to generate the pdf from the ps file
GS = gs -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sPAPERSIZE=letter -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.4 -dMaxSubsetPct=100 -dSubsetFonts=true -dEmbedAllFonts=true
#dvips command to generate the ps form the dvi
DVIPS = dvips -t Lettersize -D 600 -G0 -Ppdf

#source files
sources:=*.tex

#all targets
all:
	make ext

#ext: extended version for the journal
ext: ${extoutfile}.pdf
	make clean-tmp

${extmainfile}.dvi: ${sources}
	latex ${extmainfile}.tex
	bibtex ${extmainfile}
	latex ${extmainfile}.tex
	latex ${extmainfile}.tex

${extmainfile}.ps: ${extmainfile}.dvi
	$(DVIPS) -o ${extmainfile}.ps ${extmainfile}.dvi

${extoutfile}.pdf: ${extmainfile}.ps
	$(GS) -sOutputFile=${extoutfile}.pdf ${extmainfile}.ps

clean-tmp:
	rm -f *.blg
	rm -f *.log
	rm -f *.aux
	rm -f *.out

clean: clean-tmp
	rm -f *.bbl *.ps *.dvi ${extoutfile}.pdf

view: main.pdf
	evince main.pdf &
