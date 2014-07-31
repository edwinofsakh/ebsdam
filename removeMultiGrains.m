function [ frg_info1 ] = removeMultiGrains( grains, frg_info0, ORmat, CS, varargin )
% Remove multifragment grains
%
% Syntax
%	[ frg_info1 ] = removeMultiGrains( grains, frg_info0 )
%
% Output
%   frg_info1 - information about fragments:
%       frg     - index of grains in fragments
%       frg_po  - parent orientation of fragments
%       grn_frg - index of fragments for all grains
%       grn_po  - possible parent orientation of grains
%
% Input
%   grains    - grains
%   frg_info0 - information about fragments
%
% Example
%   ***
%
% See also
%   ***
%
% Used in
%   ***
%
% History
% 24.07.14  Original implementation

frg0     = frg_info0{1};
frg_po0  = frg_info0{2};
grn_frg0 = frg_info0{3};
grn_po0  = frg_info0{4};

grn_frg1 = grn_frg0;
grn_po1  = grn_po0;
frg_po1  = frg_po0;
frg1     = frg0;

% Find multifragment grains
ind0 = (cellfun(@length, grn_frg0) > 1);

ind0 = find(ind0);
o = get(grains, 'mean');

for i = ind0
    po   = grn_po1{i};
    ind1 = grn_frg1{i};
    
    mm = zeros(1,length(po));
    for j = 1:length(po)
        opj = po(j);
        [v, ~] = getVariants(opj, inv(ORmat), CS);
        ma = angle(v,o(i));
        mm(j) = min(ma);
    end
    [~,k] = min(mm);
    grn_frg1{i} = ind1(k);
    grn_po1{i} = po(k);
end

frg1 = item2group( grn_frg1);

frg_info1 = {frg1, frg_po1, grn_frg1, grn_po1};
end
