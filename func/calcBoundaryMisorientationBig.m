function [ mori ] = calcBoundaryMisorientationBig( grains, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Pairs of grains
[~, pairs] = neighbors(grains);

% One way for getting misorientations and lengths of boundary
for i = 1:length(pairs)
    mori0 = calcBoundaryMisorientation(grains(pairs(i,1)),grains(pairs(i,2)), varargin{:});
    if (i == 1)
        mori = mori0;
    else
        mori = [mori; mori0]; %#ok<AGROW>
    end
    if (progressStatus(i,length(pairs),100))
        fprintf(1,'.');
    end
end
fprintf(1,' - done\n');

end

