function [Pmax, PR, opf, gind, op, vnum] = findUniqueParent(ori0, wf0, ORmat, thr, Nv, w0, PRm, varargin)
% Find unique parent for orientations.
%   Close orientations with misorientation less than 'thr' will be 
%   combined in group for reduce the amount of calculation. For group 
%   calculate possible parents.
%
% Syntax
%   [Pmax, PR, opf, gind, op, vnum] = findUniqueParent(ori0, ORmat, thr, Nv, w0, PRm)
%
% Output
%   Pmax    - maximal parent probability
%   PR      - first to second probability ratio
%   opf     - orientation of unique parent, 0 if not find
%   gind    - grains in fragment
%   op      - orientation of parents
%   vnum    - number of varinats
% 
% Input
%   ori0    - set of orienations
%   wf0     - wiegth function
%   ORmat   - orientation relation matrix (from alpha to gamma)
%   thr     - orientation integration threshold in radian
%   Nv      - minimal number of variant
%   w0      - tolerance (in radian)
%   PRm     - minimal probability ratio
%
% Options
%   'onlyFirst' - check only parents of first child (usefull if all grains 
%                   will be checked).
%   'combineClose' - combine close orientations
% 
% History
% 17.04.13  Change 'ORname' to 'ORmat'. Fix comments.
% 28.07.14  Add 'varargin'. Add options 'onlyFirst', 'combineClose'. Some
%           makeups.


%% Prepare
Pmax = 0;
PR   = 0;
opf  = 0;
gind = 0;
op   = 0;
vnum = 0;

% Normalize weight function
wf0  = wf0/sum(wf0);

% Check number of variants. Now only number of domains.
n0 = length(ori0);
if n0 < Nv
    dprintf(1,'Too few variants\n'); return;
end

if check_option(varargin, 'combineClose')
    % Group close orientation
    [ori, gc, gi] = closeOrientation(ori0, n0, thr);
    n = length(ori);
    dprintf(1,['Number of orientation was changed from ' int2str(n0) ' to ' int2str(n) ' \n']);
else
    ori = ori0;
    gc  = ones(1,n0);
    gi  = num2cell(1:n0);
    n   = n0;
end

wf = cellfun(@(x) sum(wf0(x)),gi);

% Check number of variants
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


%% Calucate probability of potential parents

% Angle between potential parents
ma = angle(op\op);

%   Pp  - probability of parent
%   rci - relevant child index
%   rvi - relevant varinat index
%   ppo - probable parent orientation
if check_option(varargin, 'onlyFirst')
    [Pp, Ppw, rci, rvi, ppo, Ds] = CheckFirstParents(ma, op, opi, wf, gc, n, np, nv, w0);
else
    [Pp, rci, rvi, ppo] = CheckParents(ma, op, opi, wf, gc, n, np, nv, w0);
end

% P = (sum(mm < w0) - mv)/n;
% P = Pp;

%% Find best parent
% Find high probability parents
[Ps,IX]   = sort(Pp,'descend');
[Psw,IXw] = sort(Ppw,'descend');
Ds = Ds(IX);

% Max probability
Pmax = Ps(1);
opf = mean(ppo{IX(1)});

if (isfulldebug)
    figure;
    ouppp = cellfun(@(x) mean(x),ppo(IX(1:4)), 'UniformOutput', false);
    ouppp = [ouppp{:}];
    plotpdf(ouppp,Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'g');
    hold on;
    plotpdf(opf,Miller(1,0,0), 'antipodal', 'MarkerSize',4, 'MarkerColor', 'r');
    hold off;
end

% Calc parent rate
if (Ps(2) ~= 0)
    PR = Ps(1)/Ps(2);
else
    PR = 100*Ps(1);
end

% If have only one parent
if ((PR > PRm) && (Ps(1) >= Nv))
    gind = rci{IX(1)};
    vnum = rvi{IX(1)};
    op   = ppo{IX(1)};
    
    if (isfulldebug)
        hf = figure; plotpdf(getVariants(opf, inv(ORmat), CS), Miller(1,0,0), 'antipodal', 'MarkerSize',4)
        hold on; plotpdf(ori(gind),Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        hold on; plotpdf(ori(~gind),Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        hold on; plotpdf(ppo{IX(1)},Miller(1,0,0), 'antipodal', 'MarkerSize',4);
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

end

function [Pp, rci, rvi, ppo] = CheckParents(ma, op, opi, wf, gc, n, np, nv, w0)
% !!!Important: May have problem this symmetry (not checked). Let's think:
% if all children are from one parent orientation. We can reconstructe
% parent orientation with resepect to symmetry.
%
% Output
%   Pp  - probability of parent
%   rci - relevant child index
%   rvi - relevant varinat index
%   ppo - probable parent orientation
%
% Input
%   ma  - misorientation between possible parents
%   op  - orientation between possible parents
%   opi - possible parents index (see getVariants)
%   wf  - normalized wiegth function
%   gc  - orientation weight after combination in group (see closeOrientation)
%   n   - number of orientation 
%   np  - number of parents
%   nv  - number of varinats
%   w0  - maximal deviation between parents

% Probability of potential parents
Pp  = zeros(1,np);  % probability of parent
rci = cell(1,np);   % relevant child index
rvi = cell(1,np);   % relevant varinat index
ppo = cell(1,np);   % probable parent orientation 

% Look over probable parents and count related children
for i = 1:np
    ic = opi(i); % child id of 
    iv = fix((i-1)/n)+1; % symmetry variant id
    
    % Remove itself misorientation
    ma1 = ma(i,opi ~= ic); % 1 x (nv*(n-1))
    cl = (1:n ~= ic); % new child logical index for ma1
    ci = find(cl); % new child index for ma1
    
    % Associate misorientation with child
    ma1 = reshape(ma1, n-1, nv); % (n-1) x nv
    
    % Minimal misorientation for each child (in row, return column)
    [ma1, ma1i] = min(ma1,[],2); % (n-1) x 1 
    
    rcl = (ma1 < w0)'; % related child logical index
    rci{i} = [ic ci(rcl)]; % related child index
    rvi{i} = [iv ma1i(rcl)']; % index of variant referred to related child
    
    % Number of related child within w0 tolerance. Remember about close
    % orientation removed at start and current child.
    Pd = (rcl).*gc(cl);
    Pp(i) = 1 + sum(Pd); % probability or parent
    ppi = (rvi{i}-1)*n+rci{i};
    if any(length(op) < ppi)
        disp('Test!');
    end
    ppo{i} = op([i ppi]);
    
    if (isfulldebug && 0)
        % changes ori to op
        hf = figure; plotpdf(op(rci{i}), Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        hold on; plotpdf(ppo{i},Miller(1,0,0), 'antipodal', 'MarkerSize',4);
        hold off;
        close(hf);
    end;
    
%     % Save child ids
%     mind = opi(opi ~= opi(i));
%     mind = mind(1:n-1);
%     Pi(mind(sum(Vv11) > 0),i) = 1;
end

end


function [Pp, Ppw, rci, rvi, ppo, Ds] = CheckFirstParents(ma, op, opi, wf, gc, n, np, nv, w0)
% !!!Important: this method check only possible parent of first child. Also
%   this method ignores only real distance between paren, only hitting in 
%   'w0' region.   

% Output
%   Pp  - probability of parent
%   Ppw - probability of parent weighted
%   rci - relevant child index
%   rvi - relevant varinat index
%   ppo - probable parent orientation
% 
% Input
%   ma  - misorientation between possible parents
%   op  - orientation between possible parents
%   opi - possible parents index (see getVariants)
%   wf  - normalized wiegth function
%   gc  - orientation weight after combination in group (see closeOrientation)
%   n   - number of orientation 
%   np  - number of parents
%   nv  - number of varinats
%   w0  - maximal deviation between parents

% Probability of potential parents
Pp  = zeros(1,nv);  % probability of parent
Ppw = zeros(1,nv);  % probability of parent weighted
Ds  = zeros(1,nv);  % distance to parent from others
rci = cell(1,nv);   % relevant child index
rvi = cell(1,nv);   % relevant varinat index
ppo = cell(1,nv);   % probable parent orientation 

% Look over probable parents and count related children for first child. So
% we check only variants of parents for first child.
i1 = find(opi == 1);
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
    Pd = (rcl).*gc(cl);
    Pp(k) = gc(ic) + sum(Pd); % probability or parent
    Ppw(k)= sum(wf(rci{k}));
    c = gc(cl);
    Ds(k) = sum((ma2(rcl)').*c(rcl))/Pp(k); % sum of distances between parents
    
    % Calc index of parent orientation, based on varinat and child numbers
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
