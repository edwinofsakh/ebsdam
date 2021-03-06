function [X, Y, in, in_xy, in0, in0_xy] = gridPriorGrains(N, Np, xscale, yshift, varargin)
% Generate list of coordinates of grains' centers.
%   1. Create map of product grains.
%   2. Create boundary of parent grains.
%   3. Find product grains inside parent boundary.
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
% 02.03.15  Add grains bourdaries coordinates output

%% Product grains
% Generate poor grid and transform it to hex (or other)
a = 2;
[X, Y] = meshgrid(0-a:1:N-1+a);
[X, Y] = transformGrid(X, Y, xscale, yshift);

% Save indices of interesting points
ini = inpolygon(X,Y,[0 0 N*xscale N*xscale],[0 (N-1) (N-1) 0]);

% Reorder
X = X(:);
Y = Y(:);

% Random shift
dev = get_option(varargin, 'dev', 0, 'double');
if (dev > 0)
    n = length(X);
    X = X + dev*(1-2*rand(n,1));
    Y = Y + dev*(1-2*rand(n,1));
end

% Calc boundaries of grains
[v0,c0] = voronoin([X(:), Y(:)]); 


% in = inpolygon(X,Y,[0 0 N*xscale N*xscale],[0 (N-1) (N-1) 0]);
% Get interesting points after shifting
Xi = X(ini);
Yi = Y(ini);

% Catch grains
in0 = cell(1,length(c0));
in0_xy = cell(1,length(c0));
for i = 1:length(c0)
    if all(c0{i}~=1)
        ind = inpolygon(Xi,Yi,v0(c0{i},1),v0(c0{i},2));
        if any(ind)
            in0{i} = ind;
            in0_xy{i} = [v0(c0{i},1),v0(c0{i},2)];
%             hold on; scatter(X(in0{i}), Y(in0{i}),5,'r','filled');
%             patch(v0(c0{i},1),v0(c0{i},2),'r');
        end
    end
end
ind = cellfun(@length, in0);
in0 = in0(ind > 0);
in0_xy = in0_xy(ind > 0);


%% Prior Grain
% Generate grid
[Xp, Yp] = meshgrid(-1:1:Np);
Xp = (Xp/(Np-1)*1.1-0.05)*(N-1);
Yp = (Yp/(Np-1)*1.1-0.05)*(N-1);

[Xp, Yp] = transformGrid(Xp, Yp, xscale, yshift*((N-1)/(Np-1)));

[v,c] = voronoin([Xp(:), Yp(:)]); 

% Debug information
% figure;
% for i = 1:length(c) 
%     hold on; patch(v(c{i},1),v(c{i},2),'w');
%     hold on; scatter(Xp(i), Yp(i),5,'k');
% end
% hold off;

% Catch product grains
in = cell(1,length(c));
in_xy = cell(1,length(c));
for i = 1:length(c)
    if all(c{i}~=1)
        ind = inpolygon(X,Y,v(c{i},1),v(c{i},2));
        if any(ind)
            in{i} = ind;
            in_xy{i} = [v(c{i},1),v(c{i},2)];
%             hold on; scatter(X(in{i}), Y(in{i}),5,'r','filled');
        end
    end
end
ind = cellfun(@length, in);
in = in(ind > 0);
in_xy = in_xy(ind > 0);


%% Plotting
% Plot the mesh, including cell borders
if check_option(varargin, 'display')
    figure;
    [vx,vy] = voronoi(X(:),Y(:));
    patch(vx,vy,'k');
    
    [vxp,vyp] = voronoi(Xp(:),Yp(:));
    hold on; patch(vxp,vyp,'r');
    
    axis equal;
    axis([min(min(X)) max(max(X)) min(min(Y)) max(max(Y))]), zoom on;
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