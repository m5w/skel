function makeReport

h = figure('visible', 'off');
plot(0, 0);
hgexport(h, 'plot.eps');

exit;
end
