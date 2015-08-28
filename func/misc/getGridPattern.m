function [ pattern, rmin, n ] = getGridPattern( ebsd, order )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

k = 10;
patterns = cell(1,k);

n = 6*order;

for j = 1:k
    % Get coordinates
    X = get(ebsd, 'X');
    Y = get(ebsd, 'Y');

    % First idea about min radius
    rmin0 = sqrt((X(2)-X(1))^2+(Y(2)-Y(1))^2);
    rmin  = rmin0*order;

    % Get coordinates limits
    mX = min(X);
    mY = min(Y);
    MX = max(X);
    MY = max(Y);

    % Selectgood point
    i = randi(length(X),1);
    while ((X(i) - mX) <= 2*rmin || (Y(i) - mY) <= 2*rmin) || ((MX - X(i)) <= 2*rmin || (MY - Y(i)) <= 2*rmin)
        i = randi(length(X),1);
    end

    % Select square
    iX1 = abs(X-X(i)) <= rmin*1.01;
    iY1 = abs(Y-Y(i)) <= rmin*1.01;
    ind1 = find(iX1&iY1);

    X1 = X(ind1);
    Y1 = Y(ind1);

    % Get distance
    r = sqrt((X1-X(i)).^2+(Y1-Y(i)).^2);
    r1 = ceil(r/rmin0*1000)*rmin0/1000;
    r2 = fix(r1/rmin0*100)*rmin0/100;
    ru = sort(unique(r2));
    rmin = ru(order+1)*1.05;

    % Select circle
    ind2 = r <= rmin;
    ind3 = ind1(ind2);

%     X2 = X(ind3);
%     Y2 = Y(ind3);
% 
%     scatter(X2, Y2);

    patterns{j} = (ind3 - i);
end

% Check patterns
if all(cellfun(@(x) any(x == patterns{1}), patterns))
    pattern = patterns{1};
else
    disp(cell2mat(patterns));
    pattern = unique(cell2mat(patterns));
end
end

