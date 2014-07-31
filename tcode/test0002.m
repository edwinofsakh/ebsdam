close all;
clear all;

outdir = checkDir('fish','res', 1);
comment = getComment();

sr = 1; % save results
fc = 1; % close figure

cr = 0.4;
w1 = 2;
w2 = 5;
vv = 4;

%% Sel01
ebsd_f = sel01_load();
sname = 'sel01';

sid = 's001'; ebsd = cutEBSD(ebsd_f,40,330,20,20); cr = 0.4; w1 = 2; w2 = 5; vv = 4; % 001
close all; fishParent(ebsd, cr, sid, w1, vv, w2);
%   30.3259 43.3458 2.07254

sid = 's002'; ebsd = cutEBSD(ebsd_f,48,400,20,20); cr = 0.4; w1 = 2; w2 = 5; vv = 4; % 002
close all; fishParent(ebsd, cr, sid, w1, vv, w2);
%   28.0479 44.8591 89.8968

sid = 's003'; ebsd = cutEBSD(ebsd_f,40,80,20,20);  cr = 0.4; w1 = 2; w2 = 5; vv = 4; % 003
close all; fishParent(ebsd, cr, sid, w1, vv, w2);
%	38.2737 52.0489 2.16245

% Not Working! sid = 's004'; ebsd = cutEBSD(ebsd_f,86,220,12,20); cr = 0.0; w1 = 1.5; w2 = 5; vv = 4; % 004

% sname = 'sel01_c';
% ebsd_f = cutEBSD(ebsd_f,30,100,40,350);

% sname = 'sel01_c2';
% ebsd_f = cutEBSD(ebsd_f,0,0,100,50);

%% Sel02
ebsd_f = sel02_load();
sname = 'sel02';

sid = 's011'; ebsd = cutEBSD(ebsd_f,60,150,20,20); cr = 0.1; w1 = 1.5; w2 = 5; vv = 6;% 011
close all; fishParent(ebsd, cr, sid, w1, vv, w2);
%	29.3498 48.8231 6.54324


%% Ses01
ebsd_f = ses01_load();
sname = 'ses01';

sid = 's021'; ebsd = cutEBSD(ebsd_f,40,130,20,20); cr = 0.1; w1 = 2;  w2 = 5; vv = 4; % 021
close all; fishParent(ebsd, cr, sid, w1, vv, w2);
%   50.4491 77.6907 26.4245

% sname = 'ses01_c';
% ebsd_f = cutEBSD(ebsd_f,40,50,40,250);

%%
% fishParent(ebsd, cr, sid, w1, vv, w2);





%%
% CS = symmetry('m-3m');
% SS = symmetry('-1');
% 
% RD = vector3d(0,1,0);
% TD = vector3d(0,0,1);
% ND = vector3d(1,0,0);
% 
% o0 = orientation('matrix',[1 0 0; 0 1 0; 0 0 1],CS,SS);
% 
% r1 = rotation('axis',yvector,'angle',90*degree);
% r2 = rotation('axis',zvector,'angle',90*degree);
% r = rotation('matrix',[0 1 0; 0 0 1; 1 0 0]);
% 
% plot(o0, 'antipodal');
% plotpdf(o0, Mller(1,0,0), 'antipodal');
% 
% o1 = r .* o0;
% o2 = r2*r1.* o0;
% 
% plot([RD TD ND]);
% plot([r*RD r*TD r*ND]);
% 
% plot([r*RD r*TD r*ND]);
% annotate([r*RD,r*TD,r*ND],'label',{'RD','TD','ND'},'BackgroundColor','w');