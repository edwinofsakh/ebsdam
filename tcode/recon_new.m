function [ grains_au ] = recon_new( grains_fe, ORname, Nv, v, w0, w1)
%recon Reconstructe austenite grains
%   Reconstructe austenite grains useing method from:
%       L.Germain. An advanced approach to reconstructing parent 
%       orientation maps in the case of approximate orientation relations: 
%       Application to steels
%
% Inputs
%   grains_fe   - grains of Ferrit phase
%   ORname      - useing orientation relation
%   Nv          - count number or grains with >=Nv neigbours and <Nv
%   v           - ???
%   w0          - variant misorientation angle limit
%   w1          - ???
%
% History
% 01.04.13  Find error in 'getOR', it's return matrix from alpha to gamma.

% Mean orientation of grains
o = get(grains_fe, 'mean');

% Pairs of grains
[~, pairs] = neighbors(grains_fe);

% Misorientation between grains
m = getMis (o, pairs);

% Number of grains
n = numel(grains_fe);

% Number of pairs
n2 = length(pairs);

% In which fragment is grains
inFragment = cell(1,n);

% Orientation relation
OR = getOR (ORname); % alpha to gamma
OR = OR^-1; % old code
OR = OR;

% Symmetry
CS = symmetry('m-3m');
SS = symmetry('1');

c1 = 0;
c2 = 0;
PP = [];
for i = 1:12
    A = inFragment{i};
    if (isempty (A))
        neighbour = getNeighbors(i, pairs);
        
        if (length(neighbour) < Nv)
            c1 = c1 + 1;
        else
            c2 = c2 + 1;
        end
        
        % inFragment = findFragment (o, i, neighbour, inFragment);
        id = cat(1, i,neighbour);
        od = o(id);
        [a,b,~] = findUniqueParent(od, OR, CS, SS, w0);
        PP = cat(1,PP,[a,b]);
    end
end

PP
display([num2str(c1) '/' num2str(c2) '/' num2str(n)]);

grains_au = 0;
end

function [inFragment1] = findFragment(o, i, neighbour, inFragment0)
%findFragment 
%
v = getVariants(o, OR, Sym);
o0 = o(i);
oi = o(neighbour);

end

function [v, ind] = getVariants(r, OR, CS)
%
%

% % Set misorientation
% mis = orientation('matrix', OR, SS, CS);
% 
% % Get all variants of misorientation
% mis_v = symmetrise(mis);
% 
% % All variants
% v = mis_v*o;
% ind = repmat([1:length(o)],length(mis_v),1);

% Set misorientation
mis = rotation('matrix', OR);
ORr = mis;

% % All variants
% v = CS*mis*CS*r;
% v1 = CS*mis*CS*r(1);
% v2 = CS*mis*CS*r(2);
% v3 = CS*mis*CS*r(3);
% ind = repmat([1:length(r)],size(v,1),1);

% Some variants
v = r*CS*ORr;
v = orientation(v,get(r,'CS'),get(r,'SS'));
ind = repmat([1:length(r)],1,size(CS,1))'; % ???

end

function [Pmax, PR, oup] = findUniqueParent(od, OR, CS, SS, w0)
%
% od - orienation of domains
% OR - orientation relation
% CS - crystal symmetry
% w0 - tolerance (in radian)

% Array of potential parent orienations and link with domains
% o = od(1);
% od = rotation(od);
% o = od;
[op, ind] = getVariants(od, OR, CS);

a = unique(op);

% figure
% plot(o, 'antipodal', 'MarkerSize', 4, 'complete', 'grid');
% hold all
% plot(op, 'antipodal', 'MarkerSize', 4, 'complete', 'grid');
% hold off
% 
% figure
% plot(o, 'antipodal', 'AXISANGLE', 'center');
% hold all
% plot(op, 'antipodal', 'AXISANGLE', 'center');
% hold off
% 
% % plotpdf(o, Miller(1,0,0), 'antipodal', 'MarkerSize', 4, 'complete', 'grid');
% % hold all
% % plotpdf(op, Miller(1,0,0), 'antipodal', 'MarkerSize', 4, 'complete', 'grid');
% % hold off

% Number of domains
nd = length(od);

% Number of potential parents
np = numel(op);

% Probability of potential parents 
P = zeros(1,np);

% % Browse all pairs of parents
% for i = 1:np
%     for j = [1:i-1 i+1:np]
%         
%         t = abs(angle(op(i),op(j)));
%         if (abs(angle(op(i),op(j))) < w0)
%             P(ind(i)) = P(ind(i)) + 1;
%         end
%     end
% end

% Number of misorientations between OR variants with misorientation angle 
% less then w0. Allways there is one misorientation V1/V1. 
ORr = rotation('matrix', OR);
mv = sum(angle(inverse(ORr)*(CS*ORr)) < w0);

mm = angle(op\op)/degree;
Pp = sum(mm < w0/degree) - mv;
[Ps,IX] = sort(Pp,'descend');

oup = op(IX(1));
Pmax = Ps(1);
PR = Ps(1)/Ps(2);

fprintf(1,'%d-%3.1f\n', Pmax, PR);

%[row,col] = find((mm < w0/degree).*(tril(ones(np,np),-1)));

%P = P/nd;

%[P,IX] = sort(P,'descend');

%Pmax = P(1);
%PR = P(1)/P(2);
%Imax = IX(1);
%hold all
%plot(op(Imax), 'RODRIGUES')
%hold off
end