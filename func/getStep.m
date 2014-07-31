function [ dx, dy, nx, ny, sx, sy ] = getStep( ebsd )
% Get X and Y steps in ESBD data
%
% Syntax
% 	[ dx, dy, nx, ny, sx, sy ] = getStep( ebsd )
%
% Output
%   dx - step of point in X direction
%   dy - step of point in Y direction
%   nx - number of point in X direction
%   ny - number of point in Y direction
%   sx - size of point in X direction
%   sy - size of point in Y direction
%
% Input
%   ebsd - EBSD data
%
% History
% 07.12.12  Add decsription of the function.
% 16.04.13  Function gives uncorrect results on hexagonal grid. Try to fix.
%           For hex grid give other results, not same with 'unitCell'.

% Get coordinate
X = get(ebsd, 'X'); Y = get(ebsd, 'Y');

% Find max
maxx = max(X); maxy = max(Y);

% Find min
minx = min(X); miny = min(Y);

% Find size
sx = maxx - minx; sy = maxy - miny;

% Get unique coordinate
uX = unique(X);
uY = unique(Y);

% % Find step
% dx = uX(2) - uX(1);
% dy = uY(2) - uY(1);

% Find number of points 
nx = length(uX); ny = length(uY);

% % Check calucation
% c = sx - (nx-1)*dx
% c = sy - (ny-1)*dy

% Cell area
switch (length(get(ebsd, 'unitCell')))
    case 6
        % Find good dimension
        if (X(1) ~= X(2))
            A = X; B = Y;
        else
            A = Y; B = X;
        end

        % Find step in first dimension
        d1 = abs(A(2) - A(1));

        % Find step in second dimension
        ind = find(A == A(1), 2, 'first');
        d2 = abs(B(ind(2))-B(1));

        % Try to find step in first dimension
        if (X(1) ~= X(2))
            dx = d1; dy = d2/2;
        else
            dx = d2; dy = d1/2;
        end
    case 4
        % Find step
        dx = uX(2) - uX(1);
        dy = uY(2) - uY(1);
    otherwise
        error('Unknown grid type!');
end

end

