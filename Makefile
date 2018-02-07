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
hello_world.tex\
plot.tex

hello_world_LISTING_INPUTS :=\
helloworld.py

plot_LISTING_INPUTS :=\
makePlot.m
plot_FIGURE_INPUTS :=\
plot.eps

.SECONDEXPANSION:
.PHONY: all
all: $$(DOCUMENTS)

define document_rule =
$(3): $(1) $$($(2)_LISTING_INPUTS) $$($(4))
DOCUMENTS += $(3)
FIGURE_INPUTS += $$($(4))
endef

$(foreach source,$(SOURCES),\
$(eval\
$(call\
document_rule,$(source),$(basename\
$(source)),$(subst\
_,-,$(basename $(source))).pdf,$(basename\
$(source))_FIGURE_INPUTS)))

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
