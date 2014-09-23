function [Pmax, PR, opf, gind, op, vnum] = findUniqueParent(ori0, wf0, ORmat, thr, Nv, w0, PRmin, varargin)
% Find unique parent for orientations.
%   Close orientations with misorientation less than 'thr' will be 
%   combined in group for reduce the amount of calculation. For group 
%   calculate possible parents.
%
% Syntax
%   [Pmax, PR, opf, gind, op, vnum] = findUniqueParent(ori0, wf0, ORmat, thr, Nv, w0, PRmin, varargin)
%
% Output
%   Pmax    - maximal parent probability
%   PR      - first to second probability ratio
%   opf     - orientation of unique parent, 0 if not find
%   gind    - indices of grains in current fragment
%   op      - orientation of parents
%   vnum    - indices of varinats
% 
% Input
%   ori0    - set of orienations
%   wf0     - wiegth function
%   ORmat   - orientation relation matrix (from alpha to gamma)
%   thr     - orientation integration threshold in radian
%   Nv      - minimal number of variant
%   w0      - tolerance (in radian)
%   PRmin   - minimal probability ratio
%
% Options
%   'onlyFirst'     - check only parents of first child (usefull if all 
%                   	grains will be checked).
%   'combineClose'  - combine close orientations
%   'useWeightFunc' - use weight function
% 
% History
% 17.04.13  Change 'ORname' to 'ORmat'. Fix comments.
% 28.07.14  Add 'varargin'. Add options 'onlyFirst', 'combineClose'. Some
%           makeups.
% 04.08.14? Rewrite CheckParents, now it find the best parent.


%% Preparation
Pmax = 0;
PR   = 0;
opf  = 0;
gind = 0;
op   = 0;
vnum = 0;

VNmin = Nv;

% Normalize weight function
wf0  = wf0/sum(wf0);

% Check number of variants. Now only number of domains.
n0 = length(ori0);
if n0 < Nv
    dprintf(1,'Too few variants\n'); return;
end

% Group close orientation
if check_option(varargin, 'combineClose')
    [ori, gc, gi] = closeOrientation(ori0, n0, thr);
    n = length(ori);
    dprintf(1,['Number of orientation was changed from ' int2str(n0) ' to ' int2str(n) ' \n']);
else
    ori = ori0;             % orientations of groups
    gc  = ones(1,n0);       % number of orientations in group
    gi  = num2cell(1:n0);   % indices of orietations in group
    n   = n0;               % number of groups
end

% Use weight function
if check_option(varargin, 'useWeightFunc')
    wf = cellfun(@(x) sum(wf0(x)), gi);
    Pmin = Nv/length(wf);
else
    wf = gc;
    Pmin = Nv;
end

% Check number of variants again
if n < Nv
    dprintf(1,'Too few variants\n'); return;
end

% Crystall symmetry
CS = get(ori,'CS');
nv = length(CS);

% Array of potential parent orienations and link with domains
[op, opi] = getVariants(ori, ORmat, CS);
np = length(op);

% Prevent out of memory
if length(op) > 1500
    fprintf('Too much probable parent\n'); return;
end


%% Calculation of probabilities of potential parents

% Angle between potential parents
%  aaa = repmat(op, 1, np);
%  bbb = repmat(reshape(op,1,np), np,1);
%  ma = angle(aaa,bbb);
ma = angle(op\op);

% Check potential parents
%   Pp  - probability of parent
%   rci - relevant child index
%   rvi - relevant varinat index
%   ppo - probable parent orientation
%   Ds  - distance to parent from others
%   Vn  - number of variants
if check_option(varargin, 'onlyFirst')
    [Pp, rci, rvi, ppo, Ds] = CheckFirstParents(1, ma, op, opi, wf, n, np, nv, w0);
else
    [Pp, rci, rvi, ppo, Ds] =      CheckParents(   ma, op, opi, wf, n, np, nv, w0, PRmin, Pmin, VNmin, ori, ORmat, CS);
end

% P = (sum(mm < w0) - mv)/n;
% P = Pp;

%% Find best parent
% Find high probability parents
[Ps,IX] = sort(Pp,'descend');
rci = rci(IX);
rvi = rvi(IX);
ppo = ppo(IX);
Ds  = Ds(IX);

% Max probability
Pmax = Ps(1);
opf = mean(ppo{1});
% opf = ppo{1};
% vnum = rvi{1};
vnum0 = checkVariants(opf, ORmat, CS, ori(rci{1}));
vn = length(unique(vnum0));

debugInfo001(ppo, opf);

% If have only one parent
[goodProbRatio, PR] = checkRatio(Ps, PRmin, Pmin, vn, VNmin);
if goodProbRatio
    gind = rci{1};
    vnum = vnum0;
    op   = ppo{1};
    

    
    if (isfulldebug)
        hf = figure; plotpdf(getVariants(opf, inv(ORmat), CS), Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'b')
        hold on; plotpdf(ori(gind),Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'g');
        hold on; plotpdf(ori(~gind),Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'k');
        hold on; plotpdf(ppo{1},Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'r');
        hold off;
        close(hf);
    end;
    
    gind2 = [];
    for i = gind
        gind2 = [gind2 gi{i}]; %#ok<AGROW>
    end
    
    gind = gind2;
    
    if (length(gind) > length(ori0))
        disp('Test!');
    end
else
	opf = 0;
end

% Debug information
dprintf(1,'%d-%d-%3.1f\n', n, Pmax, PR);
end


function [bool, PR] = checkRatio(PS, PRmin, Pmin, vn, VNmin)
% Calculate the ratio of parent probabilities
%
% Input
%   PS      - probabilities
%   PRmin   - minimal probability ratio
%   Pmin    - minimal probability value
%   vn      - number of variants
%   VNmin   - minimal number of variants

if (PS(2) ~= 0)
    PR = PS(1)/PS(2);
else
    PR = 100*PS(1);
end

bool = (PR > PRmin) && (PS(1) >= Pmin) && (vn > VNmin);

end


function [ori, c, g] = closeOrientation(ori0, n, thr)
% Combine close orientations in groups
%   Return array of far orientation. Close orientations are combine in 
%   group and replace by mean value. Array 'c' contain number of 
%   orientations in group, 'g' - indices of orientations in group.

ori = ori0;

% Find close domains. It's not add new information.
i = 1;
g = cell(1,n);  % orientation group
oi = 1:n;       % orientation index

while i <= n
    md = (angle(ori\ori(i)) < thr)';
    g{i} = oi(md);
    if sum(md) > 1
        ori(i) = mean(ori(md));
        md(i) = 0;
        ori = ori(~md);
        oi = oi(~md);
        n = length(ori);
    end
    i = i+1;
end

% Calc count of orientations in groups
c = zeros(1,n);
for i = 1:n
    c(i) = length(g{i});
end

g = g(1:n);
end

function [Pp, rci, rvi, ppo, Ds] = CheckParents(ma, op, opi, wf, n, np, nv, w0, PRmin, Pmin, VNmin, ori, ORmat, CS)
% !!!Important: May have problem this symmetry (not checked). Let's think:
% if all children are from one parent orientation. We can reconstructe
% parent orientation with resepect to symmetry.
%
% Output
%   Pp  - probability of parent
%   rci - relevant child index
%   rvi - relevant varinat index
%   ppo - probable parent orientation
%   Ds  - distance to parent from others
%
% Input
%   ma  - misorientation between possible parents
%   op  - orientation of possible parents
%   opi - possible parents index (see getVariants)
%   wf  - normalized wiegth function
%   n   - number of orientation 
%   np  - number of parents
%   nv  - number of varinats
%   w0  - maximal deviation between parents
%   VNmin   - minimal number of variants
%   ori     - set of child orienations
%   ORmat   - orientation relation matrix (from alpha to gamma)
%   CS      - crystal symmetry

if (0)
    % Probability of potential parents
    Pp  = zeros(1,np);  % probability of parent
    Ds  = zeros(1,np);  % probable parent orientation 
    rci = cell(1,np);   % relevant child index
    rvi = cell(1,np);   % relevant varinat index
    ppo = cell(1,np);   % probable parent orientation 

    for i = 1:n
        j = (i-1)*nv+(1:nv);
        [Pp(j), rci(j), rvi(j), ppo(j), Ds(j)] = CheckFirstParents(i, ma, op, opi, wf, n, np, nv, w0);
    end
else
    % Probability of potential parents
    iPp  = cell(1,n);   % probability of parent
    iDs  = cell(1,n);   % probable parent orientation
    irci = cell(1,n);   % relevant child index
    irvi = cell(1,n);   % relevant varinat index
    ippo = cell(1,n);   % probable parent orientation 

    bad = zeros(1,n);
    Pi = zeros(1,n);
    Pmax = 0;
    imax = 0;

    for i = 1:n
        [Pp, rci, rvi, ppo, Ds] = CheckFirstParents(i, ma, op, opi, wf, n, np, nv, w0);

        [Ps,IX] = sort(Pp,'descend');
        rci = rci(IX);
        rvi = rvi(IX);
        ppo = ppo(IX);
        Ds  = Ds(IX);

        opf = mean(ppo{1});
        vnum0 = checkVariants(opf, ORmat, CS, ori(rci{1}));
        vn = length(unique(vnum0));
        [goodProbRatio, PR] = checkRatio(Ps, PRmin, Pmin, vn, VNmin);

        if goodProbRatio
            if (Ps(1) > Pmax)
                Pmax  = Ps(1);
                imax  = i;
            end
            
            Pi(i) = Ps(1);
            iPp{i}  = Ps;
            irci{i} = rci;
            irvi{i} = rvi;
            ippo{i} = ppo;
            iDs{i}  = Ds;
        else
            bad(i) = 1;
        end
    end
    
    Pp  = iPp{imax};
    rci = irci{imax};
    rvi = irvi{imax};
    ppo = ippo{imax};
    Ds  = iDs{imax};
end
end


function [Pp, rci, rvi, ppo, Ds] = CheckFirstParents(i, ma, op, opi, wf, n, np, nv, w0)
% !!!Important: this method check only possible parent of first child. Also
%   this method ignores only real distance between parent, only hitting in 
%   'w0' region.
%
% Output
%   Pp  - probability of parent
%   rci - relevant child index
%   rvi - relevant varinat index
%   ppo - probable parent orientation
%   Ds  - distance to parent from others
% 
% Input
%   ma  - misorientation between possible parents
%   op  - orientation of possible parents
%   opi - possible parents index (see getVariants)
%   wf  - weigth function
%   n   - number of orientation 
%   np  - number of parents
%   nv  - number of varinats
%   w0  - maximal deviation between parents

% Probability of potential parents
Pp  = zeros(1,nv);  % probability of parent
Ds  = zeros(1,nv);  % distance to parent from others
rci = cell(1,nv);   % relevant child index
rvi = cell(1,nv);   % relevant varinat index
ppo = cell(1,nv);   % probable parent orientation 

% Look over probable parents and count related children for first child. So
% we check only variants of parents for first child.
i1 = find(opi == i);
for k = 1:nv
    i = i1(k);   % index of current parent orientation
    ic = opi(i); % child id (equal 1)
    iv = fix((i-1)/n)+1; % variant id (equal k)
    
    % Get Remove itself misorientation
    ma1 = ma(i,opi ~= ic); % 1 x (nv*(n-1))
    cl = (1:n ~= ic); % new child logical index for ma1
    ci = find(cl); % new child index for ma1
    
    % Associate misorientation with child
    ma1 = reshape(ma1, n-1, nv); % (n-1) x nv
    
    % !!! Where we can lose variants
    % Minimal misorientation for each child (in row, return column)
    [ma2, ma2i] = min(ma1,[],2); % (n-1) x 1
    
    rcl    = (ma2 < w0)';       % related child logical index 
    rci{k} = [ic ci(rcl)];      % related child index
    rvi{k} = [iv ma2i(rcl)'];   % index of variant referred to related child
    
    % Number of related child within w0 tolerance. Remember about close
    % orientation removed at start and current child.
    Pp(k) = sum(wf(rci{k}));
    Ds(k) = sum(ma2(rcl))/length(Pp(k)); % sum of distances between parents
    
    % Calc indices of parent orientation, based on varinat and child numbers
    ppi = (rvi{k}-1)*n+rci{k};
    
    % Get orientation of parents
    ppo{k} = op(ppi);
    
    if (isfulldebug && 0)
        % changes ori to op
        hf = figure; plotpdf(op(rci{k}), Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        hold on; plotpdf(ppo{k},Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        hold off;
        close(hf);
    end
    
end

end


function debugInfo001(ppo, opf)

if (isfulldebug)
    h1 = figure;
    ouppp = cellfun(@(x) mean(x),ppo(1:4), 'UniformOutput', false);
    ouppp = [ouppp{:}];
    plotpdf(ouppp,Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'g');
    hold on;
    plotpdf(opf,Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'r');
    hold off;
    close(h1);
end
end