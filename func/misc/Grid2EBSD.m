function [ebsd_f, ori0] = Grid2EBSD(X, Y, S, varargin)
% Transform grain grid to EBSD map. 
%
% Syntax
%   [ebsd_f, ori0] = Grid2EBSD(X, Y, S, varargin);
%
% Output
%   ebsd_f  - filled EBSD data
%
% Input
%   [X, Y]	- list of coordinates of grains' centers
%   S       - EBSD filled(rasterisation) parameter
%   ORm     - orientation matrix
%
% Options
%   dev     - angle deviation for prior grains 
%   prior   - prior grains sample information ('in' from gridPriorGrains)
%   crop    - crop EBSD data:
%               'none'      - maximal area
%               'center'    - crop center area
%               'area'      - set area like [minX, maxX, minY, maxY];
%   display - plot mesh
%
% Example
%   ebsd_f = Grid2EBSD(X, Y, 20, getOR(KS), varargin);
%
% See "test\testPriorGrain.m"
%
% History
% 24.11.13  Original implementation
% 20.07.14  Add polygon coordinates for output

ori0 = 0;

% Prepare orientation data
prior = get_option(varargin, 'prior', 0);
if (iscell(prior) && ~isempty(prior))
    [ebsd, ori0] = preparePriorGrains(X,Y, prior, varargin{:});
else
    if isempty(prior) || ~isequal(prior,0)
        warning('Bad prior grain data. Generate standard grains.') %#ok<WNTAG>
    end
    ebsd = calcEBSD(SantaFe,length(X(:)));
    ebsd = set(ebsd,'x',X(:));
    ebsd = set(ebsd,'y',Y(:));
end

% Rotate data
plotx2east;

% Cropping
crop = get_option(varargin, 'crop', 'center');
switch crop
    case 'none'
        warea = [min(X(:)), max(X(:)), min(Y(:)), max(Y(:))];
    case 'center'   
        [warea, cx, cy, s] = getCenterArea(X,Y);
    case 'area'   
        warea = get_option(varargin, 'area', 0,'double');
        if length(warea) ~= 4
        	warning('Bad cropping area. Crop set to "center".'); %#ok<WNTAG>
            warea = getCenterArea(X,Y);
            crop = 'center';
        end
    otherwise
        warning('Bad cropping area. Crop set to "center".'); %#ok<WNTAG>
        warea = getCenterArea(X,Y);
        crop = 'center';
end

% Rotate
omega = get_option(varargin, 'omega', 0, 'double');
if omega > 0 && strcmpi(crop,'center')
    ebsd = rotate(ebsd,omega,'keepEuler');
    c = rotate(vector3d([cx, cy, 0]), axis2quat(0,0,1,omega));
    cx = getx(c); cy = gety(c);
    warea = [cx-s cx+s cy-s cy+s];
else
    if omega > 0
        warning('No rotation.'); %#ok<WNTAG>
    end
end

% Fill EBSD data
ebsd_f = fill(ebsd,warea,1/S);

% Display EBSD map
if check_option(varargin, 'display')
    figure;
    plot(ebsd);

    figure;
    plot(ebsd_f);
end

end


function [warea, cx, cy, s] = getCenterArea(X,Y)

mx = max(max(X));
my = max(max(Y));

s = min([mx my]);

s = s/3;
cx = mx/2; cy = my/2;
warea = [cx-s cx+s cy-s cy+s];

end

function [ebsd, ori0] = preparePriorGrains(X,Y, prior, varargin)

    M = length(prior);

    cs = symmetry('m-3m');
    ss = symmetry('-1');

    a = 90*degree*rand(M,3);
    ori0 = orientation('Euler', a(:,1), a(:,2), a(:,3), cs, ss);
        
    if (isdebug)
        display(ori0);
    end
    
    ORm = get_option(varargin, 'OR',  0, 'double');
    dev = get_option(varargin, 'dev', 0, 'double');

    for i = 1:M
        oi = find(prior{i});
        
        ni = length(oi);
        
        ori0a = getVariants(ori0(i), inv(ORm), cs);
        ind = randi(24, 1, length(oi));
        o = ori0a(ind);
        
        ori(oi) = setOriDev(o, dev);
    end

    ebsd = EBSD(ori,cs,ss);
    ebsd = set(ebsd,'x',X(:));
    ebsd = set(ebsd,'y',Y(:));
end