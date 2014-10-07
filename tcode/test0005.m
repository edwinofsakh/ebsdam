% Replaced by OptimizeOR2
% Obsolete
function [M, E1,E2,E3, i,j,k] = test0005(tasks, varargin)

varargin = [varargin tasks];

if check_option(varargin, 'recalc') || check_option(varargin, 'stepping');
    ebsd_f = sel01_load();
    sid = 'sel01';

    region = [
       56.8617  316.2972;
       56.2570  356.8154;
       61.6997  371.9341;
       68.9567  371.3293;
       68.3520  321.1352;
       56.8617  316.2972;
       ];

    % [ op ] = parent4polygon( 'sel01', 2, 1, getOR('B3'), lineXY, 0, 0 );


    in_reg = inpolygon(ebsd_f,region);
    ebsd = ebsd_f(in_reg);

    grains = getGrains(ebsd, 2*degree, 1);

    mori = calcBoundaryMisorientation(grains, 'ext');
    plotAngDist(mori, 60, 0, '', '', '', 'All boundary misorientation' );
end

if check_option(varargin, 'stepping')
    stepOROptim(mori, sid, region, varargin{:});
elseif check_option(varargin, 'recalc')
    bigOROptim(mori, sid, region, varargin{:});
else
    [M, E1,E2,E3, i,j,k] = showOptim(varargin{:});
end
    
    

end



function bigOROptim(mori, sid, region, varargin)
% 'saveAngles'
% 'continue'
% 'fullSearch'
% 'searchRange'
% 'searchRange'
% 'start'
% 'epsilon'

con = check_option(varargin, 'continue');
if (~con)
    ORname = get_option(varargin, 'start', 'KS', 'char');
    ORmat = getOR(ORname);
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    [phi1, Phi, phi2] = Euler(OR);
else
    ORname = 'CON';
    t = get_option(varargin, 'continue');
    phi1 = t(1);
    Phi  = t(2);
    phi2 = t(3);
end

if check_option(varargin, 'firstView')
    kog = getKOG(phi1, Phi, phi2, varargin{:});
    a = close2KOG(mori, kog, 'epsilon', 70*degree);
    figure; hist(a,64);
    return;
end

if check_option(varargin, 'fullSearch')
    da = get_option(varargin, 'fullSearch', 5*degree,'double');
    phi1A = [0:da:pi/2];
    PhiA  = [0:da:pi/2];
    phi2A = [0:da:pi/2];
else
    s  = get_option(varargin, 'searchRange', 10*degree,'double');
    sn = get_option(varargin, 'searchSteps', 10,'double');
    
    if (s > phi1) || (s > Phi) || (s > phi2)
        s = min(fix([phi1 Phi phi2]/degree))*degree;
        warning('Fix working region.');
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
fname = get_option(varargin, 'fname', 'result.mat', 'char');

if check_option(varargin, 'saveAngles')
    save([outdir '\optim\' fname], 'M','A','N','ORname', 'sid', 'region', 'E1', 'E2', 'E3');
else
    save([outdir '\optim\' fname], 'M','N','ORname', 'sid', 'region', 'E1', 'E2', 'E3');
end

end



function stepOROptim(mori, sid, region, varargin)
% 'saveAngles'
% 'continue'
% 'fullSearch'
% 'searchRange'
% 'searchRange'
% 'start'
% 'epsilon'

con = check_option(varargin, 'continue');
if (~con)
    ORname = get_option(varargin, 'start', 'KS', 'char');
    ORmat = getOR(ORname);
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    [phi1, Phi, phi2] = Euler(OR);
else
    ORname = 'CON';
    t = get_option(varargin, 'continue');
    phi1 = t(1);
    Phi  = t(2);
    phi2 = t(3);
end

step = 2*degree;

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
ac
        
flag = 1;
itermax = 2;
iter = 0;
k = 0;

while (flag && k < 1000)
    for i = 1:size(dd,1)
        dx2 = dx1 + dd(i,1)*step;
        dy2 = dy1 + dd(i,2)*step;
        dz2 = dz1 + dd(i,3)*step;
        kog = getKOG(dx2, dy2, dz2, varargin{:});
        a(i) = crit(close2KOG(mori, kog, varargin{:}));
    end
    
%         dx2 = (dx1 + dx*step)';
%         dy2 = (dy1 + dy*step)';
%         dz2 = (dz1 + dz*step)';
%         kog = getKOG(dx2, dy2, dz2, varargin{:});
        
    [am,j] = min(a);
    
    if am < ac
        dx1 = dx1 + dd(j,1)*step;
        dy1 = dy1 + dd(j,2)*step;
        dz1 = dz1 + dd(j,3)*step;
        ac = a(j);
        [dx1/degree dy1/degree dz1/degree ac]
    else
        display('iter');
        if (iter < itermax)
            step = step/2;
            iter = iter+1;
        else
            flag = 0;
        end
    end
    k = k+1;
    if (mod(k, 100) == 1)
        display(k);
    end
end
k
% outdir = getpref('ebsdam','output_dir');
% fname = get_option(varargin, 'fname', 'result.mat', 'char');
% 
% if check_option(varargin, 'saveAngles')
%     save([outdir '\optim\' fname], 'M','A','N','ORname', 'sid', 'region', 'E1', 'E2', 'E3');
% else
%     save([outdir '\optim\' fname], 'M','N','ORname', 'sid', 'region', 'E1', 'E2', 'E3');
% end

end



function [M, E1,E2,E3, i,j,k] = showOptim(varargin)
% 'saveAngles'
% 'cutHigh'

    outdir = getpref('ebsdam','output_dir');
    fname = get_option(varargin, 'fname', 'result.mat', 'char');
    
    if check_option(varargin, 'saveAngles')
        S = load([outdir '\optim\' fname], 'M', 'A', 'N', 'E1', 'E2', 'E3', 'ORname');
    else
        S = load([outdir '\optim\' fname], 'M', 'N', 'E1', 'E2', 'E3', 'ORname');
    end
    
    ORname = S.ORname
    M = S.M;
    N = S.N;
    E1 = S.E1;
    E2 = S.E2;
    E3 = S.E3;
    
    if check_option(varargin, 'saveAngles')
        A = S.A;
%     M = cellfun(@(x) sqrt(sum(x.*x))/length(x), A);
    end
    
%     [Ms,ind] = sort( M(:));
%     ind2 = find(M < Ms(1)*1.05);
    [mM,I] = min( M(:));
    hM = max( M(:));
    [i,j,k] = ind2sub(size(M),I);
    n = size(E1,1);
    
%     for ii = 1:length(i)
%         [E1(i(ii),j(ii),k(ii)), E2(i(ii),j(ii),k(ii)), E3(i(ii),j(ii),k(ii))]/degree
%     end

    
    if check_option(varargin, 'cutHigh')
        M(M > 2*mM) = 2*mM;
    end

    figure;
    slice(E1/degree,E2/degree,E3/degree,M,...
        [E1(1,1,1) E1(1,fix(n/2),1) E1(1,end,1)]/degree,...
        E2(i,1,1)/degree,...
        [E3(1,1,1) E3(1,1,fix(n/2)) E3(1,1,end)]/degree);
    xlabel('phi1'); ylabel('Phi'); zlabel('phi2');
    axis equal;
    
%     figure;
%     slice(E1/degree,E2/degree,E3/degree,M,...
%         E1(1,j,1)/degree,...
%         E2(i,1,1)/degree,...
%         E3(1,1,k)/degree);
%     xlabel('phi1'); ylabel('Phi'); zlabel('phi2');
%     axis equal;
    
    n = size(E1,1);
    xd = repmat(reshape(E1(1,:,1), [1 n])/degree,[n 1]);
    yd = repmat(reshape(E2(:,1,1), [n 1])/degree,[1 n]);
    zd1 = repmat(reshape(E3(1,1,:), [1 n])/degree,[n 1]);
    zd2 = repmat(reshape(E3(1,1,end:-1:1), [1 n])/degree,[n 1]);

    figure;
    slice(E1/degree,E2/degree,E3/degree,M,xd,yd,zd1); hold on;
    slice(E1/degree,E2/degree,E3/degree,M,[],E2(i,1,1)/degree,[]); hold on;
    slice(E1/degree,E2/degree,E3/degree,M,xd,yd,zd2); hold on;
    hold off;
    xlabel('phi1'); ylabel('Phi'); zlabel('phi2');
    axis equal;

    nc = 20;
    v = [mM*1.002 mM*1.01 mM*1.05:(hM-mM)/nc:hM];
    i1 = repmat([1:n]', [n 1]);
    i2 = repmat([1:n],  [n 1]);
    ind = [i2(:),i1,i1];
    ind = sub2ind(size(M), ind(:,1), ind(:,2), ind(:,3));
    M1 = reshape(M(ind), [n n]);
    figure;
    contour(M1,v);
    colormap(hot); colorbar;
    
    ind = [i2(:),i1(end:-1:1),i1];
    ind = sub2ind(size(M), ind(:,1), ind(:,2), ind(:,3));
    M1 = reshape(M(ind), [n n]);
    figure;
    contour(M1,v);
    colormap(hot); colorbar;
    
    figure;
    contour(reshape(M(i,:,:),[n n]),v);
    colormap(hot); colorbar;

%     ii = [1 n];
%     ij = 
%     ik = 
%     Z = M(:,)
%     diag()
%     contour(X,Y,Z,6);
%     [f,v] = isosurface(E1/degree,E2/degree,E3/degree,M,0.078);
%     patch('Faces',f,'Vertices',v)

%     ORname = 'M1';
%     ORmat = getOR(ORname);
%     OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
%     Euler(OR)/degree
%         
%     kog = getKOG(E1(i,j,k), E2(i,j,k), E3(i,j,k));
%     a = angle(kog)/degree;
%     figure;
%     hist(a,64);
%     OR = setOR(E1(i,j,k), E2(i,j,k), E3(i,j,k));
%     figure;
%     plotpdf(OR, Miller(1,0,0), 'antipodal', 'complete');
end

function iv = setInterval(x,dx,n)
    iv = [x-dx:dx/n:x+dx];
end


function c = crit(a)
    c = sqrt(sum(a.*a))/length(a);
end

function OR = setOR(phi1, Phi, phi2, varargin)

CS = symmetry('m-3m');

if check_option(varargin, 'axis')
    v = vector3d(phi1, Phi, phi2);
    OR = orientation('Axis', v, 'Angle', norm(v)*degree, symmetry('m-3m'), symmetry('m-3m'));
else
    OR = orientation('Euler', phi1, Phi, phi2, symmetry('m-3m'), symmetry('m-3m'));
end

end
