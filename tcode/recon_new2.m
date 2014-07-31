function [ gf, opp ] = recon_new2( g_fe, ORname, thr, Nv, PRm, w0, w1)
%Reconstructe austenite grains
%   Reconstructe austenite grains useing method from:
%       'L.Germain. An advanced approach to reconstructing parent 
%       orientation maps in the case of approximate orientation relations: 
%       Application to steels'
%
% Syntax
%   [ g_au ] = recon_new2( grains_fe, ORname, Nv, w0, PRmin, w1)
% 
% Outputs
%   g_au- grains of prior Austenite phase
%
% Inputs
%   g_fe- grains of Ferrit phase
%   ORn - name of orientation relation
%   Nv  - minimal number of variants
%   w0  - variant misorientation angle limit
%   PRm - minimal PR
%   w1  - ???
%
% See also
%   findFragments
%
% History
% 01.04.13  Find error in 'getOR', it's return matrix from alpha to gamma.

% Mean orientation of grains
o = get(g_fe, 'mean');

% Pairs of grains
[~, pairs] = neighbors(g_fe);

% % Misorientation between grains
% m = getMis (o, pairs);

% Number of grains
n = numel(g_fe);

% % Number of pairs
% n2 = length(pairs);

% In which fragment is grains
inFragment = cell(1,n);

% Orientation relation
OR = getOR (ORname); % alpha to gamma

% Link together grains with close orientation ( < thr). Grains may not 
% detected as one because not adjacent or have more misoreintation angle on
% boundary
mis = angle(o\o);
GL = (mis < thr) - eye(n);

PP = [];
GG = zeros(n,n);
opp = cell(1,n);

% For each grains
for i = 1:n
    fprintf(1,'%d-', i);
    
    % Get neighbours
    neighbour = getNeighbors(i, pairs);
    
    % Domains orientations
    did = [i; neighbour];
%     Gd = domainMatrix(GG, did);
%     od = findUniqueDomains(o(did),did,Gd.*GL);
    od = o(did);
    
    if i == 51
        test = 1;
    end
    % Try to find unique parent
    [suc, Pmax, PR, oup, gind] = findUniqueParent(od, OR, thr, Nv, w0, PRm);
	PP = cat(1,PP,[Pmax,PR]);
    opp{i} = oup;
            
    if (suc)
        inFragment{i} = did(gind)';
    else
        inFragment{i} = 0;
    end
end

ind = cellfun(@(x) all(x == 0) , inFragment);
gf = inFragment{~ind};
opp = opp(~ind);

% n = length(gf);
% while i < n
%     for j = i+1:n
%         if (angle(opp{i},oup{j}))
%         end
%     end
% end
gg = [];
for i=1:n
    gg = [gg inFragment{i}];
end

gg = unique(gg);
gg = gg(2:end);

g_au = g_fe(gg);
end

function [inFragment1] = findFragment(o, i, neighbour, inFragment0)
%findFragment 
%
v = getVariants(o, OR, Sym);
o0 = o(i);
oi = o(neighbour);

end


function Gd = domainMatrix(GG, did)
G1 = GG;
G2 = GG;
G1(:,did) = 1;
G2(did,:) = 1;
Gd = G1.*G2;
end

function od = findUniqueDomains(o,did,GC)

% Grains with close orientation
[rows,cols] = find(tril(GC));

cl = [rows,cols];
for i = 1:size(cl,1)
    
end
end
    
%% Old Code

% % Number of misorientations between OR variants with misorientation angle 
% % less then w0. Allways there is one misorientation V1/V1. 
% ORr = rotation('matrix', OR);
% af = angle(orientation(inverse(ORr)*(CS*ORr),CS,CS));
% mv = sum(af < w0);