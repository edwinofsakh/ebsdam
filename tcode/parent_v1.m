function [group] = parent_v1(grains, OR_name, eps1, eps2, type)
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

% ind = n2:-1:1;
% pairs = pairs(ind,:);

% Mean orientation of grains
o = get(grains, 'mean');

% Convert to rotation (indexing of orentation work not good)
r = rotation(o);
rr = r(pairs(:,1));
rl = r(pairs(:,2));

% Convert back to oreination (angle between orieantion is minimal)
ol = orientation(rl,get(o,'CS'),get(o,'SS'));
or = orientation(rr,get(o,'CS'),get(o,'SS'));

% Calculate misoreintation
m = ol.\or;
ma1 = angle(m)/degree;
ma2 = axis(m);

% Calculate misorenation between variants of oreintation relation.
[~,~,dis,udis] = calcKOG_new(OR_name);
dis = dis(2:end);
disa1 = angle(dis)/degree;
disa2 = axis(dis);

% Number of variants
nv = length(dis);

s_ind = zeros(1,n2);
% find speciall boundary
h = waitbar(0,'Please wait...');
for i = 1:nv
%     epsilon = angle(dis(i))*eps/100;
%     e_d = epsilon/degree;
%    [ind,d] = find(rotation(m),rotation(dis(i)),epsilon);
    
%     % small misorientation
%     ind_s = angle(m) < eps_b*degree;
%     s_ind(ind_s) = 1;
    
    
    % special misorientation
%     ind = angle(m\dis(i)) < epsilon;
    switch type
        case 1
            ind = abs(ma1-disa1(i)) < eps1;
        case 2
            ind1 = abs(ma1-disa1(i)) < eps1;
            ind2 = abs(angle(ma2,disa2(i))/degree) < eps2;
            ind = ind1 | ind2;
        case 3
            ind = abs(angle(m\dis(i))/degree) < eps1;
        otherwise
            warning('Unexpected type.');
    end
    s_ind(ind) = 1;
    
    waitbar(i/nv);
end
close(h)

s_pairs = pairs(logical(s_ind),:);
% group = [1:n];
% group_m = zeros(1,n);
% 
% ns2 = length(s_pairs); % number of special pairs
% 
% for i=1:ns2
%     gl = s_pairs(i,1);
%     gr = s_pairs(i,2);
%     group_m(gl) = 1;
%     group_m(gr) = 1;
%     if (group(gr) ~= group(gl))
%         group(group == group(gr)) = group(gl);
%     end
% end
% 
% group = group.*group_m;
[ group, cmap ] = merge_grains( pairs, n );

% c = group'/max(group);
plot(grains, 'property',cmap(group,:));
hold on, plotBoundary(grains,'property','angle','linewidth',1.5,'extern');
colorbar
hold off

disp(['Number of group:' num2str(length(ug))]);