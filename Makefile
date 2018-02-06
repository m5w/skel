SOURCES := hello_world.tex

.SECONDEXPANSION:
.PHONY: all
all: $$(DOCUMENTS)

define document_rule =
$(2): $(1)
DOCUMENTS += $(2)
endef

$(foreach source,$(SOURCES),$(eval $(call document_rule,$(source),$(subst _,-,$(basename $(source))).pdf)))

$(DOCUMENTS):
	pdflatex -jobname $(basename $@) -shell-escape $<

.PHONY: clean
clean:
	@rm -r $(DOCUMENTS:.pdf=.aux) $(DOCUMENTS) $(DOCUMENTS:.pdf=.log) $(addprefix _minted-,$(basename $(DOCUMENTS)))
