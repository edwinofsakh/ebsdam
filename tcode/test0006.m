% Test reference frame. Is MTEX use standard OIM notation?
% Answer: yes, MTEX use standard OIM notation RD up-down, TD left-right, ND
% - normal

close all;
clear all;

cs = symmetry('m-3m');
ss = symmetry('-1');

% (110)[11-2]
o1 = orientation('Brass',cs,ss);

figure;
plotipdf(o1, xvector, 'MarkerColor', 'k', 'antipodal');
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
    
figure;
plotipdf(o1, zvector, 'MarkerColor', 'k', 'antipodal');
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');


ebsd = test02_load();

figure;
plot(ebsd, 'antipodal', 'r', xvector);

figure;
plot(ebsd, 'antipodal', 'r', yvector);

figure;
plot(ebsd, 'antipodal', 'r', zvector);
colorbar;

figure;
plotipdf(ebsd, xvector, 'MarkerColor', 'k', 'antipodal');
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
    
figure;
plotipdf(ebsd, zvector, 'MarkerColor', 'k', 'antipodal');
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');

