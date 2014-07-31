function [ gf, opp ] = findFragments2( o,c, grp, pairs, ORmat, thr, Nv, PRm, w0, w1)
% Find fragments with onw parent in ferrite grains map
%   Reconstructe austenite grains useing method from:
%       'L.Germain. An advanced approach to reconstructing parent 
%       orientation maps in the case of approximate orientation relations: 
%       Application to steels'
%
% Syntax
%   [ gf, opp ] = findFragments( g_fe, ORmat, thr, Nv, PRm, w0, w1)
% 
% Output
%   g_au    - grains of prior Austenite phase
%
% Input
%   g_fe    - grains of Ferrit phase
%   ORmat	- orientation relation matrix (from alpha to gamma)
%   Nv      - minimal number of variants
%   w0      - variant misorientation angle limit
%   PRm     - minimal PR
%   w1      - ???
%
% History
% 01.04.13  Find error in 'getOR', it's return matrix from alpha to gamma.
% 15.04.13  Separate from 'recon_new2' for saveing fragments map.
% 17.04.13  Change 'ORname' to 'ORmat'.

% Number of domains
n = numel(o);

% In which fragment is domain
inFragment = cell(1,n);

% Probability and orientation of best fitting parent
PP = [];
opp = cell(1,n);

% For each grains
h = waitbar(0,'Find fragments...');
for i = 1:n
    dprintf(1,'%d-', i);
    
    % Get neighbours
    neighbour = getGroupNeighbors(i, grp, pairs);
    
    % Domains orientations
    did = [i neighbour];
    od = o(did);
    
    % Try to find unique parent
    [suc, Pmax, PR, oup, gind] = findUniqueParent(od, ORmat, thr, Nv, w0, PRm);
	PP = cat(1,PP,[Pmax,PR]);
    opp{i} = oup;
            
    if (suc)
        inFragment{i} = did(gind);
    else
        inFragment{i} = 0;
    end
    waitbar(i/n);
end
close(h)

% Select filled fragment
ind = cellfun(@(x) all(x == 0) , inFragment);
gf = inFragment(~ind);
opp = opp(~ind);

end
