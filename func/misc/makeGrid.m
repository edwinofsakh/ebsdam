function [Xi,Yi, xy, in] = makeGrid(N, xscale, yshift, varargin)
%% Product grains
% Generate poor grid and transform it to hex (or other)
a = 2;
[X, Y] = meshgrid(0-a:1:N-1+a);

if (check_option(varargin, 'rescale', 'double'))
    N0 = get_option(varargin, 'rescale');
    X = (X/(N-1)*1.1-0.05)*(N0-1);
    Y = (Y/(N-1)*1.1-0.05)*(N0-1);
    rs = (N0-1)/(N-1);
else
    rs = 1;
end

[X, Y] = transformGrid(X, Y, xscale, rs*yshift);

% Reorder
X = X(:);
Y = Y(:);

if (check_option(varargin, 'Xp', 'double') && check_option(varargin, 'Yp', 'double'))
    ind0 = 1:length(X);
else
    % Save indices of interesting points
%     ind0 = inpolygon(X,Y,[0 0 rs*N*xscale rs*N*xscale],[0 rs*(N-1) rs*(N-1) 0]);
    ind0 = inpolygon(X,Y,[-1 -1 N N]*rs*xscale,rs*[-1 N N -1]);
end

% Random shift
dev = get_option(varargin, 'dev', 0, 'double');
if (dev > 0)
    n = length(X);
    X = X + rs*dev*(1-2*rand(n,1));
    Y = Y + rs*dev*(1-2*rand(n,1));
end

% Calc boundaries of grains
[v0,c0] = voronoin([X(:), Y(:)]); 

% Get interesting points after shifting
Xi = X(ind0);
Yi = Y(ind0);

% Low-level grains
Xp = get_option(varargin, 'Xp', Xi, 'double');
Yp = get_option(varargin, 'Yp', Yi, 'double');

% Catch grains
in = cell(1,length(c0));
xy = cell(1,length(c0));
for i = 1:length(c0)
    if all(c0{i}~=1)
        ind = inpolygon(Xp,Yp,v0(c0{i},1),v0(c0{i},2));
        if any(ind)
            in{i} = ind;
            xy{i} = [v0(c0{i},1),v0(c0{i},2)];
%             hold on; scatter(X(in{i}), Y(in{i}),5,'r','filled');
%             patch(v0(c0{i},1),v0(c0{i},2),'r');
        end
    end
end
ind = cellfun(@length, in);
in = in(ind > 0);
xy = xy(ind > 0);

plotGrid(X,Y, xy);
end

function plotGrid(X,Y, xy)

for i = 1:length(xy)
    patch(xy{i}(:,1),xy{i}(:,2),'r');
end

end

function [X1, Y1] = transformGrid(X, Y, xscale, yshift)

n = size(X,1);
X1 = X * xscale;
if mod(n,2) == 0
    Y1 = Y + repmat([0 yshift],[n,n/2]);
else
    Ya = [repmat([0 yshift],[n,(n-1)/2]) zeros(n,1)];
    Y1 = Y + Ya;
end

end