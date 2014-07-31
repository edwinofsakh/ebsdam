function [ group, cmap ] = merge_grains( pairs, n )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

group = [1:n];
group_m = zeros(1,n);

np = length(pairs); % number of special pairs

for i=1:np
    gl = pairs(i,1);
    gr = pairs(i,2);
    group_m(gl) = 1;
    group_m(gr) = 1;
    if (group(gr) ~= group(gl))
        group(group == group(gr)) = group(gl);
    end
end

group = group.*group_m;

ug = unique(group);
mg = max(group);
for i=1:length(ug)
    group(group == ug(i)) = mg+i;
end
group = group - mg;

cmap = colormap(hsv(length(ug)-1));
cmap = [1,1,1; cmap];
end

