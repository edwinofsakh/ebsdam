% Minimize functional
close all
clear all

% %% First test - point
% N = 20;
% x = rand(1,N);
% y = rand(1,N);
% 
% ax = mean(x);
% ay = mean(y);
% 
% xp = 0.1:0.01:0.9;
% yp = 0.1:0.01:0.9;
% 
% n = length(xp);
% 
% [Xp, Yp] = meshgrid(xp,yp);
% 
% Z = zeros(size(Xp));
% 
% for i=1:numel(Xp)
%     Z(i) = sum(sqrt((x-Xp(i)).^2 + (y-Yp(i)).^2))/N;
% end
% 
% [mZ, mi] = min(Z);
% [mz, mj] = min(mZ);
% mx = xp(mj);
% my = yp(mi(mj));
% 
% figure;
% mesh(Xp,Yp,Z);
% 
% figure;
% scatter( x, y, 5,'k', 'filled'); hold on;
% scatter(ax,ay,20,'r', 'filled'); hold on;
% scatter(mx,my,20,'g', 'filled'); hold off;
% xlim([0 1]);
% ylim([0 1]);
% axis square;
% 
% figure;
% Z0 = Z(2:end-1,2:end-1);
% Z1 = Z(1:end-2,2:end-1);
% Z2 = Z(3:end,  2:end-1);
% Z3 = Z(2:end-1,1:end-2);
% Z4 = Z(2:end-1,3:end  );
% dZ = (abs(Z0-Z1)+abs(Z0-Z2)+abs(Z0-Z3)+abs(Z0-Z4))/4;
% mesh(Xp(2:end-1,2:end-1),Yp(2:end-1,2:end-1),dZ);
% 
% [mx,my,mz]
% [ax,ay,sum(sqrt((x-ax).^2 + (y-ay).^2))/N]
% 
% clear all


% %% Second test - circular
% N = 100;
% rho = 1 + (0.5-rand(1,N))/10;
% theta = 2*360*rand(1,N)*degree;
% 
% [x,y] = pol2cart(theta,rho);
% 
% ax = mean(x);
% ay = mean(y);
% 
% xp = -0.3:0.01:0.3;
% yp = -0.3:0.01:0.3;
% 
% n = length(xp);
% 
% [Xp, Yp] = meshgrid(xp,yp);
% 
% Z = zeros(size(Xp));
% 
% for i=1:numel(Xp)
%     Z(i) = sum(abs(sqrt((x-Xp(i)).^2 + (y-Yp(i)).^2)-1))/N;
% end
% 
% [mZ, mi] = min(Z);
% [mz, mj] = min(mZ);
% mx = xp(mj);
% my = yp(mi(mj));
% 
% figure;
% mesh(Xp,Yp,Z);
% 
% figure;
% scatter( x, y, 5,'k', 'filled'); hold on;
% 
% scatter( 0, 0, 5,'k', 'filled'); hold on;
% t = 0:.1:2.1*pi; yt = cos(t); xt = sin(t);
% plot(xt,yt); hold on;
% 
% scatter(ax,ay,20,'r', 'filled'); hold on;
% t = 0:.1:2.1*pi; yt = cos(t)+ay; xt = sin(t)+ax;
% plot(xt,yt,'r'); hold on;
% 
% scatter(mx,my,20,'g', 'filled'); hold on;
% t = 0:.1:2.1*pi; yt = cos(t)+my; xt = sin(t)+mx;
% plot(xt,yt,'g'); hold off;
% 
% xlim([-1.2 1.2]);
% ylim([-1.2 1.2]);
% axis square;
% 
% figure;
% Z0 = Z(2:end-1,2:end-1);
% Z1 = Z(1:end-2,2:end-1);
% Z2 = Z(3:end,  2:end-1);
% Z3 = Z(2:end-1,1:end-2);
% Z4 = Z(2:end-1,3:end  );
% dZ = (abs(Z0-Z1)+abs(Z0-Z2)+abs(Z0-Z3)+abs(Z0-Z4))/4;
% mesh(Xp(2:end-1,2:end-1),Yp(2:end-1,2:end-1),dZ);
% 
% [mx,my,mz]
% [ax,ay,sum(sqrt((x-ax).^2 + (y-ay).^2))/N]
% 
% clear all
% 
% %% Third test - circular
% N = 100;
% rho = 1 + (0.5-rand(1,N))/10;
% theta = 2*360*rand(1,N)*degree;
% 
% [x,y] = pol2cart(theta,rho);
% 
% ax = mean(x);
% ar = mean(rho);
% 
% xp = -0.2:0.01:0.2;
% rp = 0.8:0.01:1.2;
% 
% n = length(xp);
% 
% [Xp, Rp] = meshgrid(xp,rp);
% 
% Z = zeros(size(Xp));
% 
% for i=1:numel(Xp)
%     Z(i) = sum(abs(sqrt((x-Xp(i)).^2 + (y).^2)-Rp(i)))/N;
% end
% 
% [mZ, mi] = min(Z);
% [mz, mj] = min(mZ);
% mx = xp(mj);
% mr = rp(mi(mj));
% 
% figure;
% mesh(Xp,Rp,Z);
% 
% figure;
% scatter( x, y, 5,'k', 'filled'); hold on;
% scatter( 0, 0, 5,'k', 'filled'); hold on;
% 
% t = 0:.1:2.1*pi; yt = cos(t); xt = sin(t);
% plot(xt,yt); hold on;
% 
% scatter(ax, 0, 5,'r', 'filled'); hold on;
% t = 0:.1:2.1*pi; yt = ar*cos(t); xt = ar*sin(t)+ax;
% plot(xt,yt,'r'); hold on;
% 
% scatter(mx, 0, 5,'g', 'filled'); hold on;
% t = 0:.1:2.1*pi; yt = mr*cos(t); xt = mr*sin(t)+mx;
% plot(xt,yt,'g'); hold off;
% xlim([-1.2 1.2]);
% ylim([-1.2 1.2]);
% axis square;
% 
% figure;
% Z0 = Z(2:end-1,2:end-1);
% Z1 = Z(1:end-2,2:end-1);
% Z2 = Z(3:end,  2:end-1);
% Z3 = Z(2:end-1,1:end-2);
% Z4 = Z(2:end-1,3:end  );
% dZ = (abs(Z0-Z1)+abs(Z0-Z2)+abs(Z0-Z3)+abs(Z0-Z4))/4;
% mesh(Xp(2:end-1,2:end-1),Rp(2:end-1,2:end-1),dZ);
% 
% [mx,mr,mz]
% [ax,ar,sum(abs(sqrt((x-ax).^2 + (y).^2)-ar))/N]
% 
% clear all;

%% Fourth test - circular
N = 100;
rho = 1 + (0.5-rand(1,N))/10;
theta = 2*360*rand(1,N)*degree;

[x,y] = pol2cart(theta,rho);

ax = mean(x);
ay = mean(x);
ar = mean(rho);

xp = -0.2:0.01:0.2;
yp = -0.2:0.01:0.2;
rp = 0.8:0.01:1.2;

n = length(xp);

[Xp, Yp, Rp] = meshgrid(xp,yp,rp);

Z = zeros(size(Xp));

for i=1:numel(Xp)
    Z(i) = sum(abs(sqrt((x-Xp(i)).^2 + (y-Yp(i)).^2)-Rp(i)))/N;
end

[m2, mi] = min(Z, [], 3);
[m1, mj] = min(m2, [], 2);
[mz, mk] = min(m1);
my = yp(mk);
mx = xp(mj(mk));
mr = rp(mi(mj(mk)));

% figure;
% mesh(Xp,Rp,Z);
i = 21; mesh(reshape(Xp(i,:,:),[n n]),reshape(Rp(i,:,:),[n n]),reshape(Z(i,:,:),[n n])); hold on;
i = 10; mesh(reshape(Xp(i,:,:),[n n]),reshape(Rp(i,:,:),[n n]),reshape(Z(i,:,:),[n n])); hold on;
hold off;

figure;
scatter( x, y, 5,'k', 'filled'); hold on;
scatter( 0, 0, 5,'k', 'filled'); hold on;

t = 0:.1:2.1*pi; yt = cos(t); xt = sin(t);
plot(xt,yt); hold on;

scatter(ax, ay, 5,'r', 'filled'); hold on;
t = 0:.1:2.1*pi; yt = ar*cos(t)+ay; xt = ar*sin(t)+ax;
plot(xt,yt,'r'); hold on;

scatter(mx, my, 5,'g', 'filled'); hold on;
t = 0:.1:2.1*pi; yt = mr*cos(t)+my; xt = mr*sin(t)+mx;
plot(xt,yt,'g'); hold off;
xlim([-1.2 1.2]);
ylim([-1.2 1.2]);
axis square;

figure;
Z0 = Z(2:end-1,2:end-1,2:end-1);
Z1 = Z(1:end-2,2:end-1,2:end-1);
Z2 = Z(3:end,  2:end-1,2:end-1);
Z3 = Z(2:end-1,1:end-2,2:end-1);
Z4 = Z(2:end-1,3:end  ,2:end-1);
Z5 = Z(2:end-1,2:end-1,1:end-2);
Z6 = Z(2:end-1,2:end-1,3:end  );
dZ = (abs(Z0-Z1)+abs(Z0-Z2)+abs(Z0-Z3)+abs(Z0-Z4)+abs(Z0-Z5)+abs(Z0-Z6))/6;
mesh(reshape(Xp(21,2:end-1,2:end-1),[n-2 n-2]),reshape(Rp(21,2:end-1,2:end-1),[n-2 n-2]),reshape(dZ(20,:,:),[n-2 n-2]));

figure();
plot(reshape(Rp(21,21,:),[1 n]),reshape(Z(21,21,:),[1 n]));

[mx,my,mr,mz]
[ax,ay,ar,sum(abs(sqrt((x-ax).^2 + (y-ay).^2)-ar))/N]
[0,0,1,sum(abs(sqrt((x).^2 + (y).^2)-1))/N]
