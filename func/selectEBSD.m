function [ ebsd_cut, lineXY ] = selectEBSD( sid, ebsd, phase, lineXY, saveres, prefix )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Load EBSD
% Load EBSD data
ebsd = checkEBSD(sid, ebsd, phase);

comment = getComment();

%% Select  polygon
figure;
plot(ebsd,'antipodal');

if (lineXY == 0)
    lineXY = ginput;
    lineXY = vertcat(lineXY, lineXY(1,:));
end

hold on; line(lineXY(:,1),lineXY(:,2)); hold off;
ebsd_cut = ebsd(inpolygon(ebsd,lineXY));

if saveres
    OutDir = checkDir(sid, 'grains', saveres);
    saveimg(saveres,1,OutDir,prefix, 'select', 'png', comment);
end

figure;
plot(ebsd_cut);
end

