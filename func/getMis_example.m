function [ mori, nmis ] = getMeanMis( grains )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Mean orientation of grains
ori = get(grains, 'mean');

% Pairs of grains
[~, pairs] = neighbors(grains);

% Misorientation between grains
mori = getMis (ori, pairs);
nmis = length(mori);

% % Another way for getting misorientations and lengths of boundary
% rot = rotation;
% for i = 1:length(pairs)
%     mori = calcBoundaryMisorientation(grains(pairs(i,1)),grains(pairs(i,2)));
%     rot = [rot; rotation(mori)];
%     if length(mori) > 100
%         ttt = 1;
%     end
%     if (grainSize(grains(pairs(i,1))) > 100 || grainSize(grains(pairs(i,1))) > 100)
%         ttt = 1;
%     end
%     
%     % plot(grains([pairs(i,1), pairs(i,2)]))
% end

mori = orientation(rot, get(mori, 'CS'), get(mori, 'SS'));
nmis = length(mori);

% Another way for getting misorientations
mori = calcMisorientation(grains);
nmis = length(mori);
end

