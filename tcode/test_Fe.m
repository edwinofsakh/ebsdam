
g1 = findByLocation(grains, [50 5]);
g2 = findByLocation(grains, [38 6]);
g3 = findByLocation(grains, [40 15]);
g4 = findByLocation(grains, [30 18]);
g5 = findByLocation(grains, [50 20]);
g6 = findByLocation(grains, [20 15]);
g7 = findByLocation(grains, [30 44]);
g8 = findByLocation(grains, [50 45]);

o1 = get(g1, 'orientation');
o2 = get(g2, 'orientation');
o3 = get(g3, 'orientation');
o4 = get(g4, 'orientation');
o5 = get(g5, 'orientation');
o6 = get(g6, 'orientation');
o7 = get(g7, 'orientation');
o8 = get(g8, 'orientation');

figure;

plot(o1,'antipodal'); hold on;
plot(o5,'antipodal'); hold on;
plot(o7,'antipodal'); hold on;
plot(o8,'antipodal'); hold off;

m(1) = o1\o5;
m(2) = o1\o7;
m(3) = o1\o8;

m(4) = o5\o7;
m(5) = o5\o8;

m(6) = o7\o8;

ma = angle(m)/degree;
maa = axis(m);

figure;

plot(m(1),'antipodal'); hold on;
plot(m(2),'antipodal'); hold on;
plot(m(3),'antipodal'); hold on;
plot(m(4),'antipodal'); hold on;
plot(m(5),'antipodal'); hold on;
plot(m(6),'antipodal'); hold off;

[~,~,dis,~] = calcKOG_new('KS');
dis = dis(1:end);
disa = angle(dis)/degree;
disaa = axis(dis);

OR_g2a = getOR('KS');
ORo_a2g = rotation('matrix', inv(OR_g2a));
ORoa_a2g =  rotation(get(o1,'CS')) * ORo_a2g;

test = ORo_a2g(1);

a = zeros(length(dis),6);
b = zeros(length(dis),6);
c = zeros(length(dis),6);
for i = 1:length(dis)
    for j = 1:6
        a(i,j) = angle(dis(i),m(j))/degree;
        b(i,j) = abs(disa(i)-ma(j));
        c(i,j) = angle(disaa(i),maa(j))/degree;
    end
end
d = b.*c;

ot = orientation(ORoa_a2g,get(o1,'CS'),get(o1,'SS'));

mis = ot\ot;
mism = zeros(24,24);
for i = 1:24
    for j = 1:24
        mism(i,j) = find(dis,mis(i,j));
    end
end
