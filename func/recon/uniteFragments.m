function [ frg_info1 ] = uniteFragments( grains, frg_info0, w, varargin )
% Unite fragments with close orientation
%
% Syntax
%   [ frg_info1 ] = uniteFragments(grains, frg_info0, w );
%
% Output
%   frg_info1 - information about fragments:
%       frg     - index of grains in fragments
%       frg_po  - parent orientation of fragments
%       grn_frg - index of fragments for all grains
%       grn_po  - possible parent orientation of grains
%   (old)gf1  - new index of grains in fragments
%   (old)oop1 - new parent orientation of fragments
%
% Input
%   frg_info0 - information about fragments:
%   (old)gf   - index of grains in fragments
%   (old)opp  - parent orientation of fragments
%   w         - tolerance angle
%
% History
% 12.04.13  Original implementation

frg0     = frg_info0{1};
frg_po0  = frg_info0{2};
grn_frg0 = frg_info0{3};
grn_po0  = frg_info0{4};

frg_po1 = frg_po0;
frg1 = frg0;
n = length(frg_po1);
i = 1;

h = waitbar(0,'Unite fragments...');

% For all fragments
while i < n
%     ind = i;
    mis = angle(frg_po1,frg_po1(i));
    mm = (mis < w)';
    
    % Coordinates of grain center
    c = centroid(grains);
    
    % Find fragments with close orientations
    if (sum(mm) > 1)
        if (isdebug)
            plotpdf(frg_po1(mm),Miller(1,0,0),'antipodal', 'MarkerSize', 4);
        end
        
        frg_po1(i) = mean(frg_po1(mm));
        frg1{i} = unique([frg1{mm}]);
        a = ~mm;
        b = (1:n == i);
        frg_po1 = frg_po1(a | b);
        frg1 = frg1(a | b);
        n = length(frg_po1);
    end
        
	i = i+1;
    waitbar(i/n);
end
close(h);

if (isfulldebug)
    plotpdf(frg_po1,Miller(1,0,0),'antipodal', 'MarkerSize', 4);
end

% colorFragments(grains_fe, frg1);

grn_frg1 = group2item( frg1, numel(grains));
grn_po1 = cellfun(@(x) frg_po1(x), grn_frg1, 'UniformOutput',false);


frg_info1 = {frg1, frg_po1, grn_frg1, grn_po1};
end
