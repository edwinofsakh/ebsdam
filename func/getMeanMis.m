function [ mori, nmis ] = getMeanMis( grains )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%

% Mean orientation of grains
ori = get(grains, 'mean');

% Pairs of grains
[~, pairs] = neighbors(grains);

% Misorientation between grains
mori = getMis (ori, pairs);
nmis = length(mori);

end

