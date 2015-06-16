% Test dependency between OR Euler angle and CPP&CPD deviation

close all;

%% Old approach
iAr = 0:0.5:5;
n = length(iAr);
aa = zeros(2,n);
j = 0;
for i = iAr
	j = j + 1;
	mtr = normalizeOR('ori', {[24.2038+i 10.5294 24.2038-2*i]*degree});
	[~,o] = getOR(mtr);
	aa(1,j) = angle(Miller(-1,0,1),o*Miller(-1,-1,1))/degree
	aa(2,j) = angle(Miller(1,1,1),o*Miller(0,1,1))/degree
end

figure; plot(iAr, aa(1,:));
figure; plot(iAr, aa(2,:));

%% New approach

a = 8;
d = 1;

x = 24.2038 + (0:d:a);
y = 10.5294 + (0:d:a);
z = 24.2038 + (0:d:a);

[X,Y,Z] = meshgrid(x,y,z);
clr = [X(:)-24.2038, Y(:)-10.5294, Z(:)-24.2038]/a;

n = numel(X);
CPP = zeros(1,n);
CPD = zeros(1,n);
for i = 1:n
	[CPP(i),CPD(i)] = calcCP_dev([X(i) Y(i) Z(i)]*degree);
end

figure();
title('Map Euler space into CPP&CPD deviations');
scatter(CPP, CPD,4,clr);

%% Deviation from IVM from random orientation distribution
close all;
saveResult('off');

N = 36;
S = 25;

[X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.1);
ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree, 'dev', 1*degree);
figure; plot(ebsd);

grains = getGrains(ebsd, 2*degree, 0, 'unitCell');
mori = calcBoundaryMisorientation(grains, 'ext');

figure; hist(angle(mori)/degree,1:62);

HistNearKOG(grains, 5, 'KS', 0, 0, '.\test', 'test', 'test1', 'test2');

% optORm = optimizeOR2(mori, 'test', 'full', 'start', 'KS', 'firstView');

% epsCurve('test', 'full', mori, 0, '.\test', 'test', 'test2', 'start', 'KS');