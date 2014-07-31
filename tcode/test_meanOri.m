a  = opp1([1 2 3]);
b  = opp1([1 2]);
a1 = mean(opp1([1 2 3]));
b1 = mean(opp1([1 2]));
c = mean([b1 opp1(3)]);

plotpdf(a ,Miller(1,0,0),'antipodal','MarkerSize', 4); hold on;
plotpdf(b ,Miller(1,0,0),'antipodal','MarkerSize', 4); hold on;
plotpdf(a1,Miller(1,0,0),'antipodal','MarkerSize', 4); hold on;
plotpdf(b1,Miller(1,0,0),'antipodal','MarkerSize', 4); hold on;
plotpdf(c ,Miller(1,0,0),'antipodal','MarkerSize', 4); hold off;