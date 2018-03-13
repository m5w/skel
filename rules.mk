plot.eps: makeReport.m
	matlab -nodisplay -nosplash -nodesktop -r makeReport

RULES_OUTPUTS +=\
plot.eps
