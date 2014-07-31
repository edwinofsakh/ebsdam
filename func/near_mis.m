
ori = get(ebsd,'orientation');
X = get(ebsd, 'X');
Y = get(ebsd, 'Y');

radius = unitCellDiameter(ebsd)/2;

aa = [];

h = waitbar(0,'Please wait...')
steps = length(ori);
for i = 1:steps
    cx = X(i);
    cy = Y(i);
    d = sqrt((X-cx).^2+(Y-cy).^2);
    near = d <= 2*radius;
    near(i) = 0;
    ori_n = ori(near);
    mori = ori_n \ ori(i);
    aa = vertcat(aa, angle(mori));
    waitbar(i / steps);
end
close(h);

save('aa.mat', 'aa');

ori1 = ori(1:end-1);
ori2 = ori(2:end);

a = angle(ori1,ori2)/degree;
[n,x] = hist(a(a < 15),64);

figure;
bar(x,n/sum(n)*100);

ebsd_r = rotate(ebsd,90*degree);

ori = get(ebsd_r,'orientation');
ori1 = ori(1:end-1);
ori2 = ori(2:end);

a = angle(ori1,ori2)/degree;
[n,x] = hist(a(a < 15),64);

figure;
bar(x,n/sum(n)*100);