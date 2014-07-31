function [X, Y, in, in_xy] = gridPriorGrains(N, xscale, yshift, varargin)
% Generate list of coordinates of grains' centers
%   For HexGrid     - sqrt(3)/2, 0.5
%   For SquareGrid  -       1.0, 0.0
%   For RhombusGrid -       0.5, 0.5
%
% Syntax
%   [X, Y, in] = gridPriorGrains(N, xscale, yshift, varargin)
%
% Output
%   [X, Y]	- list of coordinates of grains' centers
%   in      - prior grain information (index of grain)
%
% Input
%   N         - grains in line, N*N number of grains
%   xscale    - x scale
%   yshift    - y scale
%
% Options
%   dev     - max value of random deviation of center coordinates
%   display - plot mesh
%
% Example
%   [X, Y, in] = gridPriorGrains(12, sqrt(3)/2, 0.5, 'dev', 0.2, 'display');
%
% History
% 21.11.13  Original implementation
% 20.07.14  Add polygon coordinates for output


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

% Prior Grain
[Xp, Yp] = getPoints(min(min(X)), max(max(X)), min(min(Y)), max(max(Y)));
ind = {[1 2 4 5]; [2 3 6 4]; [5 4 6]};

in = cell(1,3);
in_xy = cell(1,3);
for i = 1:3
    in{i} = inpolygon(X,Y,Xp(ind{i}),Yp(ind{i}));
    in_xy{i} = [Xp(ind{i}),Yp(ind{i})];
end

if any(in{1}.*in{2}.*in{3})
    error('one grain in to prior');
end
    
% Plot the mesh, including cell borders
if check_option(varargin, 'display')
    figure;
    [vx,vy] = voronoi(X(:),Y(:));
    patch(vx,vy,'k');
    axis equal;
    axis([min(min(X)) max(max(X)) min(min(Y)) max(max(Y))]), zoom on;
    
    figure;
    for i = 1:length(ind)
        patch(Xp(ind{i}),Yp(ind{i}),i);
    end
    axis equal;
    axis([min(min(X)) max(max(X)) min(min(Y)) max(max(Y))]), zoom on;
    
end
end

function [X, Y] = getPoints(X1, X2, Y1, Y2)
%
%   5*****6
%   *\***/*
%   **\*/**
%   ***4***
%   ***|***
%   1**2**3

Xc = (X2+X1)/2;
Yc = (Y2+Y1)/2;

X = [X1 Xc X2 Xc X1 X2];
Y = [Y1 Y1 Y1 Yc Y2 Y2];
end