# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

define \n


endef

SHELL := /bin/bash

SOURCES :=\
plot.tex

plot_LISTING_INPUTS :=\
makePlot.m
plot_FIGURE_INPUTS :=\
plot.eps

.SECONDEXPANSION:
.PHONY: all
all: $$(DOCUMENTS)

define document_rule_4
$(4): $(1) $$($(2)_LISTING_INPUTS) $$($(5))
DOCUMENTS += $(4)
FIGURE_INPUTS += $$($(5))
endef

define document_rule_3
$(call\
document_rule_4,$(1),$(2),$(3),$(3:=.pdf),$(2)_FIGURE_INPUTS)
endef

define document_rule_2
$(call\
document_rule_3,$(1),$(2),$(subst _,-,$(1)))
endef

define document_rule_1
$(call\
document_rule_2,$(1),$(basename $(1)))
endef

define document_rule
$(call\
document_rule_1,$(1))
endef

$(foreach source,$(SOURCES),\
$(eval\
$(call\
document_rule,$(source))))

$(DOCUMENTS):
	pdflatex -jobname $(basename $@) -shell-escape $<

.PHONY: printclean
printclean:
	$(foreach document,$(DOCUMENTS),@find\
. -regex './$(basename $(document))\.[1-9][0-9]*\.pdf' -delete$(\n))

.PHONY: print
print: $(DOCUMENTS) printclean
	$(foreach document,$(DOCUMENTS),@for\
((_PageNumber = 1;\
_PageNumber <= $$(gs\
-q -dNODISPLAY -c\
'($(document)) (r) file runpdfbegin pdfpagecount = quit');\
++_PageNumber));\
do\
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPageList="$$_PageNumber"\
-sOutputFile="$(basename $(document)).$$_PageNumber.pdf"\
-q\
$(document);\
done$(\n))

.PHONY: clean
clean: printclean
	@rm -r \
$(FIGURE_INPUTS:.eps=-eps-converted-to.pdf) \
$(DOCUMENTS:.pdf=.aux) \
$(DOCUMENTS) \
$(DOCUMENTS:.pdf=.log) \
$(addprefix _minted-,$(basename $(DOCUMENTS)))
