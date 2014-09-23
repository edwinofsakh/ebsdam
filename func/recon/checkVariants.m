function [vnum] = checkVariants(opf, ORmat, CS, ori)
% Identifying variant's number for set of orientations.
%   Generates all variants for parent orientation and finds nearest for 
%   each orientation from set.
%
% Syntax
%   [vnum] = checkVariants(opf, ORmat, CS, ori)
%
% Output
%   vnum    - variant number for orientations from 'ori'
%
% Input
%   opf     - orientation of parent
%   ORmat   - orientation relation (matrix)
%   CS      - crystal symmetry
%   ori     - orientation for checking
%
% History
% 14.08.14  Original implementation
% 20.09.14  Add comments

vv = getVariants(opf, inv(ORmat), CS);
ma = angle(ori\vv);
[~,ma2i] = min(ma,[],2);
vnum = ma2i;

end

