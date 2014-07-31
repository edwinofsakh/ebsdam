function [X, Y] = hgridGrains(Nn, Mn, L, mitr, varargin)
% Generate list of coordinates of grains' centers with hierarchy
%   For HexGrid     - sqrt(3)/2, 0.5
%   For SquareGrid  -       1.0, 0.0
%   For RhombusGrid -       0.5, 0.5
%
% Syntax
%   [[X, Y] = hgridGrains(N, M, L, mitr, varargin)
%
% Output
%   [X, Y]	- list of coordinates of grains' centers
%
% Input
%   Nn        - number of grains at one iteration
%   Mn        - number of grains for iteration
%   L         - length factor
%   mitr      - number of iteration
%
% Options
%   rnd     - number of splited centers
%   point   - number of additional quadpoints with random position
%   display - plot mesh
%
% Example
%	[X, Y] = hgridGrains([10 4 2], [5 2 1], 1, 2, 'display');
%
% History
% 21.11.13  Original implementation

if ~(length(Mn) == 1) && ~(length(Mn) == mitr+1)
    error('Bad "Mn".');
end

if ~(length(Nn) == 1) && ~(length(Nn) == mitr+1)
    error('Bad "Nn".');
end

[X,Y] = step(Nn,Mn,L, 0,mitr);
%X = X + 0.5;
%Y = Y + 0.5;

hxv = [0.0 1.0 1.0 0.0] - 0.5;
hyv = [0.0 0.0 1.0 1.0] - 0.5;
IN = inpolygon(X,Y, 0.5*hxv, 0.5*hyv);
X = X(IN);
Y = Y(IN);

% Plot the mesh, including cell borders
if check_option(varargin, 'display')
    figure;
    [vx,vy] = voronoi(X,Y);
    patch(vx,vy,'k'); hold on;
    scatter(X,Y,5,'k','filled');
    axis equal;
    axis([-0.25 0.25 -0.25 0.25]), zoom on;
    box on;
    if check_option(varargin, 'tick_off')
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
    end
end

end

function [Xo,Yo] = step(Nn,Mn,L, itr,mitr)

if length(Mn) == 1
    m = Mn;
else
    m = Mn(itr+1);
end

if length(Nn) == 1
    N = Nn;
else
    N = Nn(itr+1);
end

[X Y] = meshgrid(0:1:N-1);

ind = mod(1:N,2) == 1;
Y(:,ind) = Y(:,ind) + 0.5; 

X = L*( (N-1)/N * (X(:)/(N-1) - 1/2) );
Y = L*( (N-1)/N * (Y(:)/(N-1) - 1/2) );

X = X * sqrt(3)/2;

hxv = [0.0 sqrt(3)/2 sqrt(3) sqrt(3) sqrt(3)/2 0.0] - sqrt(3)/2;
hyv = [0.5 0.0       0.5     1.5     2.0       1.5] - 1.0;
IN = inpolygon(X,Y, L*0.5*hxv, L*0.5*hyv);
X = X(IN);
Y = Y(IN);

if itr < mitr
    n = length(X);
    p = randperm(n);
    ind = p(1:m);
    Xo = [];
    Yo = [];
    for i = ind
        c = sqrt(3);
        [Xi,Yi] = step(Nn,Mn,L/N, itr+1,mitr);
        Xo = [Xo; X(i) + c*Yi]; %#ok<AGROW>
        Yo = [Yo; Y(i) + c*Xi]; %#ok<AGROW>
    end

    Xo = [Xo; X(p(m+1:end))];
    Yo = [Yo; Y(p(m+1:end))];
else
    Xo = X(:);
    Yo = Y(:);
end

end