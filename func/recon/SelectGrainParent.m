function oup = SelectGrainParent( sid, thrd, mgs, ORname )
% Find parent orientation for selected grains and it's neighbors
%   Try to find parent orientation for grains and it's neighbors. Grain 
%   selected on full grains map.
%
% Syntax
%   SelectGrainParent( sid, thrd, mgs, ORname );
%
% Input
%   sid     - sample id
%   thrd    - grains detection threshold in degree
%   mgs     - minimal grains size in point
%   ORname  - name of orientation relationship
%
% History
% 21.04.13  Original impementation

ebsd = checkEBSD(sid, 0, 0);

thr = thrd*degree;
grains = getGrains(ebsd, thr, mgs);

g_fe = grains('Fe');

plot(grains);
p = ginput(1);
g = findByLocation(grains,p);
gi = find(g);

% Mean orientation of grains
o = get(g_fe, 'mean');

% Pairs of grains
[~, pairs] = neighbors(g_fe);

% Get neighbours
neighbour = getNeighbors(gi, pairs);

% Orientation relation
OR = getOR(ORname); % alpha to gamma

Nv = 3;
w0 = 7*degree;
PRm = 1.25;
[Pmax, PR, oup, gind] = findUniqueParent(o([gi; neighbour]), OR, w0, Nv, w0, PRm);
