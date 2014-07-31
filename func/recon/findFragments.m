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
%   'secondRound' - add second order neighbours
%
% History
% 01.04.13  Find error in 'getOR', it's return matrix from alpha to gamma.
% 15.04.13  Separate from 'recon_new2' for saveing fragments map.
% 17.04.13  Change 'ORname' to 'ORmat'.
% 16.05.13  Add to output data possible parent orientation of grains.
% 23.07.14  Replace 'o' and 'pairs' input parameters to 'grains'.
% 28.07.14  Add 'varargin'. Add option 'secondRound'.

% Mean orientation and pairs of grains
o = get(grains, 'mean');
[~,pairs] = neighbors(grains);
wf = grainSize(grains);

% Number of orientations
n = numel(o);

% Prepare
frg     = cell(1,n);    % Indices of grains in fragments
frg_po  = cell(1,n);    % Parent orientation for fragments
grn_frg = cell(1,n);    % Indices of fragments for grains
grn_po  = cell(1,n);    % Posssible parent orientation for grains
% PP  = [];               % Probability of best fitting parent
c = 1;                  % number of last fragment

% For each grains
h = waitbar(0,'Find fragments...');
for i = 1:n
    dprintf(1,'%d-', i);
    
    % Find neighbors
    ind1 = getNeighbors(i, pairs);
    if check_option(varargin, 'secondRound');
        indc = num2cell(ind1);
        ind2 = cellfun(@(x) getNeighbors(x, pairs), indc, 'UniformOutput', 0);
        ind2 = cell2mat(ind2);
        ind1 = [ind1; ind2];
    end
    ind = unique([i; ind1]);
    
    % Orientations for checking
    o1 = o(ind);
    wf1 = wf(ind);

    if (isfulldebug)
        % Plot original orientations
        hf1 = figure;
        plotpdf(o1,Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        
        hf2 = figure;
        plotBoundary(grains);
        hold on; plot(grains(ind));
        hold off;
        
        pause(1);
        close(hf1), close(hf2);
    end

    % Try to find unique parent
    [Pmax, PR, oup, gind] = findUniqueParent(o1, wf1, ORmat, thr, Nv, w0, PRm, varargin{:});
    
    if (isa(oup, 'orientation'))
        
        if (isdebug)
            disp(Euler(oup)/degree);
        end
        if (isfulldebug)
            % Plot found orientations
            hf = figure;
            oa = getVariants(oup, inv(getOR('KS')), symmetry('m-3m'));
            plotpdf(oa,Miller(1,0,0), 'antipodal', 'MarkerSize',4);
            pause(1);
            close(hf);
        end
    
%         PP = cat(1,PP,[Pmax,PR]);
        ind = ind(gind)';
        frg{c} = ind;
        frg_po{c} = oup;
        for j = ind
            if isempty(grn_po{j})
                grn_po{j} = oup;
                grn_frg{j} = c;
            else
                grn_po{j} = [grn_po{j} oup];
                grn_frg{j} = [grn_frg{j} c];
            end
        end
        c = c+1;
    end
    waitbar(i/n);
end
close(h);

% Select filled fragment
% ind = cellfun(@(x) all(x == 0) , frg);
% gf = frg(~ind);
% gop = gop(~ind);

% Remove extra values
frg = frg(1:c-1);
frg_po = [frg_po{1:c-1}];

frg_info = {frg, frg_po, grn_frg, grn_po};

end
