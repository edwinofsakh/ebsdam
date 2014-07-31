function [v_maps] = parent_v2_prepare(sid, grains, OR_name, fsave, comment, meanmis)
% Prepare boundary data.
%   Calculate distance between boundary and OR misorientations. Save
%   results to file [sid '_v_maps.mat'].

%   Find prior austenite grains useing info about grains pair.
%   Compare misoreantion of mean grains' orientation with misorientation
%   between variants of oreantation relatinon.

%	Arguments:
%       sid - sample's name
%       grains - grains data
%       OR_name - name of Orientation Relation
%   	type - compare mechanism.
%           1 - angle only ( eps1 );
%           2 - angle and axe (eps1 and eps2);
%           3 - disorientation.
%   Example:
%       parent_v2_prepare('p01', grains, 'V1')
%
% History
% 23.10.12 Add 'mean misorientation' case.

% Pairs of grains
[~, pairs] = neighbors(grains);

% Number of pairs
n2 = length(pairs);

% Calculate misorenation between variants of oreintation relation.
[~,~,dis,~] = calcKOG_new(OR_name);

% Number of variants
nv = length(dis);

if meanmis
    % Distance between misorientation and variants
    v_maps = zeros(n2,nv);

    % Pairs of grains
    [~, pairs] = neighbors(grains);

    % Mean orientation of grains
    o = get(grains, 'mean');

    % Get misorientation
    m = getMis( o, pairs );

%     for i = 1:n2
        % Find match with OR's misorientation
        for j = 1:nv
            d = dot_outer(m,dis(j));
            v_maps(:,j) = d;
        end
%     end
else
    % Distance between misorientation and variants
    v_maps = cell(1,n2);

    h = waitbar(0,'Please wait...');
    for i = 1:n2
        % Get misorientation between grains
        mis = calcMisorientation(grains(pairs(i,1)),grains(pairs(i,2)));
        nm = numel(mis);

        % Distance between misorientation and variants
        v_map = zeros(nm,nv);

        % Find match with OR's misorientation
        for j = 1:nv
            d = dot_outer(mis,dis(j));
            v_map(:,j) = d;
        end

        v_maps{i} = v_map;

        waitbar(i/n2, h);
    end
    delete(h);
end

if fsave == 1
    save([sid '_' OR_name '_v_maps.mat'], 'meanmis','v_maps', 'pairs', 'OR_name', 'comment');
end
