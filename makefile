.DEFAULT_GOAL := pdf

# Name of the exported PDF
PDF_NAME ?= Wiki-but-pdf-$(pdfDate).pdf
PDF_NAME_ROOT = Wiki-but-pdf-

# PDF template location
pdfTemplate ?= ./source/pdf_build/eisvogel.latex
pandocMeta = ./source/pdf_build/build_meta.yaml
codeStyle ?= tango

mdFile = ./source/pdf_build/.tmp.md
pdfFile = ./source/static/$(PDF_NAME)
buildFlags = --template $(pdfTemplate)\
	--metadata-file $(pandocMeta)\
	--highlight-style=$(codeStyle)\
	--metadata date=$(pdfDate)

page_break = echo \\\\newpage >> $(mdFile)
separator = echo \\n\\n---\\n >> $(mdFile)
pdfDate = "`date '+%Y-%m-%d'`"
perlAddDate = "s|\]\((./source/static/)($(PDF_NAME_ROOT)).*(.pdf)\)|\]\(\1\2\-$(pdfDate)\3\)|g"

define trim_links
	perl -i -pe 's|\]\((?!http).*([^)]+(#.*))\)|](\2)|g' $(mdFile)		# this is for trimming page paths
	perl -i -pe 's|\.(\./source/images/)|\1|g' $(mdFile) 				# this is for trimming image paths
endef

define create_file
	cat ./Home.md > $(mdFile)
	$(separator)
	$(page_break)
endef

define append_file
	cat $(1) >> $(mdFile)
endef

define make_md
	$(create_file)
	$(call append_file,"./pages/new-page.md")
	$(separator)
	$(page_break)
	$(call append_file,"./pages/another-new-page.md")
	$(separator)
	
	$(trim_links)
endef

define make_pandoc
	pandoc -f markdown $(mdFile) -o $(pdfFile) $(buildFlags)
endef

# Shows this help screen
help:
	@ echo
	@ echo '  Usage:'
	@ echo ''
	@ echo '    make <command>'
	@ echo '    (Defaults to "make pdf")'
	@ echo ''
	@ echo '  Targets:'
	@ echo ''
	@ awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?:/{ print "   ", $$1, comment }' $(MAKEFILE_LIST) | column -t -s ':' | sort
	@ echo ''
	@ echo '  Flags:'
	@ echo ''
	@ awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?\?=/{ print "   ", $$1, $$2, comment }' $(MAKEFILE_LIST) | column -t -s '?=' | sort
	@ echo ''

# install prereqs
install-dependencies:
	@ chmod +x ./prereqs.sh
	@ ./prereqs.sh

# Builds the main markdown file
build:
	@ $(make_md)

# covert from md to pdf
convert:
	@ $(make_pandoc)

# builds the main markdown file and converts it to pdf
pdf:
	@ $(make_md)
	@ $(make_pandoc)
	@ perl -i -pe $(perlAddDate) ./Wiki-Export.md
