function ploto( grains, v )
%ploto Plot mean orientation of grains by area
%   Detailed explanation goes here

% s = area(grains);
s = grainSize(grains);
o = get(grains, 'MeanOrientation');
r = rotation(o);

[~,ii] = max(s);

[ss, ind] = sort(s,'ascend');
r = r(ind);

n = numel(grains);
m = 416;

% grains = grains(ind);

if (n > m)
    ind2 = n-m+1:n;
    r = r(ind2);
    ss = ss(ind2);
end

% o = get(grains, 'MeanOrientation');
oo = orientation(r, get(o,'CS'), get(o,'SS'));

h = Miller(v);

plotpdf(oo,h,'antipodal','MarkerSize',3,'property',ss, 'grid', 'log');

% hold on, plot(o(ii),'antipodal'),hold off;
 
colormap(1-gray);
colorbar;

% figure;
% plotpdf(o,h,'antipodal','MarkerSize',3,'property',s, 'grid');
% 
% hold on, plot(o(ii),'antipodal'),hold off;
%  
% colormap(1-gray);
% colorbar;

% h2 = Miller(v,get(o,'CS'));

% sm = repmat(s',1,length(symmetrise(h2)));
% plotpdf(o,h,'DATA',log10(sm),'antipodal','MarkerSize',5);
% 
% colormap(1-gray);
% colorbar;


% whitebg([0.9 0.9 1]);
disp(['Max area: ' num2str(max(s)) '; Min area: ' num2str(min(s)) ';'])
end

