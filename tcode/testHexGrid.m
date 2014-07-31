function plotMisProfile(ebsd, p1,p2)
% Plot misorientation anlge profile along line p1-p2
%
% Syntax

close all;
clear all;

ebsd = ak05s_load();
ebsd_c = cutEBSD(ebsd, 0,0, 5,5);
grains = getGrains(ebsd_c, 2*degree,0);

% Draw grid and line
figure();
plot(ebsd_c, 'antipodal');
hold on; plotBoundary(grains);

% 
x = get(ebsd_c, 'x');
y = get(ebsd_c, 'y');

dt = DelaunayTri(x,y);

% Get unitCell size
uc = get(ebsd, 'unitCell');
a = (uc(2) - uc(1));
a = sqrt(sum(a.*a));

% Start and end points of profile line
q1 = ginput(1);% [4, 1];
q2 = ginput(1);% [3, 3];
dq = (q2 - q1);

% Number of points on line
n = fix( sqrt(sum(dq.*dq))/a + 1 );
dq = dq / n;

% Array of points
px = q1(1):dq(1):q2(1);
py = q1(2):dq(2):q2(2);


% Draw
hold on; scatter(x,y,2,'filled');
hold on; line([q1(1) q2(1)],[q1(2) q2(2)]);
hold on; scatter(px,py,150,'g','filled');

% Find nearest grid nodes
v = nearestNeighbor(dt, px',py');

% % Remove duplicate
% v = unique(v);
% [nx, ind] = sort(x(v));
% ny = y(v);
% ny = ny(ind);

% Draw grid nodes
hold on; plot(x(v),y(v));
hold on; scatter(x(v),y(v),8,'r','filled');

hold off;

% figure();
% plot(ebsd_c, 'antipodal');
% hold on; line([qx1 qx2],[qy1 qy2]);
% hold off;

ori = get(ebsd_c,'orientation');

m = zeros(1,length(v));
for i = 1:(length(v)-1)
    o1 = ori(v(i+1));
    o2 = ori(v(i));
    mo = o1.\o2;
    sz = sign(get(axis(mo),'l'));
    
    m(i+1) = m(i) + sz*angle(mo)/degree;
end

figure();
plot(m,'-o');

