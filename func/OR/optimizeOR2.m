function [optORm, optOR] = optimizeOR2(mori, sid, rid, varargin)
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
%   'continue', [phi1 Phi phi2] - continue old search starting from angles in radian
%   'firstView'   - only plot distance from KOG histogram
%   'stepSearch'  - stepping method 
%   'freeSearch'  - derivative-free optimization
%   'areaSearch'  - area method
%   'fullSearch', ang  - search in full angle space, use with 'areaSearch', 
%                      set step size 'ang' in degree
%   'searchRange', ang - search range in degree for area method
%   'searchSteps', stp - number of step for area method
%   'saveAngles'  - save array of distance angle to nearset KOG for all misorientations
%   'epsilon'     - distance angle to nearset KOG threshold, should be high
%                       at first iteration, and low at last.
%   'fileName'    - name of file for saving results
%
%   'stepIter'    - [2 1 0.5 0.1]*degree
%   'maxIter'     - 3
%   'epsilon'     - [10 5 5 2]*degree
%
% History
% 12.04.13  Original implementation?
% 05.10.14  Add epsilon array.
% 09.02.15  Move to Linux

% Decide start new search or continue old
if (~check_option(varargin, 'continue'))
    ORname = get_option(varargin, 'start', 'KS');
    ORmat = getOR(ORname);
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    [phi1, Phi, phi2] = Euler(OR);
else
    ORname = 'CON';
    param = get_option(varargin, 'continue');
    
    [phi1, Phi, phi2] = getRegionParams(sid, rid, param );
end

% Only distance to KOG histogram
if check_option(varargin, 'firstView')
    % Preparation
    saveres = getpref('ebsdam','saveResult');
    OutDir = checkDir(sid, 'OR', 1);
    prefix = [sid '_' rid '_OR'];
    comment = getComment();
%     saveimg( saveres, 1, OutDir, prefix, 'opt_dev', 'png', comment);

    % Calculation
    kog = getKOG(phi1, Phi, phi2, varargin{:});
    a = close2KOG(mori, kog, 10*degree);
    
    save(fullfile(OutDir, [prefix 'KOG_dev_data.mat']), 'a');
    
    st = 0.2;
    ed = 0:st:10;
    figure('Name', 'Deviation from KOG'); n = histc(a,ed);
    bar(ed(1:end-1)+st/2,n(1:end-1)/length(mori),'BarWidth',1);
    saveimg( saveres, 1, OutDir, prefix, 'KOG_dev', 'png', comment);
    
    figure('Name', 'Deviation from KOG (cumulative)');
    bar(ed(1:end-1)+st/2,cumsum(n(1:end-1)/length(mori)),'BarWidth',1); ylim([0 1])
    saveimg( saveres, 1, OutDir, prefix, 'KOG_dev_cum', 'png', comment);
    n
%     pause;


    % Prepare results
    optORm = normalizeOR('ori', {phi1, Phi, phi2});
    optOR = [phi1, Phi, phi2]/degree;
    return;
end

% Derivative-free optimization
if check_option(varargin, 'freeSearch')
    [optORm, optOR] = freeOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin{:});
    return;
end

% Start spetting method
if check_option(varargin, 'stepSearch')
    [optORm, optOR] = stepOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin{:});
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
    optOR = Eo/degree;
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

eps = get_option(varargin, 'epsilon', 10*degree, 'double');
    
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
    a = close2KOG(mori, kog, eps);
    M(i) = crit(a);
    N(i) = length(a);
    
    if check_option(varargin, 'saveAngles')
        A{i} = a;
    end
end

outdir = getpref('ebsdam','output_dir');
fname = get_option(varargin, 'fileName', 'result', 'char');

if check_option(varargin, 'saveAngles')
    save(fullfile(outdir, 'optim', [sid '-' rid '_' fname '.mat']), 'M','A','N','ORname', 'sid', 'rid', 'E1', 'E2', 'E3');
else
    save(fullfile(outdir, 'optim', [sid '-' rid '_' fname '.mat']), 'M','N','ORname', 'sid', 'rid', 'E1', 'E2', 'E3');
end

[mM,I] = min( M(:));
[i,j,k] = ind2sub(size(M),I);
Eo = [E1(i,j,k) E2(i,j,k) E3(i,j,k)];
end



function [optORm, optOR] = stepOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin) %#ok<INUSL>
% 'saveAngles'
% 'continue'
% 'fullSearch'
% 'searchRange'
% 'start'
% 'epsilon'

% Preparation
saveres = getpref('ebsdam','saveResult');
OutDir = checkDir(sid, 'OR', 1);
prefix = [sid '_' rid '_OR'];
comment = getComment();

f_rep = get_option(varargin, 'reportFile', 1);

fprintf(1,     'Start optimization\n');
fprintf(f_rep, 'Start optimization\r\n');

stepIter = get_option(varargin, 'stepIter', [ 2 1 0.5 0.1]*degree, 'double');
maxIter  = get_option(varargin,  'maxIter',             3        , 'double');
epsIter  = get_option(varargin,  'epsilon', [10 5   5   4]*degree, 'double');

dd = unique([perms([1 0 0]);perms([1 1 0]); 1 1 1;...
    perms([-1 0 0]);perms([-1 1 0]);perms([-1 -1 0]);...
    perms([-1 1 1]);perms([-1 -1 1]); -1 -1 -1],'rows');

% First iteration
step = stepIter(1);
eps  = epsIter(1);

fprintf(1,    'new iter - step %f in degree, eps - %f in degree\n',   step/degree, eps/degree);
fprintf(f_rep,'new iter - step %f in degree, eps - %f in degree\r\n', step/degree, eps/degree);
            
dx1 = phi1;
dy1 = Phi;
dz1 = phi2;
kog = getKOG(dx1, dy1, dz1, varargin{:});
a   = close2KOG(mori, kog, eps);

figure('Name','Initial IVM deviation'); hist(a,64);
saveimg( saveres, 1, OutDir, prefix, 'dev_initial', 'png', comment);

ac = crit(a);
fprintf(1,    'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\n',   dx1/degree, dy1/degree, dz1/degree, ac, length(a));
fprintf(f_rep,'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\r\n', dx1/degree, dy1/degree, dz1/degree, ac, length(a));
        
flag = 1;
iter = 0;
k = 0;

while (flag && k < 1000)
    a = zeros(1, size(dd,1));
    n = zeros(1, size(dd,1));
    for i = 1:size(dd,1)
        dx2 = dx1 + dd(i,1)*step;
        dy2 = dy1 + dd(i,2)*step;
        dz2 = dz1 + dd(i,3)*step;
        kog = getKOG(dx2, dy2, dz2, varargin{:});
        ang = close2KOG(mori, kog, eps);
        n(i) = length(ang);
        a(i) = crit(ang);
    end
    
    [am,j] = min(a);
    
    if am < ac
        dx1 = dx1 + dd(j,1)*step;
        dy1 = dy1 + dd(j,2)*step;
        dz1 = dz1 + dd(j,3)*step;
        ac = a(j);
        an = n(j);
        fprintf(1,    'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\n',   dx1/degree, dy1/degree, dz1/degree, ac, an);
        fprintf(f_rep,'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\r\n', dx1/degree, dy1/degree, dz1/degree, ac, an);
    else
        if (iter < maxIter)
            iter = iter+1;
            step = stepIter(iter+1);
            eps  = epsIter(iter+1);
            fprintf(1,    'new iter - step %f in degree, eps - %f in degree\n',   step/degree, eps/degree);
            fprintf(f_rep,'new iter - step %f in degree, eps - %f in degree\r\n', step/degree, eps/degree);
        else
            flag = 0;
        end
    end
    k = k+1;
end

fprintf(1,    'Total number of steps - %d\n',   k);
fprintf(f_rep,'Total number of steps - %d\r\n', k);

fprintf(1,    'Final: [%f %f %f]*degree\n',   dx1/degree, dy1/degree, dz1/degree);
fprintf(f_rep,'Final: [%f %f %f]*degree\r\n', dx1/degree, dy1/degree, dz1/degree);

% Plot histogram for best OR
kog = getKOG(dx1, dy1, dz1, varargin{:});
ang = close2KOG(mori, kog, eps);
figure('Name','Final IVM deviation'); hist(ang,64);
saveimg( saveres, 1, OutDir, prefix, 'dev_final', 'png', comment);

% Prepare results
optORm = normalizeOR('ori', {dx1, dy1, dz1});
optOR = [dx1, dy1, dz1]/degree;
end



function [optORm, optOR] = freeOROptim(mori, sid, rid, phi1, Phi, phi2, ORname, varargin) %#ok<INUSL>
% 'saveAngles'
% 'continue'
% 'fullSearch'
% 'searchRange'
% 'start'
% 'epsilon'

% Preparation
saveres = getpref('ebsdam','saveResult');
OutDir = checkDir(sid, 'OR', 1);
prefix = [sid '_' rid '_OR'];
comment = getComment();

f_rep = get_option(varargin, 'reportFile', 1);

fprintf(1,     'Start optimization\n');
fprintf(f_rep, 'Start optimization\r\n');

% stepIter = get_option(varargin, 'stepIter', [ 2 1 0.5 0.1]*degree, 'double');
% maxIter  = get_option(varargin,  'maxIter',             3        , 'double');
epsIter  = get_option(varargin,  'epsilon', [10 5   5   4]*degree, 'double');

% dd = unique([perms([1 0 0]);perms([1 1 0]); 1 1 1;...
%     perms([-1 0 0]);perms([-1 1 0]);perms([-1 -1 0]);...
%     perms([-1 1 1]);perms([-1 -1 1]); -1 -1 -1],'rows');

% First iteration
% step = stepIter(1);
eps  = epsIter(1);

% fprintf(1,    'new iter - step %f in degree, eps - %f in degree\n',   step/degree, eps/degree);
% fprintf(f_rep,'new iter - step %f in degree, eps - %f in degree\r\n', step/degree, eps/degree);
            
dx1 = phi1;
dy1 = Phi;
dz1 = phi2;
kog = getKOG(dx1, dy1, dz1, varargin{:});
a   = close2KOG(mori, kog, eps);

figure('Name','Initial IVM deviation'); hist(a,64);
saveimg( saveres, 1, OutDir, prefix, 'dev_initial', 'png', comment);

ac = crit(a);
fprintf(1,    'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\n',   dx1/degree, dy1/degree, dz1/degree, ac, length(a));
fprintf(f_rep,'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\r\n', dx1/degree, dy1/degree, dz1/degree, ac, length(a));

x0(1) = dx1;
x0(2) = dy1;
x0(3) = dz1;

[x,fval] = fminsearch(@(x)crit(close2KOG(mori, getKOG(x(1),x(2),x(3)), eps)),x0, optimset('Display', 'iter', 'PlotFcns', @optimplotx))

dx1 = x(1);
dy1 = x(2);
dz1 = x(3);

% flag = 1;
% iter = 0;
% k = 0;
% 
% while (flag && k < 1000)
%     a = zeros(1, size(dd,1));
%     n = zeros(1, size(dd,1));
%     for i = 1:size(dd,1)
%         dx2 = dx1 + dd(i,1)*step;
%         dy2 = dy1 + dd(i,2)*step;
%         dz2 = dz1 + dd(i,3)*step;
%         kog = getKOG(dx2, dy2, dz2, varargin{:});
%         ang = close2KOG(mori, kog, eps);
%         n(i) = length(ang);
%         a(i) = crit(ang);
%     end
%     
%     [am,j] = min(a);
%     
%     if am < ac
%         dx1 = dx1 + dd(j,1)*step;
%         dy1 = dy1 + dd(j,2)*step;
%         dz1 = dz1 + dd(j,3)*step;
%         ac = a(j);
%         an = n(j);
%         fprintf(1,    'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\n',   dx1/degree, dy1/degree, dz1/degree, ac, an);
%         fprintf(f_rep,'phi1 = %f; Phi = %f; phi2 = %f; dm = %f; n = %u;\r\n', dx1/degree, dy1/degree, dz1/degree, ac, an);
%     else
%         if (iter < maxIter)
%             iter = iter+1;
%             step = stepIter(iter+1);
%             eps  = epsIter(iter+1);
%             fprintf(1,    'new iter - step %f in degree, eps - %f in degree\n',   step/degree, eps/degree);
%             fprintf(f_rep,'new iter - step %f in degree, eps - %f in degree\r\n', step/degree, eps/degree);
%         else
%             flag = 0;
%         end
%     end
%     k = k+1;
% end
% 
% fprintf(1,    'Total number of steps - %d\n',   k);
% fprintf(f_rep,'Total number of steps - %d\r\n', k);
% 
% fprintf(1,    'Final: [%f %f %f]*degree\n',   dx1/degree, dy1/degree, dz1/degree);
% fprintf(f_rep,'Final: [%f %f %f]*degree\r\n', dx1/degree, dy1/degree, dz1/degree);

% Plot histogram for best OR
% kog = getKOG(dx1, dy1, dz1, varargin{:});
% ang = close2KOG(mori, kog, eps);
% figure('Name','Final IVM deviation'); hist(ang,64);
% saveimg( saveres, 1, OutDir, prefix, 'dev_final', 'png', comment);

plotKOGDeviation(mori, dx1, dy1, dz1, eps, 'Final IVM deviation', 'dev_final', saveres, OutDir, prefix, comment);
    
% Prepare results
optORm = normalizeOR('ori', {dx1, dy1, dz1});
optOR = [dx1, dy1, dz1]/degree;
end


function plotKOGDeviation(mori, phi1, Phi, phi2, eps, title, name, saveres, OutDir, prefix, comment)

    % Plot histogram for best OR
    kog = getKOG(phi1, Phi, phi2);
    ang = close2KOG(mori, kog, eps);
    figure('Name',title); hist(ang,64);
    saveimg( saveres, 1, OutDir, prefix, name, 'png', comment);
end


function iv = setInterval(x,dx,n)
    iv = x-dx:dx/n:x+dx;
end


function c = crit(a)
    c = sqrt(sum(a.*a))/length(a);
end

% function c = crit(a)
%     c = sum(abs(a))/length(a);
% end

function OR = setOR(phi1, Phi, phi2, varargin) %#ok<DEFNU>

CS = symmetry('m-3m'); %#ok<NASGU>

if check_option(varargin, 'axis')
    v = vector3d(phi1, Phi, phi2);
    OR = orientation('Axis', v, 'Angle', norm(v)*degree, symmetry('m-3m'), symmetry('m-3m'));
else
    OR = orientation('Euler', phi1, Phi, phi2, symmetry('m-3m'), symmetry('m-3m'));
end

end
