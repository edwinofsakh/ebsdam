function [ ags, r ] = grSizeSec( fname, n, upp, varargin )
%Find grain size by secant method.
%   Find grain size on grain map by secant method. Image must be prepared.
%   Image must be Black&White. Function detect change in intensity along 
%   line.
%   Use Image Processing ToolBox.
%
% Syntax
%   [ ags ] = grSizeSec( fname, n, upp, varargin )
%
% Output
%   ags - average(nominal) grain size
%
% Input
%   fname   - image file name
%   n       - number of secants
%   upp     - micron per pixles (image scale)
%
% Options
%   'display'   - display secants
%   'crop'      - crop white fields
%
% History
% 13.12.12 Original implementation
% 14.03.13 Add displaying of lines.
%          Increase number of possible places of starting point, set slope 
%           of the line as ratio of random variables.
% 14.05.13 Remove white fields, if 'crop' is set.

% Read prepared image
I = imread(fname);
I = rgb2gray(I);

if check_option(varargin,'crop')
    [I, upp] = mycrop(I, upp);
end

% Display lines
if check_option(varargin,'display')
    pl = 1;
    imshow(I); hold on;
else
    pl = 0;
end

[sx, sy] = size(I);

% Total counts of intersection and total secants length
c = 0;
l = 0;

if ~check_option(varargin,'grid')
    disp('Random intersect!');
    % Random
    for i = 1:n
        % Random parameters of secants
        %k = tan(rand()*pi - pi/2);  % k from -p/2 to p/2
        k = (2*rand()-1)/(2*rand()-1);
        x0 = fix(sx/24+rand()*22*sx/24); % x0 from sx/24 to 23/24*sx
        y0 = fix(sy/24+rand()*22*sy/24); % y0 from sy/24 to 23/24*sy

        % Forward
        [c1, l1] = goLine( I, x0, y0, k, +1, sx,sy, pl);
        % Backward
        [c2, l2] = goLine( I, x0, y0, k, -1, sx,sy, pl);

        % Incrise counters
        c = c + c1 + c2 - 1;
%         l = l + (l1 + l2)/2; % l1 = l2 it's a one line
        l = l + l1 + l2; % l1 = l2 it's a one line

    end
    d = l/c;
else
    % Grid
    sp = 5; % spaceing from boundary
    cx = 0; cy = 0; % counts of boundary
    lx = 0; ly = 0; % line length
    
%     for i = 1:n+1
%         [cx, lx] = lineGrid(I, [sp sp], [1 0], [sx sy], sp, i,n, cx,lx, pl);
%         [cy, ly] = lineGrid(I, [sp sp], [0 1], [sx sy], sp, i,n, cy,ly, pl);
%     end
    
    c = cx+cy;
    l = lx+ly;
    
    [d, bt] = lineGrid2(I, sx,sy,sp, n, varargin{:});
end;

% Display lines
if pl
    hold off;
    %axis([0 sx 0 sy])
end

% Average grain size like average length between intersection in pixel
ags = l/c;
ags = d;

% Scale to micron
ags = ags*upp;

if ~check_option(varargin,'grid')
    r = 1;
else
    r = (lx/cx)/(ly/cy);
end
end


function [c, l, xp,yp] = goLine( I, x0, y0, k, s, sx, sy, plotLine)
% Count intersection along line going in one way from (x0,y0)
%
% Syntax
% [c, l] = goLine( I, x0, y0, k, s, sx, sy)
%
% Output
%   c - counter of intersection (one grain = one interesection)
%   l - length of line
%
% Input
%   I       - image
%   x0,y0,k - secant parameters
%   s       - step forward (-) or backward (-1)
%   sx      - x size (width)
%   sy      - y size (height)
%   plotLine- plot current line for debugging

c = 0;
x = x0; xp = x;
y = y0; yp = y;
iv0 = I(x0,y0);

% Calculate line length
l = getLineLength(x0, y0, k, sx, sy, plotLine);

% Go along line while in image region
while ((x > 1 && x < sx-1) && (y > 1 && y < sy-1))
    
    if ((k < 1) && (k > -1))
        % Follow X
        x = x + s;
        y = fix(k*(x-x0) + y0);
    else
        % Follow Y
        y = y + s;
        x = fix((y-y0)/k + x0);
    end

    % Find changing of intensity
    iv1 = I(x,y);
    ll = sqrt((x-xp)^2+(y-yp)^2);

    if (iv0 ~= iv1 && ll > 4)
        c = c + 1;
        iv0 = iv1;
        xp = x;
        yp = y;
    end
end

% Halve counter because boundary have two change of intensity
c = c/2; % ??? maybe add 1 for region boundary affect

ll = sqrt((x0-xp)^2+(y0-yp)^2);
l = ll;

end

function [l] = getLineLength(x0, y0, k, sx, sy, plotLine)
% Get line length in working region by equation. Calculate possible points 
% of intersection with region. Find two real point. Get length.
%
% Syntax
%   [l] = getLineLength(x0, y0, k, sx, sy)
%
% Output
%   l - length of line
%
% Input
%   x0,y0,k - line parameters
%   sx, sy  - width and height of region
%   plotLine- plot current line for debugging

% Remove extreme variant
if k == 0;
    l = sx;
else
    % Possible points of intersection with region
    p = {
        [ 0, k*(0-x0)+y0 ],...
        [sx, k*(sx-x0)+y0],...
        [  (-y0)/k+x0,  0],...
        [(sy-y0)/k+x0, sy],...
    };

    % Find points in region
    in = zeros(1,4);
    for i=1:4
        pp = p{i};
        if (p{i}(1) >= 0 && p{i}(1) <= sx)
            in(i) = in(i) + 1;
        end
        if (p{i}(2) >= 0 && p{i}(2) <= sy)
            in(i) = in(i) + 1;
        end
    end
    
    % Find good points' index and check that it's only two points
    ind = find(in == 2);
    if (length(ind) ~= 2)
        error('Too many line intersection');
    end
    
    % Calculate length
    l = p{ind(1)}-p{ind(2)};
    l = sqrt(sum(l.*l));

    % Display line
    if (plotLine == 1)
        p1 = p{ind(1)};
        p2 = p{ind(2)};
        plot([p1(1), p2(1)], [p1(2), p2(2)]);
        hold on;
    end
end

end



function [c, l] = lineGrid(I, xy0, dr, sz, sp, i, n, c,l, pl)
% I - image
% xy0 - spaces from boundary
% dr - direction [1 0] - x, [0 1] - y
% sz - size of area
% sp - spaces
% i - number of line
% n - total amount of lines
% c - counts of boundaries
% l - line length
% pl - display or not

cc = 0;
c1 = 0; % current number of boundary

szn = sz - 2*sp;

iv0 = I(xy0(1),xy0(2));

xy0 = xy0 + fix((i-1)*szn/n).*~dr;
xy = xy0;
for k = 0:sum(szn.*dr)
    xy = xy + dr;

    iv1 = I(xy(1),xy(2));
    if (iv0 ~= iv1)
        c1 = c1 + 1;
        iv0 = iv1;
        
        if cc == 0
            xys = xy;
            cc = 1;
        end
        
        xye = xy;
    end
end
if c1 < 2
%     l = l + sum(xy-xy0);
%     c1 = 1;
    l = l + 0;
    c1 = 0;    
else
    l = l + sum(xye-xys);
end

if (pl)
    XY = [xy0;xy];
    line(XY(:,1),XY(:,2));
    hold on;
    scatter(xys(1),xys(2),4,'g', 'filled');
    hold on;
    scatter(xye(1),xye(2),4,'r', 'filled');
    hold on;
end

c = c + c1/2-1;
end



function [d, r, bad] = lineGrid2(I, sx,sy,sp, n, varargin)

cxt = 0; cyt = 0; % count of intersect
lxt = 0; lyt = 0; % length of lines
bxt = 0; byt = 0;% number of bad line

for i = 1:n
    [x,y] = getLineCor(sx,sy,sp, i,n, varargin{:});
    [c,l,b] = countIntersect(I, x,y);
    cxt = cxt+c; lxt = lxt+l; bxt = bxt+b;
    if (check_option(varargin,'display'))
        line(x,y);
        hold on;
    end

    [y,x] = getLineCor(sy,sx,sp, i,n, varargin{:});
    [c,l,bad] = countIntersect(I, x,y);
    cyt = cyt+c; lyt = lyt+l; byt = byt+b;
    if (check_option(varargin,'display'))
        line(x,y);
        hold on;
    end
end

d = (lxt+lyt)/(cxt+cyt);
r = (lxt/cxt)/(lyt/cyt);
bad = bxt+byt;
end



function [x1,x2] = getLineCor(s1,s2,sp,i,n,varargin)

x1 = [sp:s1-sp];
x2 = sp + fix((s2-2*sp)/(n-1)*(i-1));
x2 = repmat(x2,1,length(x1));

end



function [c,l,bad] = countIntersect(I, x,y)
% I - image
% x,y - array of coordinates

if (length(x) ~= length(y))
    warning('Intersect Method. Bad length of x,y.'); %#ok<WNTAG>
end

t = sub2ind(size(I), x, y);
D = I(t);

is = find(D == 0, 1, 'first');
ie = find(D == 0, 1, 'last');
l = sqrt((x(ie)-x(is))^2+(y(ie)-y(is))^2);

n = length(D);
Ds = [D(2:n), D(1)];
b = xor(D,Ds);
ind = find(b);
% ln = ind(3:end)-ind(1:end-2);
c = length(ind);
% if (any(ln < 8))
%    c = c - sum(ln < 8)/2; 
% end
c = c/2 - 1;
bad = 0;

if c < 1
    c = 0;
    l = 0;
    bad = 1;
end

end



function [J, upp] = mycrop(I, upp)
% Find image box and crop white margins.

% Get source image size
[sx, sy] = size(I);

% Start scanning point until meet black point. Scan from two direction in
% center coordinates.
i = {1:sx,      fix(sx/2) };
j = {fix(sy/2), 1:sy,     };
l = [0,0;0,0];

for t = 1:2
    D = I(i{t},j{t});
    l(t,1) = find(D == 0, 1, 'first');
    l(t,2) = find(D == 0, 1, 'last');
end

ys = l(1,1);    ye = l(1,2);
xs = l(2,1);    xe = l(2,2);

J = imcrop(I, [xs ys xe-xs ye-ys]);

uppx = upp(1)/(xe-xs);
uppy = upp(2)/(ye-ys);

if ( (uppx / uppy > 1.1) || (uppx / uppy < 1/1.1))
    error('BAD upp');
end
upp = (uppx + uppy)/2;

end