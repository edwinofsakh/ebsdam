function [X, Y] = gridGrains(N, xscale, yshift, S, varargin)
% Generate list of coordinates of grains' centers
%   For HexGrid     - sqrt(3)/2, 0.5
%   For SquareGrid  -       1.0, 0.0
%   For RhombusGrid -       0.5, 0.5
%
% Syntax
%   [X, Y] = gridGrains(N, xscale, yshift, S, varargin)
%
% Output
%   [X, Y]	- list of coordinates of grains' centers
%
% Input
%   N         - grains in line, N*N number of grains
%   xscale    - x scale
%   yshift    - y scale
%   S         - small size
%
% Options
%   dev     - max value of random deviation of center coordinates
%   rnd     - number of splited centers
%   point   - number of additional quadpoints with random position
%   display - plot mesh
%
% Example
%   [X, Y] = gridGrains(10, sqrt(3)/2, 0.5, 10, 'rnd', 5, 'point', 5, 'dev', 0.3, 'display');
%
% History
% 21.11.13  Original implementation

% Generate hexagonal grid
[X Y] = meshgrid(0:1:N-1);
n = size(X,1);
X = X * xscale;
Y = Y + repmat([0 yshift],[n,n/2]);

% Random shift
dev = get_option(varargin, 'dev', 0, 'double');
if (dev > 0)
    X = X + dev*(1-2*rand(N));
    Y = Y + dev*(1-2*rand(N));
end

X = X(:);
Y = Y(:);

% Additional random points
Nr = get_option(varargin, 'rnd', 0, 'double');
ss = 3/S;
Np = 4;
if Nr > 0
    ind = randi(length(X),Nr,1);
    
    r = ss*(1-2*rand(Nr,Np*2));
    r = r + 1/S*sign(r);
    
    Xr = repmat(X(ind), 1,Np) + r(:,1:Np);
    Yr = repmat(Y(ind), 1,Np) + r(:,Np+1:2*Np);
    
    X = vertcat(X,Xr(:));
    Y = vertcat(Y,Yr(:));
end

% Additional random points
Nr = get_option(varargin, 'point', 0, 'double');

a = 1/S;

if Nr > 0
    Xp = repmat([0 -a  0  a  0],Nr,1);
    Yp = repmat([0  0  a  0 -a],Nr,1);
    
    Xr = repmat(max(max(X))*rand(Nr,1),1,5) + Xp;
    Yr = repmat(max(max(Y))*rand(Nr,1),1,5) + Yp;
    
    X = vertcat(X,Xr(:));
    Y = vertcat(Y,Yr(:));
end

% Remove close points
 dt = DelaunayTri(X,Y);
  e = edges(dt);
  R = sqrt((X(e(:,1))-X(e(:,2))).^2 + (Y(e(:,1))-Y(e(:,2))).^2);
  c = find(R < 1/S);
ind = ones(1,length(X(:)));
ind(e(c,1)) = 0; %#ok<FNDSB>
X = X(logical(ind));
Y = Y(logical(ind));

% Plot the mesh, including cell borders
if check_option(varargin, 'display')
    figure;
    [vx,vy] = voronoi(X,Y);
    patch(vx,vy,'k'); hold on;
    scatter(X,Y,5,'k','filled');
    axis equal;
    axis([min(X) max(X) min(Y) max(Y)]), zoom on;
    box on;
    if check_option(varargin, 'tick_off')
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
end

end
