function [v, ind] = getVariants(o, ORmat, CS)
% Get all crystallographic variant of transformation products.
%   Array 'v' contain all variants. Variants groups by symmetry, first
%   variants for one rotation.
%   c1v1 c2v1 ... cnv1 c1v2 c2v2 ... cnv2 ...
%
% Syntax
%   [v, ind] = getVariants(r, OR, CS)
%
% Output
%   v       - variants
%   ind     - index of orientation
%
% Input
%   o       - orientations
%   ORmat   - orientation relation matrix
%
% History
% 17.04.13  Separate from 'findUniqueParent.m'

% Set misorientation
ORr = rotation('matrix', ORmat);

% Some variants
v = o*CS*ORr;
v = orientation(v,get(o,'CS'),get(o,'SS'));
ind = repmat(1:length(o),1,size(CS,1))'; % ???

end
