function [M, E1,E2,E3, i,j,k] = showOptim(varargin)
% Show result of Orientation Relationship (OR) optimization in area.
%
% Syntax
%   [M, E1,E2,E3, i,j,k] = showOptim('fname', 'result01.mat')
%
% Output
%   M           - distance between misorientation and KOG, matrix NxNxN
%   E1,E2,E3    - phi1, Phi, phi2 Euler angles from examined ORs
%   i,j,k       - indices of optimal OR
%
% Options
%   'fname'         - name of file with results
%   'loadAngles'    - load array of all distances
%   'cutHigh'       - cut high distance for best view of small distance
%   'optSet'        - view set of optimal Or with close distance
%
% History
% 09.04.14  Recomment
% 09.02.15 Move to Linux

outdir = getpref('ebsdam','output_dir');
fname = get_option(varargin, 'fname', 'result.mat', 'char');

if check_option(varargin, 'loadAngles')
    S = load(fullfile(outdir, 'optim', fname), 'M', 'A', 'N', 'E1', 'E2', 'E3', 'ORname');
else
    S = load(fullfile(outdir, 'optim', fname), 'M', 'N', 'E1', 'E2', 'E3', 'ORname');
end

ORname = S.ORname; %#ok<NASGU>
M = S.M;
N = S.N; %#ok<NASGU>
E1 = S.E1;
E2 = S.E2;
E3 = S.E3;

if check_option(varargin, 'loadAngles')
    A = S.A;
    crit = get_option(varargin, 'closeness', 'sqrt');
    M = cellfun(@(x) IVM_closeness(x, 'type', crit), A);
end

% <<<!!! Rewrite witout testing
% Find set of optimal OR with close distance
if check_option(varargin, 'optSet')
    [Ms,ind] = sort( M(:));
    ind2 = find(M < Ms(1)*1.05);
    for ii = 1:length(ind2)
        [E1(ind(ind2(ii))), E2(ind(ind2(ii))), E3(ind(ind2(ii)))]/degree
    end
end
% !!!>>> Rewrite witout testing

% Find optimal OR
[mM,I] = min( M(:));
hM = max( M(:));
[i,j,k] = ind2sub(size(M),I);
n = size(E1,1);

[i,j,k]
[E1(i,j,k) E2(i,j,k) E3(i,j,k)]/degree

% Cut high distance
if check_option(varargin, 'cutHigh')
    M(M > 2*mM) = 2*mM;
end

% hist(A{i,j,k},64);

% Boundary slide and optimal slide
figure('Name', 'Optimal slides');
slice(E1/degree,E2/degree,E3/degree,M,...
    [E1(1,1,1) E1(i,j,k) E1(1,end,1)]/degree,...
    E2(i,j,k)/degree,...
    [E3(1,1,1) E3(i,j,k) E3(1,1,end)]/degree);
xlabel('phi1'); ylabel('Phi'); zlabel('phi2');
axis equal;

% Calculate derivation and plot it
n = size(E1,1);
xd = repmat(reshape(E1(1,:,1), [1 n])/degree,[n 1]);
yd = repmat(reshape(E2(:,1,1), [n 1])/degree,[1 n]);
zd1 = repmat(reshape(E3(1,1,:), [1 n])/degree,[n 1]);
zd2 = repmat(reshape(E3(1,1,end:-1:1), [1 n])/degree,[n 1]);

figure('Name', 'Regulat slides');;
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
figure('Name', 'Some contour 01');
contour(M1,v);
colormap(hot); colorbar;

ind = [i2(:),i1(end:-1:1),i1];
ind = sub2ind(size(M), ind(:,1), ind(:,2), ind(:,3));
M1 = reshape(M(ind), [n n]);
figure('Name', 'Some contour 02');
contour(M1,v);
colormap(hot); colorbar;

figure('Name', 'Some contour 03');
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