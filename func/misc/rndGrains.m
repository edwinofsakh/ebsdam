function [X, Y] = rndGrains(N, M, S, varargin)
%
% N - grains in line, N*N number of grains
% xscale - x scale
% yshift - y scale
%
% Options
% dev    - random deviation
% display - plot mesh
%
% For HexGrid     - sqrt(3)/2, 0.5
% For SquareGrid  -       1.0, 0.0
% For RhombusGrid -       0.5, 0.5

% Generate random grid
X = N*rand(1,M);
Y = N*rand(1,M);

% Random shift
dev = get_option(varargin, 'dev', 0, 'double');
if (dev > 0)
    ind = randi(M,1,fix(13/14*M));
    ind = unique(ind);
    X = [X, X(ind) + dev*(1-2*rand(1,length(ind))), X(ind) + dev*(1-2*rand(1,length(ind)))];
    Y = [Y, Y(ind) + dev*(1-2*rand(1,length(ind))), Y(ind) + dev*(1-2*rand(1,length(ind)))];
end

% % Remove close points
%  dt = DelaunayTri(X,Y);
%   e = edges(dt);
%   R = sqrt((X(e(:,1))-X(e(:,2))).^2 + (Y(e(:,1))-Y(e(:,2))).^2);
%   c = find(R < 1/S);
% ind = ones(1,length(X(:)));
% ind(e(c,1)) = 0; %#ok<FNDSB>
% X = X(logical(ind));
% Y = Y(logical(ind));

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
