SHELL := /bin/bash

SOURCES := hello_world.tex

.SECONDEXPANSION:
.PHONY: all
all: $$(DOCUMENTS)

define document_rule =
$(2): $(1)
DOCUMENTS += $(2)
endef

$(foreach source,$(SOURCES),\
$(eval\
$(call document_rule,$(source),$(subst _,-,$(basename $(source))).pdf)))

$(DOCUMENTS):
	pdflatex -jobname $(basename $@) -shell-escape $<

.PHONY: printclean
printclean:
	$(foreach document,$(DOCUMENTS),\
@find . -regex './$(basename $(document))\.[1-9][0-9]*\.pdf' -delete;)

.PHONY: print
print: $(DOCUMENTS) printclean
	$(foreach document,$(DOCUMENTS),\
for ((_PageNumber = 1; _PageNumber <= $$(\
gs -q -dNODISPLAY -c\
'($(document)) (r) file runpdfbegin pdfpagecount = quit'); ++_PageNumber));\
do\
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite\
-dPageList="$$_PageNumber"\
-sOutputFile="$(basename $(document)).$$_PageNumber.pdf" -q;\
done)

.PHONY: clean
clean: printclean
	@rm -r \
$(DOCUMENTS:.pdf=.aux) \
$(DOCUMENTS) \
$(DOCUMENTS:.pdf=.log) \
$(addprefix _minted-,$(basename $(DOCUMENTS)))
