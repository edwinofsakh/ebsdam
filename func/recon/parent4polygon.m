function [ op, lineXY ] = parent4polygon( sid, thrd, mgs, ORmat, lineXY, saveres, itr )
% Find parent orientation for selected polygon
%   Try to find one parent orientation for polygon selected on full EBSD
%   map. Plot all child orientation.
%
% Syntax
%   [ op, lineXY ] = parent4polygon( sid, thrd, mgs, ORname, lineXY, saveres, itr )
%
% Output
%   ***     - ***
%
% Input
%   sid     - sample id
%   thrd    - grains detection threshold in degree
%   mgs     - minimal grains size in point
%   ORmat   - matrix of orientation relationship (getOR(ORname), alpha to gamma)
%   lineXY  - polygon coordinates
%   saveres - save result to disk
%   itr     - current iteration
%
% History
% 12.04.13  ***


%% Reconstruction settings

% Parameters of austenite reconstruction
Nv  = 4;
PRm = 0;
w0d  = 6;
w1d  = 5;
epsd = 60;

% Convert to radian
thr = thrd*degree;
w0 = w0d*degree;
w1 = w1d*degree;

% Prepare for saving results
OutDir = checkDir(sid, 'grains', saveres);
comment = getComment();
prefix = [sid 's_0_prn_'];

%% Load EBSD
% Load EBSD data
[ ebsd_cut, lineXY ] = selectEBSD( sid, 0, 0, lineXY, saveres, prefix);

%% Detect grains
% % Calc MGS in point
% mgs = fix(mgsum/getCellArea(ebsd));

grains = getGrains(ebsd_cut('fe'), thr,mgs);
grains_fe = grains('Fe');

if (size(ORmat) == 1)
    [best_OR, x,f, ma1, ma2] = optimizeOR( sid, 0, ebsd_cut, grains_fe, saveres, thrd, mgs, epsd);
    ORmat = getOR(best_OR);
end

% ng = size(grains_fe,1);
% [~, pairs] = neighbors(grains_fe);

o0 = get(grains_fe,'mean');

figure;
plot(grains);

% figure;
oo = get(ebsd_cut('Fe'),'orientations');
% plotAllOrientations(oo);

figure;
plotpdf(o0,Miller(1,0,0),'antipodal','MarkerSize',3);
% saveimg(saveres,1,OutDir,prefix, 'ori', 'png', comment);


%% Orientation relation
% ORmat = getOR (ORname); % alpha to gamma

[Pmax, PR, oup, gind] = findUniqueParent(o0, ORmat, w1, Nv, w0, PRm);

Pmax
PR

if (1 || oup ~= 0)
    hold on; plotpdf(oup,Miller(1,0,0),'antipodal','MarkerSize',2, 'MarkerColor','r');
    v = getVariants(oup, inv(ORmat), get(oup,'CS'));
    hold on; plotpdf(v,Miller(1,0,0),'antipodal','MarkerSize',2, 'MarkerColor','g');
    hold off;
    saveimg(saveres,1,OutDir,prefix, 'prn', 'png', comment);
    op = oup;
    
    OR_v = op .\ o0;
    
    v = getVariants(oup, matrix(mean(OR_v)), get(oup,'CS'));
    
    angle(mean(OR_v), orientation('matrix', inv(ORmat), get(oup,'CS'),get(oup,'CS')))/degree
    aaaa = angle(oo\v)/degree;
    bbb = min(aaaa,[],2);
    ccc = sum(bbb)
    mean(OR_v)
    
    figure;
    hold on; plotpdf(oup,Miller(1,0,0),'antipodal','MarkerSize',2, 'MarkerColor','r');
    hold on; plotpdf(v,Miller(1,0,0),'antipodal','MarkerSize',2, 'MarkerColor','g');
    hold off;
    saveimg(saveres,1,OutDir,prefix, 'OR', 'png', comment);
    
    if itr < 3
        [ op, lineXY ] = parent4polygon( 'sel01', 2, 1, matrix(mean(OR_v)), lineXY, 0, itr + 1 );
    end
else
	op = [];
end

end

function e = sumMis(oo, ov)

n = length(ov);

od = oo\ov;

% For each KOG find distance from it to all misorientations
for i = 1:nkog
    [~, d(i,:)] = find(mori, kog(i), epsilon*degree);
end

end
