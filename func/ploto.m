function ploto( grains, v )
%ploto Plot mean orientation of grains by area
%   Detailed explanation goes here

s = area(grains);
% s = grainSize(grains);
o = get(grains, 'MeanOrientation');
r = rotation(o);

[~,ii] = max(s);

[ss, ind] = sort(s,'ascend');
r = r(ind);

n = numel(grains);
m = 416;

if (n > m)
    ind2 = n-m+1:n;
    r = r(ind2);
    ss = ss(ind2);
end

oo = orientation(r, get(o,'CS'), get(o,'SS'));

h = Miller(v);

plotpdf(oo,h,'antipodal','MarkerSize',3,'property',ss, 'grid', 'log');

% hold on, plot(o(ii),'antipodal'),hold off;
 
colormap(1-gray);
colorbar;

disp(['Max area: ' num2str(max(s)) '; Min area: ' num2str(min(s)) ';'])
end

