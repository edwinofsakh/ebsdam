% Test dependency between OR Euler angle and CPP&CPD deviation

close all;

%%
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

%%
% KS [24.2038+i 10.5294 24.2038-2*i]*degree

a = 8;
d = 1;

x = 24.2038 + (-a:d:a);
y = 10.5294 + (-a:d:a);
z = 24.2038 + (-a:d:a);

[X,Y,Z] = meshgrid(x,y,z);

n = numel(X);
CPP = zeros(1,n);
CPD = zeros(1,n);
for i = 1:n
	[~,o] = getOR([X(i) Y(i) Z(i)]*degree);
	[CPP(i),CPD(i)] = calcCP_dev(o);
end

figure();
title('Map Euler space into CPP&CPD deviations');
scatter(CPP, CPD);