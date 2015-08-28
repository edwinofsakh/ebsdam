function gstat(grains, saveres, outdir, prefix, varargin)

comment = getComment();

A = sort(area(grains));

a = floor(log10(min(A)));
b = ceil(log10(max(A)));

Y = cumsum(A)./sum(A);
Ye = (1:numel(A))'./numel(A);
% X = A;
% dY = diff(Y);
% dYe = diff(Ye);
% dX = diff(X);

figure; semilogx(A, Y);
xlim(10.^([a b]));
set(gca,'xtick',10.^(a:b)) % adjust the ticks
grid on
xlabel('area'),ylabel('cumulative area fraction')
saveimg( saveres, 1, outdir, prefix, 'caf', 'png', comment );

% Edit before use!
% figure; loglog(A(2:end), dY./dX);
% xlim([a b]);
% set(gca,'xtick',10.^(a:b)) % adjust the ticks
% grid on
% 
% xi = 10.^(a:0.02:b);
% yi = interp1(X,Y,xi);
% figure; loglog(10.^(0.02:0.02:5), diff(yi)./diff(xi));
% xlim([1 10^5]);
% set(gca,'xtick',10.^(a:b)) % adjust the ticks
% grid on

%
figure; semilogx(A, Ye);
xlim(10.^([a b]));
set(gca,'xtick',10.^(a:b)) % adjust the ticks
grid on
xlabel('area'),ylabel('cumulative percentage')
saveimg( saveres, 1, outdir, prefix, 'cp', 'png', comment );

% Edit before use!
% figure; loglog(A(2:end), dYe./dX);
% xlim([1 10^5]);
% set(gca,'xtick',10.^(a:b)) % adjust the ticks
% grid on
% 
% xi = 10.^(0:0.02:5);
% yi = interp1(X,Ye,10.^(0:0.02:5));
% figure; loglog(10.^(0.02:0.02:5), diff(yi)./diff(xi));
% xlim([1 10^5]);
% set(gca,'xtick',10.^(a:b)) % adjust the ticks
% grid on

%
figure;
bins = 10.^(a:0.1:b);
[n,xout] = hist(A,bins); %#ok<NASGU>
bar(a:0.1:b, n/sum(n));
xlim([a b]);
xlabel('grain area, 10^x');
ylabel('%');
saveimg( saveres, 1, outdir, prefix, 'bin', 'png', comment );

% figure;
% hist(A,1024);
end