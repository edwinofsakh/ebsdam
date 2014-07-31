for i = 0:4
ebsd_c = cutEBSD(ebsd,i*20,0,(i+1)*20,400);
odf = calcODF(ebsd_c('Fe'),'HALFWIDTH',3*degree);
figure(); plotpdf(odf,[Miller(1,0,0),Miller(1,1,0),Miller(1,1,1)],'antipodal','silent','position',[10 10 600 200]);
end