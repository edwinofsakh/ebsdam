function [ x, y ] = centerFragment( grains, gf, i )
%Return coordinates of fragment center

c = centroid(grains);
ind = gf{i};
c = c(ind,:);
v = mean(c);

x = v(1);
y = v(2);
end

