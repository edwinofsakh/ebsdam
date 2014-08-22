function [ frg_info ] = findFragments( grains, ORmat, thr, Nv, PRm, w0, varargin)
% Find fragments with onw parent in ferrite grains map
%   Reconstructe austenite grains useing method from:
%       'L.Germain. An advanced approach to reconstructing parent 
%       orientation maps in the case of approximate orientation relations: 
%       Application to steels'
%
% Syntax
%   [ frg, frg_po, grn_frg, grn_po ] = findFragments( o, pairs, ORmat, thr, Nv, PRm, w0, w1)
% 
% Output
%   frg_info - information about fragments:
%       frg     - index of grains in fragments
%       frg_po  - parent orientation of fragments
%       grn_frg - index of fragments for all grains
%       grn_po  - possible parent orientation of grains
%
% Input
%   o       - orientations
%   pairs   - links between orientations
%   ORmat	- orientation relation matrix (from alpha to gamma)
%   thr     - grains detection threshold
%   Nv      - minimal number of variants
%   PRm     - minimal PR
%   w0      - variant misorientation angle limit
%
% Options
%   'neighborsOrder'- add second order neighbours
%   'combineClose'  - combine close orientation in one group
%   'useWeightFunc' - use weight function
%   'onlyFirst'     - check variant only for first child
%
% History
% 01.04.13  Find error in 'getOR', it's return matrix from alpha to gamma.
% 15.04.13  Separate from 'recon_new2' for saveing fragments map.
% 17.04.13  Change 'ORname' to 'ORmat'.
% 16.05.13  Add to output data possible parent orientation of grains.
% 23.07.14  Replace 'o' and 'pairs' input parameters to 'grains'.
% 28.07.14  Add 'varargin'. Add option 'secondRound'.
% 01.08.14  Rewrite 'getNeighbours'. Small refactoring.

%% Preparation
% Mean orientation, its numbers and pairs of grains
[~,pairs] = neighbors(grains);
wf = grainSize(grains);
o = get(grains, 'mean');
n = numel(o);

% Init
k       = 1;            % Number of last fragment
frg     = cell(1,n);    % Indices of grains in fragments
frg_po  = cell(1,n);    % Parent orientation for fragments
grn_frg = cell(1,n);    % Indices of fragments for grains
grn_po  = cell(1,n);    % Posssible parent orientation for grains
frg_info = {frg, frg_po, grn_frg, grn_po};


%% Calculation
% For each grains
h = waitbar(0,'Find fragments...');
for i = 1:n
    % Find indices of neighbors
    ind1 = getNeighbors(i, pairs, varargin{:});
    ind = [i; ind1];
    
    % Orientations for checking
    oi = o(ind);
    wfi = wf(ind);

    debugInfo01(grains, ind, oi);

    % Try to find orientation of unique parent.
    [Pmax, PR, oup, indi, ~, vn] = findUniqueParent(oi, wfi, ORmat, thr, Nv, w0, PRm, varargin{:});
    
    if (isa(oup, 'orientation'))
        
        debugInfo02(oup, ORmat);
        
        % Fill fragment info
        frg_info = fillFrgInfo(frg_info, k, ind(indi)', oup);
        
        % Next fragment
        k = k+1;
    end
    waitbar(i/n);
end
close(h);

% Remove extra values
[frg, frg_po, grn_frg, grn_po] = excractFragmentInfo(frg_info);
frg = frg(1:k-1);
frg_po = [frg_po{1:k-1}];

frg_info = {frg, frg_po, grn_frg, grn_po};

end


function [frg_info1] = fillFrgInfo(frg_info, k, ind, oup)
% Fill fragments information

[frg, frg_po, grn_frg, grn_po] = excractFragmentInfo(frg_info);

% Fill fragment info: indicies of grains, unique parent orientation
frg{k} = ind;
frg_po{k} = oup;

% For each grains add fragment index and parent orientation
for j = ind
    if isempty(grn_po{j})
        grn_po{j} = oup;
        grn_frg{j} = k;
    else
        grn_po{j} = [grn_po{j} oup];
        grn_frg{j} = [grn_frg{j} k];
    end
end

frg_info1 = {frg, frg_po, grn_frg, grn_po};
end


%% Debug functions
function debugInfo01(grains, i, ind, oi)

dprintf(1,'%d-', i);
    
% Plot original orientation and select grains
if (isfulldebug)
    % Plot original orientations
    hf1 = figure;
    plotpdf(oi,Miller(1,0,0), 'antipodal', 'MarkerSize',4);

    hf2 = figure;
    plotBoundary(grains);
    hold on; plot(grains(ind));
    hold off;

    pause(1);
    close(hf1), close(hf2);
end
end


function debugInfo02(oup, ORmat)

if (isdebug)
    disp(Euler(oup)/degree);
end
if (isfulldebug)
    % Plot found orientations
    hf = figure;
    oa = getVariants(oup, inv(ORmat), symmetry('m-3m'));
    plotpdf(oa,Miller(1,0,0), 'antipodal', 'MarkerSize',4);
    pause(1);
    close(hf);
end

end
