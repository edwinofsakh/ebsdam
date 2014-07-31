function [ ang, axe, pairs ] = getAA( dis )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dis = dis(:);
ang = angle(dis)/degree;
axe = axis(dis);

pairs = [ang(:), abs(getx(axe(:))),  abs(gety(axe(:))),  abs(getz(axe(:)))];
pairs = round(pairs*100)/100;
ind = pairs(:,1) > 0;
pairs = pairs(ind,:);
pairs = [pairs(:,1) , sort(pairs(:,2:4),2)];

end

