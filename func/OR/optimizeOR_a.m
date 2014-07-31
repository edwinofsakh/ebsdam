% Перейти на другой образец
% Другие параметры 2


function [phi1m,Phim,phi2m] = optimizeOR_a(grains, OR_name)
global Ggrains DisplayResults;

Ggrains = grains;

OR = getOR(OR_name);

CS = symmetry('m-3m');
SS = symmetry('1');

ORo = orientation('matrix', OR, CS, SS);

[phi1,Phi,phi2] = Euler(ORo,'Bunge');

% phi1 = 119.7074;
% Phi  =   9.5278;
% phi2 =  16.8168;

phi1 = phi1 / degree;
Phi  =  Phi / degree;
phi2 = phi2 / degree;

options = optimset('Display', 'iter-detailed', 'LargeScale', 'off',...
    'Diagnostics', 'on', 'MaxIter', 120);

DisplayResults = 0;

% [phi1m,Phim,phi2m] = fminunc(@myfunc, [phi1,Phi,phi2], options);
[phi1m,Phim,phi2m] = fminsearch(@myfunc, [phi1,Phi,phi2], options);

% s04_t
%   118.9881    8.8094   17.1015 - M1 - 1.85
%   120.8130    9.4374   15.6918 -    - 1.6
%   119.7074    9.5278   16.8168
%   119.7059    9.5269   16.8197 -    - 1.6
%   114.204    10.5294   24.204  - KS
%   121.2326    9.7151   15.6123 - 1.5 degree all from M1
%   120.7074    9.8855   16.8290 - from new sample ak03st

DisplayResults = 1;

myfunc([phi1m,Phim,phi2m])

end

function f = myfunc(x)

global Ggrains DisplayResults;

allbnd = 0;
epsilon = 1.5;


% Get all misorientation between grains (it's associate with length fraction)
if allbnd
    mori = calcBoundaryMisorientation(Ggrains);
else
    mori = calcBoundaryMisorientation(Ggrains, 'ext');
end
nmis = length(mori);

% Calculate misorenation between variants of oreintation relation.
CS = symmetry('m-3m');
SS = symmetry('1');

ORo = rotation('Euler', x(1)*degree, x(2)*degree, x(3)*degree);
ORoa = rotation(CS) * ORo;
kog = inverse(ORoa(1)) * ORoa(2:end);
kog = orientation(kog, CS, CS);

%
[~,I] = sort(angle(kog)/degree);
kog = kog(I);
% ind = [3 5 6 7 8 9 11 13 14 16 17 19 21 23];
% ind = [8 9 11 13 14 16 17 19 21 23];
% kog = kog(ind);

%
nkog = length(kog);

% Fraction of KOG
frac = zeros(nkog,1);

% Distance from misorientation to KOG (more is closer)
d = zeros(nkog,nmis);

% For each KOG find distance from it to all misorientations
for i = 1:nkog
    [~, d(i,:)] = find(mori, kog(i), epsilon*degree);
end

% Find the closest KOG number and respective distance
[dmax,~] = max(d,[],1);

% Calculate angle between misorientations and the closest KOG, in degree
a = real(2*acos(dmax))/degree;

% Only closest boundary
aa = a((dmax > cos(epsilon*degree/2)));

if (DisplayResults == 1)
    figure;
    hist(aa,12);
end

f = sum(aa)/length(aa);

% display(f);
% display(x);
end