function [ frg_info1 ] = addRemain( grains, frg_info0, ORmat, w, varargin )
% Add remaining orientation to the closest fragment
%   (?? Add orientation for grains remained after reconstruction ??)
%   (!! Never Used !!)
%
% Syntax
%   [ gf2 ] = addRemain( grains, frg_info0, ORmat, gf1, opp1, n, w )
%
% Output
%   frg_info1 - information about fragments:
%       frg     - index of grains in fragments
%       frg_po  - parent orientation of fragments
%       grn_frg - index of fragments for all grains
%       grn_po  - possible parent orientation of grains
%
% Input
%   grains    - grains map
%   frg_info0 - information about fragments:
%   ORmat     - orientation matrix (alpha to gamma)
%   w         - tolerance angle
%
% Example
%   
%
% History
% 12.04.13  Original implementation

frg0     = frg_info0{1};
frg_po0  = frg_info0{2};
grn_frg0 = frg_info0{3};
grn_po0  = frg_info0{4};

frg1     = frg0;
grn_frg1 = grn_frg0;
grn_po1  = grn_po0;

ng = length(grn_frg0);
n  = length(frg0);

%% Add remainnig grains
% Number of fragments for grain
prc = cellfun(@length, grn_frg0);

% Grains outside of all fragments
rmn = find(prc == 0);

% Mean orientation of grains
o = get(grains, 'mean');

hn = length(rmn);
hi = 1; % process indicator

h = waitbar(0,'Add remain...');

% For all grains outside the fragments
for i = rmn
    % Check with all fragments
    [v, ~] = getVariants(o(i), ORmat, get(o,'CS'));
    for j = 1:n
        mm  = angle(v,frg_po0(j))';
        mml = mm < w;
        if (any(mml))
            frg1{j} = [frg1{j} i];
            grn_frg1{i} = j;
            grn_po1{i} = frg_po0(j);
        end
    end
    hi = hi + 1;
    waitbar(hi/hn);
end
close(h);

% Grains outside of all fragments
prc = cellfun(@length, grn_frg1);
rmn = find(prc == 0);

if (~isempty(rmn))
    plotBoundary(grains,'ext'); hold on; plot(grains(rmn)); hold off;
end

frg_info1 = {frg1, frg_po0, grn_frg1, grn_po1};
end
