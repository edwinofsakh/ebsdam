% Test dependency between OR Euler angle and CPP&CPD deviation

close all;

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