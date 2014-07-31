function optORm = optimizeOR2(mori, sid, rid, varargin)
% Orientation relationship optimization.
%   Optimize orientation relationship in Euler angles space using area or 
%   step method.
%
% Syntax
%   optORm = optimizeOR2(mori, sid, rid, varargin)
%
% Output
%   optORm   - orientation relationship in matrix form
%
% Input
%   mori    - misoreintation for optimization
%   sid     - sample id
%   rid     - region id
%
% Options
%   'start', ORid - start from 'ORid', argument for getOR(ORid), defualt 'KS'
%   'continue', [phi1 Phi phi2] - continue old search starting from angles
%   'firstView'   - only plot distance from KOG histogram
%   'stepSearch'  - stepping method 
%   'areaSearch'  - area method
%   'fullSearch', ang  - search in full angle space, use with 'areaSearch', 
%                      set step size 'ang' in degree
%   'searchRange', ang - search range in degree for area method
%   'searchSteps', stp - number of step for area method
%   'saveAngles'  - save array of distance angle to nearset KOG for all misorientations
%   'epsilon'     - distance angle to nearset KOG threshold
%   'fileName'    - name of file for saving results
%
% History
% 12.04.13  Original implementation

% Decide start new search or continue old
if (~check_option(varargin, 'continue'))
    ORname = get_option(varargin, 'start', 'KS', 'char');
    ORmat = getOR(ORname);
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    [phi1, Phi, phi2] = Euler(OR);
else
    ORname = 'CON';
    param = get_option(varargin, 'continue');
    
    [phi1, Phi, phi2] = getRegionParams( rid, param );
end

% Only distance to KOG histogram
if check_option(varargin, 'firstView')
    kog = getKOG(phi1, Phi, phi2, varargin{:});
    a = close2KOG(mori, kog, 'epsilon', 70*degree);
    figure; hist(a,64);
    pause(2);
    return;
end

% Start spetting method
if check_option(varargin, 'stepSearch')
    optORm = stepOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin{:});
    return;
end

% Start search in area 
if check_option(varargin, 'areaSearch')
    [mM1, Eo, fname] = areaOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin{:});
    if (mM1 == -1)
        return;
    end;
        
    f = 1;
    c = 0;
    while f
        varargin = delete_option(varargin, 'fileName');
        varargin = [varargin 'fileName' [fname '0'] 'continue' Eo]; %#ok<AGROW>
        [mM2, Eo, fname] = areaOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin{:});
        if (mM2 == mM1) && (c == 0)
            varargin = delete_option(varargin, 'searchRange');
            varargin = [varargin 'searchRange' 1*degree]; %#ok<AGROW>
            c = 1;
        else
            f = 0;
        end
        mM1 = mM2;
    end
    optORm = normalizeOR('ori', {Eo});
end

end



function [mM, Eo, fname]  = areaOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin) %#ok<INUSL>
% 'saveAngles'
% 'continue'
% 'fullSearch'
% 'searchRange'
% 'searchRange'
% 'start'
% 'epsilon'

if check_option(varargin, 'fullSearch')
    da = get_option(varargin, 'fullSearch', 5*degree,'double');
    phi1A = 0:da:pi/2;
    PhiA  = 0:da:pi/2;
    phi2A = 0:da:pi/2;
else
    s  = get_option(varargin, 'searchRange', 10*degree,'double');
    sn = get_option(varargin, 'searchSteps', 10,'double');
    
    if (s > phi1) || (s > Phi) || (s > phi2)
        s = min(fix([phi1 Phi phi2]/degree))*degree;
        warning('Fix working region.'); %#ok<WNTAG>
    end
    
    phi1A = setInterval(phi1,s,sn);
    PhiA  = setInterval(Phi ,s,sn);
    phi2A = setInterval(phi2,s,sn);
end

% i1 - Phi, i2 - phi1, i3 - phi2 
[E1,E2,E3] = meshgrid(phi1A, PhiA, phi2A);
M = zeros(size(E1));
N = zeros(size(E1));

if check_option(varargin, 'saveAngles')
    A = cell(size(E1));
end

% % Very slow
% figure;
% OR = setOR(E1,E2,E3, varargin{:});
% plotAllOrientations(OR(:), 'max', 17, 'complete');
    
for i = 1:numel(E1)
    kog = getKOG(E1(i), E2(i), E3(i), varargin{:});
    a = close2KOG(mori, kog, varargin{:});
    M(i) = crit(a);
    N(i) = length(a);
    
    if check_option(varargin, 'saveAngles')
        A{i} = a;
    end
end

outdir = getpref('ebsdam','output_dir');
fname = get_option(varargin, 'fileName', 'result', 'char');

if check_option(varargin, 'saveAngles')
    save([outdir '\optim\' sid '-' rid '_' fname '.mat'], 'M','A','N','ORname', 'sid', 'rid', 'E1', 'E2', 'E3');
else
    save([outdir '\optim\' sid '-' rid '_' fname '.mat'], 'M','N','ORname', 'sid', 'rid', 'E1', 'E2', 'E3');
end

[mM,I] = min( M(:));
[i,j,k] = ind2sub(size(M),I);
Eo = [E1(i,j,k) E2(i,j,k) E3(i,j,k)];
end



function [optORm] = stepOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin) %#ok<INUSL>
% 'saveAngles'
% 'continue'
% 'fullSearch'
% 'searchRange'
% 'start'
% 'epsilon'

stepIter = get_option(varargin, 'stepIter', [2 0.5 0.1]*degree, 'double');
maxIter = get_option(varargin, 'maxIter', 2, 'double');

step = stepIter(1);

% dx = [ 1 -1  0  0  0  0  1 -1 -1 1];
% dy = [ 0  0  1 -1  0  0  1  1  1 1];
% dz = [ 0  0  0  0  1 -1  0  0];
dd = unique([perms([1 0 0]);perms([1 1 0]); 1 1 1;...
    perms([-1 0 0]);perms([-1 1 0]);perms([-1 -1 0]);...
    perms([-1 1 1]);perms([-1 -1 1]); -1 -1 -1],'rows');

dx1 = phi1;
dy1 = Phi;
dz1 = phi2;
kog = getKOG(dx1, dy1, dz1, varargin{:});
ac = crit(close2KOG(mori, kog, varargin{:}));
fprintf(1,'phi1 = %f; Phi = %f; phi2 = %f; dm = %f;\n', dx1/degree, dy1/degree, dz1/degree, ac);
        
flag = 1;
iter = 0;
k = 0;

while (flag && k < 1000)
    a = zeros(1, size(dd,1));
    for i = 1:size(dd,1)
        dx2 = dx1 + dd(i,1)*step;
        dy2 = dy1 + dd(i,2)*step;
        dz2 = dz1 + dd(i,3)*step;
        kog = getKOG(dx2, dy2, dz2, varargin{:});
        a(i) = crit(close2KOG(mori, kog, varargin{:}));
    end
    
    [am,j] = min(a);
    
    if am < ac
        dx1 = dx1 + dd(j,1)*step;
        dy1 = dy1 + dd(j,2)*step;
        dz1 = dz1 + dd(j,3)*step;
        ac = a(j);
%         [dx1/degree dy1/degree dz1/degree ac] %#ok<NOPRT>
        fprintf(1,'phi1 = %f; Phi = %f; phi2 = %f; dm = %f;\n', dx1/degree, dy1/degree, dz1/degree, ac);
    else
        if (iter < maxIter)
            iter = iter+1;
            step = stepIter(iter+1);
            fprintf(1,'new iter - step %f in degree\n', step/degree);
        else
            flag = 0;
        end
    end
    k = k+1;
%     if (mod(k, 10) == 1)
%         fprintf(1,'.');
%     end
end

fprintf(1,'Total number of steps - %d\n', k);

% fprintf(1,'%s-%s\n phi1 Phi phi2\n %d %d %d %d', sid, rid, dx1/degree, dy1/degree, dz1/degree, ac);

optORm = normalizeOR('ori', {dx1, dy1, dz1});
end



function iv = setInterval(x,dx,n)
    iv = x-dx:dx/n:x+dx;
end


function c = crit(a)
    c = sqrt(sum(a.*a))/length(a);
end

function OR = setOR(phi1, Phi, phi2, varargin) %#ok<DEFNU>

CS = symmetry('m-3m'); %#ok<NASGU>

if check_option(varargin, 'axis')
    v = vector3d(phi1, Phi, phi2);
    OR = orientation('Axis', v, 'Angle', norm(v)*degree, symmetry('m-3m'), symmetry('m-3m'));
else
    OR = orientation('Euler', phi1, Phi, phi2, symmetry('m-3m'), symmetry('m-3m'));
end

end
