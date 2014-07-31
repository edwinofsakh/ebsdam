function [ngv] = parent_v2(grains, OR_name, eps)
%parent_v1 Find prior austenite grains useing info about grains pair.
%   Compare misoreantion of mean grains' orientation with misorientation
%   between variants of oreantation relatinon.
%	Arguments:
%   	type - compare mechanism.
%           1 - angle only ( eps1 );
%           2 - angle and axe (eps1 and eps2);
%           3 - disorientation.
%

% Pairs of grains
[~, pairs] = neighbors(grains);

% Number of grains
n = numel(grains);

% Number of pairs
n2 = length(pairs);

% Calculate misorenation between variants of oreintation relation.
[~,~,dis,~] = calcKOG_new(OR_name);

% Number of variants
nv = length(dis);

% Information about pairs:
%   1 - max variant frequency;
%   2 - number of variant.
pairs_stat = zeros(1,n2);

% Number of misorientation for every pair
nmis = zeros(n2,1);

% Minumal frequency
d_nav = 0.2;

% Frequency for good variant
d_ngv = 0.9;

ngv = zeros(n2,1);

v_maps = cell(1,n2);

h = waitbar(0,'Please wait...');
for i = 1:n2
    % Get misorientation between grains
    mis = calcMisorientation(grains(pairs(i,1)),grains(pairs(i,2)));
    nmis(i) = numel(mis);
    
    % Variants' frequency
    v_f = zeros(nv,1);
    
    %
    v_map = zeros(nmis(i),nv);

    % Find match with OR's misorientation
    for j = 1:nv
        [ind,d] = find(mis,dis(j),eps);
        % ind = angle(mis\dis(j)) < 1.2*eps;
        v_map(:,j) = ind;
        v_f(j) = length(find(ind))/nmis(i);
    end
    
    % Number of acvite variants
    nav = length(find(v_f > d_nav));
    
    % Number of good variants
    ngv(i) = length(find(v_f > d_ngv));
    
%     if ngv(i) == 0
%         v_fm = sum(v_map(:,v_f > d_nav),2);
%         
%         % find multi variantsfind(v_fm - min(v_fm));
%         if (v_fm - min(v_fm) < )
%     end
    
    v_maps{i} = v_map;
    waitbar(i/n2, h);
end
delete(h);

save('v_maps.mat','v_maps', 'ngv', 'pairs');

[group, cmap] = merge_grains( pairs(ngv > 0,:), n );

plot(grains, 'property',cmap(group,:));
hold on, plotBoundary(grains,'property','angle','linewidth',1.5,'extern');
colorbar
hold off