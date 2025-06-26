#
DOC=FLR
OUT=Presentation_FLR

all: $(DOC).md
	pandoc -t beamer -S $(DOC).md -o $(OUT).pdf --template=tex/jrc.beamer

notes: $(DOC).md
	pandoc -t beamer -S -H tex/headerNotes.tex $(DOC).md -o $(DOC)Notes.pdf

tex: $(DOC).md
	pandoc -t beamer -S -H tex/header.tex $(DOC).md -o $(DOC).tex

show: $(DOC).pdf
	pdf-presenter-console -d 12 -l 2 $(DOC).pdf

dual: $(DOC)Notes.pdf
	dspdfviewer $(DOC).pdf

clean:
	rm -f $(DOC).aux $(DOC).log $(DOC).out

cleanall: clean
	rm -f $(DOC).pdf
