function [frac, ma, a, aa, div] = fracKOG(grains, epsilon, ORdata, allbnd)
% Calculate fraction of KOG and deviation from KOG
%
% Syntax
%   [frac, ma, a, aa] = fracKOG(grains, epsilon, ORdata);
%
% Output
%   frac  - fraction of KOG
%   ma    - most freguency angle between KOG and misorientations, in degree
%   a     - all angle between KOG and misorientations, in degree
%
% Input
%   grains  - MTEX grains set (use getGrains or calcGrains)
%   epsilon - KOG threshold
%   ORdata  - data for orienarion relationship, specify KOG
%
% History
% 26.10.12  Original implementation.
% 03.12.12  Only 'in epsilon' angle used to find optimal OR.
% 06.12.12  Add 'epsilon' input.
% 07.12.12  New criterion of best OR: mean agel / number of
%           close boundary
% 21.03.13  Only 'external' boundaries are taken into account.
% 15.08.13  Add selection of 'all' and 'ext' boundaries.

% Get all misorientation between grains (it's associate with length fraction)
if allbnd
    mori = calcBoundaryMisorientation(grains);
else
    mori = calcBoundaryMisorientation(grains, 'ext');
end
nmis = length(mori);

% Calculate misorenation between variants of oreintation relation.
[~,~,kog,~] = calcKOG3(ORdata);
% [~,I] = sort(angle(kog)/degree);
% kog = kog(I);
nkog = length(kog);

% Fraction of KOG
frac = zeros(nkog,1);

% Distance from misorientation to KOG (more is closer)
d = zeros(nkog,nmis);

% For each KOG find distance from it to all misorientations
for i = 1:nkog
    [~, d(i,:)] = find(mori, kog(i), epsilon*degree);
end

% % !!! Experimental code
% % For each KOG find close misorientations and plot histogram
% figure;
% for i = 1:nkog
%     ind = d(i,:) > cos(epsilon*degree/2);
%     ang = angle(mori(ind))/degree;
%     
%     [n,xout] = hist(ang,24);
%     
%     subplot(5,5,i)
%     
%     bar(xout-angle(kog(i))/degree,n);
% end
% % !!! Experimental code End

% Find the closest KOG number and respective distance
[dmax,dind] = max(d,[],1);

% Remove misorientations which are farther from KOG than epsilon
dind = (dmax > cos(epsilon*degree/2)).*dind;

% % !!! Experimental code
% % For each KOG find close misorientations and plot histogram
% figure;
% for i = 1:nkog
%     ang = angle(mori(dind == i))/degree;
%     
%     [n,xout] = hist(ang,24);
%     
%     subplot(5,5,i)
%     
%     bar(xout-angle(kog(i))/degree,n);
% end
% % !!! Experimental code End

% Count fraction of KOG
for i = 1:nkog
    c = sum(dind == i);
    frac(i) = c;
end

% Calculate angle between misorientations and the closest KOG, in degree
a = real(2*acos(dmax))/degree;

% Only closest boundary
aa = a((dmax > cos(epsilon*degree/2)));

% Number boundary close to KOG
nn = length(aa);

ma = mean(aa)/nn;

div = sum(aa)/length(aa);

% % Find most frequency value
% nbins = 0:epsilon/32:epsilon;
% [nx, xout] = hist(aa, nbins);
% [mm, ind] = max(nx);
% ma = xout(ind);

% % Find mean value
% maa = mean(aa);
% ma = sum(aa)/length(aa);
% 
% % Find median value
% ma = sum(nx.*xout)/nmis;
