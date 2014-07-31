function ploto2( grains, v, ng )
%ploto Plot mean orientation of grains by area
%   Detailed explanation goes here

s = area(grains);
% s = grainSize(grains);
o = get(grains, 'MeanOrientation');
r = rotation(o);

[max_area,ii] = max(s);
min_area = min(s);

[ss, ind] = sort(s,'ascend');
r = r(ind);

n = numel(grains);
m = 416*ng;

if (n > m)
    ind2 = n-m+1:n;
    r = r(ind2);
    ss = ss(ind2);
end

oo = orientation(r, get(o,'CS'), get(o,'SS'));

c = fix(n/ng);

ia = zeros(1,ng+2);
ia(1) = 1;
for i = 1:ng
    ia(i+1) = c*i;
end
ia(ng+2) = n;
    
h = Miller(v);

for i = ng+1:-1:1
    plotpdf(oo(ia(i):ia(i+1)),h,'antipodal','MarkerSize',ng+2-i, 'grid');
    hold on;
end
hold off;
% hold on, plot(o(ii),'antipodal'),hold off;
 
colormap(1-gray);
colorbar;

disp(['Max area: ' num2str(max(s)) '; Min area: ' num2str(min(s)) ';'])
end

