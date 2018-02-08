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

SHELL := /bin/bash -o pipefail

SOURCES :=\
plot.tex

plot_SOURCES :=\
makePlot.m
plot_EPS_SOURCES :=\
plot.eps

.SECONDEXPANSION:
.PHONY: all
all: $$(OUTPUTS)

define output_rule_5
$(4): $(1) $$($(2)_SOURCES) $$($(5))
	pdflatex -jobname $(3) -shell-escape $(1)

OUTPUTS += $(4)
EPS_SOURCES += $$($(5))
endef

define output_rule_4
$(call\
output_rule_5,$(1),$(2),$(3),$(4),$(2)_EPS_SOURCES)
endef

define output_rule_3
$(call\
output_rule_4,$(1),$(2),$(3),$(3:=.pdf))
endef

define output_rule_2
$(call\
output_rule_3,$(1),$(2),$(subst _,-,$(1)))
endef

define output_rule_1
$(call\
output_rule_2,$(1),$(basename $(1)))
endef

define output_rule
$(call\
output_rule_1,$(1))
endef

$(foreach source,$(SOURCES),\
$(eval\
$(call\
output_rule,$(source))))

.PHONY: printclean
printclean:
	$(foreach output,$(OUTPUTS),@find\
. -regex './$(basename $(output))\.[1-9][0-9]*\.pdf' -delete$(\n))

.PHONY: print
print: $(OUTPUTS) printclean
	$(foreach output,$(OUTPUTS),@for\
((_PageNumber = 1;\
_PageNumber <= $$(gs\
-q -dNODISPLAY -c\
'($(output)) (r) file runpdfbegin pdfpagecount = quit');\
++_PageNumber));\
do\
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPageList="$$_PageNumber"\
-sOutputFile="$(basename $(output)).$$_PageNumber.pdf"\
-q\
$(output);\
done$(\n))

.PHONY: clean
clean: printclean
	@rm -r \
$(EPS_SOURCES:.eps=-eps-converted-to.pdf) \
$(OUTPUTS:.pdf=.aux) \
$(OUTPUTS) \
$(OUTPUTS:.pdf=.log) \
$(addprefix _minted-,$(basename $(OUTPUTS)))
