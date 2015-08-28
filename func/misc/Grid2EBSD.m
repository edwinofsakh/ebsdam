function [ebsd_f, ori0, ebsd, ebsd0] = Grid2EBSD(X, Y, S, varargin)
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
%   removeCloseOri - recalc close prior orientations
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
    [ebsd, ori0, ebsd0] = preparePriorGrains(X,Y, prior, varargin{:});
else
    if isempty(prior) || ~isequal(prior,0)
        warning('Bad prior grain data. Generate standard grains.') %#ok<WNTAG>
    end
    ebsd = calcEBSD(uniformODF(symmetry('m-3m'),symmetry('-1')),length(X(:)));
    ebsd = set(ebsd,'x',X(:));
    ebsd = set(ebsd,'y',Y(:));
    ebsd0 = ebsd;
end

if check_option(varargin, 'twoPhase')
    ebsd = set(ebsd,'phaseMap',[1 2]);
    ebsd = set(ebsd,'phase',randi(2, length(ebsd),1));
    ebsd = set(ebsd,'CS',{symmetry('m-3m', 'mineral','Fe'), symmetry('m-3m', 'mineral','Au')});    
else
    ebsd = set(ebsd,'phaseMap',1);
    ebsd = set(ebsd,'phase',ones(length(ebsd),1));
    ebsd = set(ebsd,'CS',symmetry('m-3m', 'mineral','Fe'));
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

if check_option(varargin, 'addProperties')
    ebsd_f = set(ebsd_f,'IQ',rand(length(ebsd_f),1));
    ebsd_f = set(ebsd_f,'CI',0.21*rand(length(ebsd_f),1));
end

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

function [ebsd, ori0, ebsd0] = preparePriorGrains(X,Y, prior, varargin)
%
% X - grains centers
% Y - grains centers
% prior - prior grains map

% Number of prior grains
M = length(prior);

% Symmetry
cs = symmetry('m-3m');
ss = symmetry('-1');

% Random orientation for prior grains
a = 90*degree*rand(M,3);
ori0 = orientation('Euler', a(:,1), a(:,2), a(:,3), cs, ss);

% Remove close prior orientation
rc = get_option(varargin, 'removeCloseOri', 0, 'double');
if (rc ~= 0)
    ori0 = removeCloseOri(ori0, rc);
end

% Debug information
if (isdebug)
    display(ori0);
end

% Get parameters
ORm = get_option(varargin, 'OR',  0, 'double');
dev = get_option(varargin, 'dev', 0, 'double');

% 
a = [];
for i = 1:M
    % Indices of grains 
    oi = find(prior{i});

%     ni = length(oi);

    ori0a(oi) = ori0(i); %#ok<AGROW>
    ori0v = getVariants(ori0(i), inv(ORm), cs);
    ind = randi(24, 1, length(oi));
    o = ori0v(ind);

    ori(oi) = setOriDev(o, dev); %#ok<AGROW>
    a = [a angle(ori(oi).\reshape(o,1,[]))/degree];
end

hist(a);

ebsd0 = EBSD(ori0a,cs,ss);
ebsd0 = set(ebsd0,'x',X(:));
ebsd0 = set(ebsd0,'y',Y(:));

ebsd = EBSD(ori,cs,ss);
ebsd = set(ebsd,'x',X(:));
ebsd = set(ebsd,'y',Y(:));
end


function [ori] = removeCloseOri(ori0, rc)
ori = ori0;

cs = symmetry('m-3m');
ss = symmetry('-1');

for i = 2:length(ori)
    while (angle(ori(1:i-1)\ori(i)) < rc)
        a = 90*degree*rand(1,3);
        ori{i} = orientation('Euler', a(1), a(2), a(3), cs, ss);
    end
end
end