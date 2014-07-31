function [ b, v ] = find_parent( grains, ORra_a2g, v0, o0_a, delta )
%find_parent Summary of this function goes here
%   Detailed explanation goes here

o0_g = ORra_a2g(v0) * o0_a; % ???

v = zeros(1,numel(grains));
aa = zeros(1,numel(grains));
b = zeros(1,numel(grains));
% v(g0_id) = 1;
% aa(g0_id) = 0;
% b(g0_id) = 1;

o_a = get(grains,'mean');

% for i = [1:g0_id-1 g0_id+1:numel(grains)]
for i = [1:numel(grains)]
    D = (ORra_a2g * o_a(i)) \ o0_g;
    a = angle(D)/degree;
    [min_a,ind] = min(a);
    v(i) = ind;
    aa(i) = min_a;
    if (min_a < delta)
        b(i) = 1;
    end
end

figure;
cmap = colormap(jet(2));
plot(grains,'property',cmap(b+1,:));

figure;
plot(grains,'property',aa);

end

